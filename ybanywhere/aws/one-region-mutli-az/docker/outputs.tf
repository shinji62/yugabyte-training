output "yugabyte_anywhere_public_ip" {
  value       = aws_instance.yb_anywhere_instance.public_ip
  description = "Public IP of your Yugabyte anywhere"
}

output "yugabyte_anywhere_vpc_id" {
  value       = module.vpc.vpc_id
  description = "Id of the VPC where Yugabyte Anywhere is installed, could be use the configure the provider"
}

output "yugabyte_anywhere_security_group_id" {
  value       = aws_security_group.yb_sg.id
  description = "Id of the Security Group where Yugabyte Anywhere is installed, could be use the configure the provider"
}

output "yugabyte_anywhere_subnets_az_mapping" {
  value       = local.private_subnet_mapping
  description = "Mapping of subnet to AZ, could be use the configure the provider"
}
