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

output "yugabyte_anywhere_public_ip" {
  value       = one(azurerm_linux_virtual_machine.yba_inst[*].public_ip_address)
  description = "Public IP of your Yugabyte anywhere"
}

output "replicated_password" {
  description = "Replicated password to get it please use terraform ouput command "
  value       = local.replicated_password
  sensitive   = true
}

output "security_group_name" {
  value       = azurerm_network_security_group.yba_sg.name
  description = "Name of the security group"
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
