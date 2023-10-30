module "aws-vpc-vpn-gw" {
  source                       = "./aws"
  allowed_sources              = var.allowed_sources
  aws_region                   = var.aws_region
  create_yba_instances         = var.aws_create_yba_instances
  default_tags                 = var.default_tags
  node_on_prem_public_key_path = var.node_on_prem_public_key_path
  node_on_prem_test            = var.aws_node_on_prem_test
  resource_prefix              = var.resource_prefix
  aws_ssh_keypair_name         = var.aws_ssh_keypair_name
  yba_ssh_public_key_path      = var.yba_ssh_public_key_path
}

module "gcp-vpc-vpn-gw" {
  source                       = "./gcp"
  allowed_sources              = var.allowed_sources
  default_tags                 = var.default_tags
  gcp_region                   = var.gcp_region
  node_on_prem_public_key_path = var.node_on_prem_public_key_path
  node_on_prem_test            = var.gcp_node_on_prem_test
  project_id                   = var.project_id
  public_key_path              = var.node_on_prem_public_key_path
  resource_prefix              = var.resource_prefix
}

module "azure-vpc-vpn-gw" {
  source                       = "./azure"
  allowed_sources              = var.allowed_sources
  azure_location               = var.azure_location
  default_tags                 = var.default_tags
  node_on_prem_public_key_path = var.node_on_prem_public_key_path
  node_on_prem_test            = var.azure_node_on_prem_test
  public_key_path              = var.node_on_prem_public_key_path
  resource_group               = var.azure_resource_group
  resource_prefix              = var.resource_prefix
  subscription_id              = var.subscription_id
  tenant_id                    = var.tenant_id
}

module "vpn" {
  source                   = "./vpn"
  allowed_sources          = var.allowed_sources
  aws_vpn_gateway_id       = module.aws-vpc-vpn-gw.aws_vpn_gateway_id
  default_tags             = var.default_tags
  google_project_id        = var.project_id
  google_region            = var.gcp_region
  resource_prefix          = var.resource_prefix
  google_network_name      = module.gcp-vpc-vpn-gw.google_network_name
  google_subnet_self_links = module.gcp-vpc-vpn-gw.google_subnet_self_links
  azure_location           = var.azure_location
  azure_resource_group     = var.azure_resource_group
  azure_subnet_id          = module.azure-vpc-vpn-gw.azure_subnet_id
}
