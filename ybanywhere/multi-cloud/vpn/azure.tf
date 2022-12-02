// Deploy Azure Public IPs
resource "azurerm_public_ip" "azure_1" {
  name                = "${local.name_prefix}-publicip-0"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group

  allocation_method = "Dynamic"

  tags = var.default_tags
}
resource "azurerm_public_ip" "azure_2" {
  name                = "${local.name_prefix}-publicip-1"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group

  allocation_method = "Dynamic"

  tags = var.default_tags
}


data "azurerm_public_ip" "azure_1" {
  name                = azurerm_public_ip.azure_1.name
  resource_group_name = var.azure_resource_group
}

data "azurerm_public_ip" "azure_2" {
  name                = azurerm_public_ip.azure_2.name
  resource_group_name = var.azure_resource_group
}

// Deploy Azure VPN Gateway
// List of SKU's in Azure and expected throughput 
// On the AWS side - VPN is 1.25GB so larger VPN Gateways on Azure won't improve performance
// List of Gateways - https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways#benchmark

resource "azurerm_virtual_network_gateway" "main" {
  name                = "${local.name_prefix}-VNG0"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group

  type          = "Vpn"
  vpn_type      = "RouteBased"
  active_active = true
  enable_bgp    = true
  sku           = "VpnGw3"
  generation    = "Generation1"


  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.azure_1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.azure_subnet_id
  }
  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.azure_2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.azure_subnet_id
  }

  bgp_settings {
    asn = 65515
    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig1"
      apipa_addresses = [
        var.azure_vpn_bgp_peering_address_1,
        var.azure_vpn_bgp_peering_address_2,
      ]
    }
    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig2"
      apipa_addresses = [
        var.azure_vpn_bgp_peering_address_3,
        var.azure_vpn_bgp_peering_address_4,
      ]
    }
  }

  tags = var.default_tags
}

// Azure Cloud Resources
// Deploy Local Gateway
resource "azurerm_local_network_gateway" "azure" {
  name                = "${local.name_prefix}-LNG${each.key}"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group
  for_each            = local.azure_local_network_gateway

  gateway_address = each.value.gateway_address
  bgp_settings {
    asn                 = 64512
    bgp_peering_address = each.value.bgp_peering_address
  }

  tags = var.default_tags
}


// Create Connections
resource "azurerm_virtual_network_gateway_connection" "azure" {
  name                = "${local.name_prefix}-CN${each.key}"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group
  for_each            = local.azure_external_vpn_gateway_interfaces

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id   = each.value.local_network_gateway_id
  shared_key                 = each.value.shared_key
  enable_bgp                 = true

  tags = var.default_tags
}
