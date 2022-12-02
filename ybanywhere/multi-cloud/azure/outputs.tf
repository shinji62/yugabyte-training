
output "azure_subnet_id" {
  value       = azurerm_subnet.yba_sub_gateway.id
  description = "Azure Gateway subnet"
}

output "subscription_id" {
  value       = var.subscription_id
  description = "Azure subscription ID"
}

output "tenant_id" {
  value       = var.tenant_id
  description = "Azure Tenant ID"
}

output "azure_location" {
  value       = var.azure_location
  description = "Azure Location"
}

output "azure_yba" {
  value = {
    "azure_yba" = {
      "location"                    = var.azure_location,
      "vnet_net"                    = azurerm_virtual_network.yba_vnet.name,
      "subnet_name"                 = azurerm_subnet.yba_sub_internal.name
      "resource_group_name"         = local.resource_group,
      "yugabyte_anywhere_public_ip" = var.create_yba_instances ? one(azurerm_linux_virtual_machine.yba_inst[*].public_ip_address) : "non_deployed",
      "security_group_name"         = azurerm_network_security_group.yba_sg.name
    }
  }
}

output "vnet_net" {
  value       = azurerm_virtual_network.yba_vnet.name
  description = "Azure Virtual Network name"
}

output "subnet_name" {
  value       = azurerm_subnet.yba_sub_internal.name
  description = "Azure subnet"
}

output "resource_group_name" {
  value       = local.resource_group
  description = "Azure resource group name"
}


output "azure_replicated_password" {
  description = "Replicated password to get it please use terraform ouput command "
  value       = local.replicated_password
  sensitive   = true
}

output "node_on_prem" {
  description = "Node for on prem cloud provider testing"
  value = { for v in azurerm_linux_virtual_machine.yb_anywhere_node_on_prem :
    v.name => {
      "location"   = v.location
      "az"         = v.zone
      "public_ip"  = v.public_ip_address
      "private_ip" = v.private_ip_address
    }
  }
}
