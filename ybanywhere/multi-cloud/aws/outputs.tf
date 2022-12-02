output "aws_vpn_gateway_id" {
  value       = module.aws-one-region.vpn_gateway_id
  description = "Vpn Gateway ID"
}


output "aws_region_output" {
  description = "Region"
  value = {
    "region" = {
      "yugabyte_anywhere_region"             = module.aws-one-region.yugabyte_anywhere_region,
      "yugabyte_anywhere_security_group_id"  = module.aws-one-region.yugabyte_anywhere_node_security_group_id
      "yugabyte_anywhere_subnets_az_mapping" = module.aws-one-region.yugabyte_anywhere_subnets_az_mapping
      "yugabyte_anywhere_vpc_id"             = module.aws-one-region.yugabyte_anywhere_vpc_id,
      "yugabyte_anywhere_ip"                 = module.aws-one-region.yugabyte_anywhere_ip
    },
  }
}


output "aws_node_on_prem" {
  value = module.aws-one-region.node_on_prem
}
