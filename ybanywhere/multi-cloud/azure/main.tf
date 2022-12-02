locals {
  name_prefix         = var.resource_prefix
  yb_anywhere_port    = [22, 80, 8800, 9090, 54422]
  yb_ports            = [22, 5433, 6379, 7000, 7100, 9000, 9100, 9300, 9042, 11000, 14000, 18018, 54422]
  allowed_sources     = concat(var.allowed_sources, ["10.0.0.0/16"])
  replicated_password = (var.replicated_password != null ? var.replicated_password : random_password.replicated_password.result)
  now                 = timestamp()
  resource_group      = var.resource_group != null ? var.resource_group : one(azurerm_resource_group.yba_rg[*].name)
  node_ssh_key        = (var.node_on_prem_public_key_path != null ? var.node_on_prem_public_key_path : var.public_key_path)
  location            = var.azure_location
  zones               = var.azure_locations_zone
}

resource "random_password" "replicated_password" {
  length      = 16
  special     = false
  min_lower   = 5
  min_numeric = 3
  min_upper   = 3
}

resource "random_string" "storage_account_name" {
  length  = 16
  special = false
  upper   = false
}

resource "azurerm_resource_group" "yba_rg" {
  count    = var.resource_prefix != null ? 0 : 1
  name     = "${local.name_prefix}-yba-rg"
  location = var.azure_location
}
