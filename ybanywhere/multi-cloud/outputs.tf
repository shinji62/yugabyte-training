
output "gcp_node_on_prem" {
  description = "Node for on prem cloud provider testing"
  value       = module.gcp-vpc-vpn-gw.node_on_prem
}

output "AWS" {
  value = {
    "aws_yba"          = module.aws-vpc-vpn-gw.aws_region_output
    "aws_on_prem_node" = module.aws-vpc-vpn-gw.aws_node_on_prem
  }
}

output "AZURE" {
  value = {
    "azure_on_prem_node" = module.azure-vpc-vpn-gw.node_on_prem
  }
}
