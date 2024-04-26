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

output "azs" {
  value       = module.vpc.azs
  description = "AZ"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "vpc id"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "private subnet"
}

output "backup_bucket" {
  value       = one(aws_s3_bucket.backup_bucket[*].bucket)
  description = "Bucket for Backup"
}


output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}
