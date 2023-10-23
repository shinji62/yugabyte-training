output "region_output" {
  //value       = aws_instance.yb_anywhere_instance.public_ip
  description = "Region"
  value = {
    "region_1" = {
      "yugabyte_anywhere_region"             = module.r1.yugabyte_anywhere_region,
      "yugabyte_anywhere_security_group_id"  = module.r1.yugabyte_anywhere_node_security_group_id
      "yugabyte_anywhere_subnets_az_mapping" = module.r1.yugabyte_anywhere_subnets_az_mapping
      "yugabyte_anywhere_vpc_id"             = module.r1.yugabyte_anywhere_vpc_id,
      "yugabyte_anywhere_ip"                 = module.r1.yugabyte_anywhere_ip,
      "yb_node_on_prem"                      = module.r1.node_on_prem
    },
    "region_2" = {
      "yugabyte_anywhere_region"             = module.r2.yugabyte_anywhere_region,
      "yugabyte_anywhere_security_group_id"  = module.r2.yugabyte_anywhere_node_security_group_id
      "yugabyte_anywhere_subnets_az_mapping" = module.r2.yugabyte_anywhere_subnets_az_mapping
      "yugabyte_anywhere_vpc_id"             = module.r2.yugabyte_anywhere_vpc_id,
      "yugabyte_anywhere_ip"                 = module.r2.yugabyte_anywhere_ip,
      "yb_node_on_prem"                      = module.r2.node_on_prem

    },
    "region_3" = {
      "yugabyte_anywhere_region"             = module.r3.yugabyte_anywhere_region,
      "yugabyte_anywhere_security_group_id"  = module.r3.yugabyte_anywhere_node_security_group_id
      "yugabyte_anywhere_subnets_az_mapping" = module.r3.yugabyte_anywhere_subnets_az_mapping
      "yugabyte_anywhere_vpc_id"             = module.r3.yugabyte_anywhere_vpc_id,
      "yugabyte_anywhere_ip"                 = module.r3.yugabyte_anywhere_ip,
      "yb_node_on_prem"                      = module.r3.node_on_prem

    }
  }
}
