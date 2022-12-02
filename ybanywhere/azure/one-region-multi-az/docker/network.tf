# VPC are VNET in Azure


resource "azurerm_virtual_network" "yba_vnet" {
  name                = "${local.name_prefix}-yba_vnet"
  location            = local.location
  resource_group_name = local.resource_group
  address_space       = ["10.0.0.0/16"]

  tags = var.default_tags
}


resource "azurerm_subnet" "yba_sub_internal" {
  name                 = "${local.name_prefix}-internal"
  resource_group_name  = local.resource_group
  virtual_network_name = azurerm_virtual_network.yba_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

// Public IP
resource "azurerm_public_ip" "yba_public_ip" {
  count = var.create_yba_instances ? 1 : 0

  name                = "${local.name_prefix}-public-ip"
  location            = local.location
  resource_group_name = local.resource_group
  allocation_method   = "Dynamic"
  tags                = var.default_tags
}

resource "azurerm_network_security_group" "yba_sg" {
  name                = "${local.name_prefix}-sg"
  location            = local.location
  resource_group_name = local.resource_group
  tags                = var.default_tags
}

resource "azurerm_network_security_rule" "yba_rules" {
  name                        = "${local.name_prefix}-allow-yba-sg-rules"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = concat(local.yb_anywhere_port, local.yb_ports)
  source_address_prefixes     = local.allowed_sources
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.yba_sg.name
  resource_group_name         = local.resource_group
}

resource "azurerm_network_security_rule" "icmp_rule" {
  name                        = "${local.name_prefix}-allow-icmp"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = local.allowed_sources
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.yba_sg.name
  resource_group_name         = local.resource_group

}


resource "azurerm_network_interface" "yba_inst_nic" {
  count = var.create_yba_instances ? 1 : 0

  name                = "${local.name_prefix}-yba-nic"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "${local.name_prefix}-yba-nic-config"
    subnet_id                     = azurerm_subnet.yba_sub_internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = one(azurerm_public_ip.yba_public_ip[*].id)
  }
}

resource "azurerm_network_interface_security_group_association" "yba_nic_assoc" {
  count = var.create_yba_instances ? 1 : 0

  network_interface_id      = one(azurerm_network_interface.yba_inst_nic[*].id)
  network_security_group_id = azurerm_network_security_group.yba_sg.id
}


// Node VM Networking 

// Public IP
resource "azurerm_public_ip" "yba_node_public_ip" {
  count               = var.node_on_prem_test
  name                = "${local.name_prefix}-public-ip-${count.index}"
  zones               = [element(local.zones, count.index)]
  location            = local.location
  resource_group_name = local.resource_group
  allocation_method   = "Static"
  tags                = var.default_tags
  sku                 = "Standard"
}


resource "azurerm_network_interface" "yba_node_inst_nic" {
  count               = var.node_on_prem_test
  name                = "${local.name_prefix}-yba-node-nic-${count.index}"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "${local.name_prefix}-yba-node-nic-config-${count.index}"
    subnet_id                     = azurerm_subnet.yba_sub_internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.yba_node_public_ip.*.id, count.index)
  }
}

resource "azurerm_network_interface_security_group_association" "yba_node_nic_assoc" {
  count                     = var.node_on_prem_test
  network_interface_id      = element(azurerm_network_interface.yba_node_inst_nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.yba_sg.id
}
