locals {
  name_prefix      = var.resource_prefix
  yb_anywhere_port = var.yba_port
  yb_ports         = var.yb_port
  allowed_sources  = concat(var.allowed_sources, ["10.0.0.0/16"])
  now              = timestamp()
  resource_group   = var.resource_group != null ? var.resource_group : one(azurerm_resource_group.yba_rg[*].name)
  node_ssh_key     = (var.node_on_prem_public_key_path != null ? var.node_on_prem_public_key_path : var.public_key_path)
  location         = var.azure_location
  zones            = var.azure_locations_zone
}


resource "azurerm_resource_group" "yba_rg" {
  count    = var.resource_prefix != null ? 0 : 1
  name     = "${local.name_prefix}-yba-rg"
  location = var.azure_location
}
