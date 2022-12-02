


resource "azurerm_linux_virtual_machine" "yba_inst" {
  count               = var.create_yba_instances ? 1 : 0
  name                = "${local.name_prefix}-yba-inst"
  location            = local.location
  resource_group_name = local.resource_group
  size                = var.instance_type
  admin_username      = "ubuntu"



  # This is where we pass our cloud-init.
  user_data = base64encode(templatefile(
    "${path.module}/scripts/cloud-init.yml.tpl",
    {
      replicated_conf      = base64encode(file("${path.module}/files/replicated.conf"))
      license_download     = "${one(azurerm_storage_blob.license[*].url)}.${one(data.azurerm_storage_account_blob_container_sas.yba_license_bucket_sas[*].sas)}"
      application_settings = base64encode(file("${path.module}/files/application_settings.conf"))
      replicated_password  = local.replicated_password
    }
    )
  )

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file(var.public_key_path)
  }

  network_interface_ids = [
    one(azurerm_network_interface.yba_inst_nic[*].id)
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.volume_size
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202211151"
  }
  tags = var.default_tags

  lifecycle {
    ignore_changes = [user_data]
  }
}


/*

Azure Node for On Prem Cloud provider

*/



resource "azurerm_linux_virtual_machine" "yb_anywhere_node_on_prem" {
  name                = "${local.name_prefix}-yb-anywhere-${count.index}"
  count               = var.node_on_prem_test
  location            = local.location
  resource_group_name = local.resource_group
  size                = var.node_instance_type
  admin_username      = "ubuntu"
  zone                = element(local.zones, count.index)



  # This is where we pass our cloud-init.
  user_data = base64encode(file("${path.module}/scripts/cloud-init-node.yml"))

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file(local.node_ssh_key)
  }

  network_interface_ids = [
    element(azurerm_network_interface.yba_node_inst_nic.*.id, count.index)
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.volume_size
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202211151"
  }
  tags = var.default_tags
}

resource "azurerm_managed_disk" "yba-data-disk-node" {
  count = var.node_on_prem_test

  name                 = "${local.name_prefix}-data-disk-${count.index}"
  location             = local.location
  resource_group_name  = local.resource_group
  zone                 = element(local.zones, count.index)
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.node_data_disk_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "yba-data-disk-node-attch" {
  count = var.node_on_prem_test

  managed_disk_id    = element(azurerm_managed_disk.yba-data-disk-node.*.id, count.index)
  virtual_machine_id = element(azurerm_linux_virtual_machine.yb_anywhere_node_on_prem.*.id, count.index)
  lun                = "10"
  caching            = "ReadWrite"
}
