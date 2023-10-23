resource "azurerm_storage_account" "yba_storage_account" {
  count                    = var.create_yba_instances ? 1 : 0
  name                     = random_string.storage_account_name.id
  account_tier             = "Standard"
  location                 = local.location
  resource_group_name      = local.resource_group
  account_replication_type = "LRS"
  tags                     = var.default_tags
}


resource "azurerm_storage_container" "yba_license_blob_cont" {
  count                 = var.create_yba_instances ? 1 : 0
  name                  = "${local.name_prefix}-lic-blob"
  storage_account_name  = one(azurerm_storage_account.yba_storage_account[*].name)
  container_access_type = "private"
}


resource "azurerm_storage_blob" "license" {
  count                  = var.create_yba_instances ? 1 : 0
  name                   = "license.rli"
  storage_account_name   = one(azurerm_storage_account.yba_storage_account[*].name)
  storage_container_name = one(azurerm_storage_container.yba_license_blob_cont[*].name)
  type                   = "Block"
  source                 = var.license_path
}



data "azurerm_storage_account_blob_container_sas" "yba_license_bucket_sas" {
  count             = var.create_yba_instances ? 1 : 0
  connection_string = one(azurerm_storage_account.yba_storage_account[*].primary_connection_string)
  container_name    = one(azurerm_storage_container.yba_license_blob_cont[*].name)
  https_only        = true

  start  = timeadd(local.now, "-1h")
  expiry = timeadd(local.now, "2h")

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = true
  }
}
