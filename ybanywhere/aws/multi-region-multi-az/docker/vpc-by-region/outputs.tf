output "yugabyte_anywhere_vpc_id" {
  value       = module.vpc.vpc_id
  description = "Id of the VPC could be use the configure the provider"
}

output "yugabyte_anywhere_node_security_group_id" {
  value       = aws_security_group.yb_sg.id
  description = "Id of the Security Group for Yugabyte Node, could be use the configure the provider"
}

output "yugabyte_anywhere_subnets_az_mapping" {
  value       = local.vpc_subnet_mapping
  description = "Mapping of subnet to AZ, could be use the configure the provider"
}

output "yugabyte_anywhere_region" {
  value       = var.aws_region
  description = "Region where the VPC is created"
}

output "yugabyte_anywhere_ip" {
  value = var.create_yba_instances ? one(aws_instance.yb_anywhere_instance[*].public_ip) : "non_deployed"
}

output "replicated_password" {
  description = "Replicated password to get it please use terraform ouput command "
  value       = local.replicated_password
  sensitive   = true
}


output "node_on_prem" {
  value = { for v in aws_instance.yb_anywhere_node_on_prem :
    v.tags_all["Name"] => {
      "az"         = v.availability_zone
      "public_ip"  = v.public_ip
      "private_ip" = v.private_ip
    }
  }
}

output "vpn_gateway_id" {
  value       = module.vpc.vgw_id
  description = "Vpn Gateway ID"
}
