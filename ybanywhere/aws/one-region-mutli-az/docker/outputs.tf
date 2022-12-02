output "region_output" {
  //value       = aws_instance.yb_anywhere_instance.public_ip
  description = "Region"
  value = {
    "region" = {
      "yugabyte_anywhere_region"             = module.r1.yugabyte_anywhere_region,
      "yugabyte_anywhere_security_group_id"  = module.r1.yugabyte_anywhere_node_security_group_id
      "yugabyte_anywhere_subnets_az_mapping" = module.r1.yugabyte_anywhere_subnets_az_mapping
      "yugabyte_anywhere_vpc_id"             = module.r1.yugabyte_anywhere_vpc_id,
      "yugabyte_anywhere_ip"                 = module.r1.yugabyte_anywhere_ip
    },
  }
}

output "replicated_password" {
  sensitive = true
  value     = module.r1.yugabyte_anywhere_region != "non_deployed" ? module.r1.replicated_password : " "
}

output "node_on_prem" {
  value = module.r1.node_on_prem

}
