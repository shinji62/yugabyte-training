module "aws-one-region" {
  source              = "../../aws/multi-region-multi-az/docker/vpc-by-region"
  aws_region          = var.aws_region
  default_tags        = var.default_tags
  resource_prefix     = var.resource_prefix
  vpc_cidr_block      = "10.1.0.0/16"
  private_subnet_cidr = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
  public_subnet_cidr  = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
  allowed_sources     = concat(["10.0.0.0/8"], var.allowed_sources)

  create_yba_instances               = var.create_yba_instances
  ssh_keypair_name                   = var.ssh_keypair_name
  license_path                       = var.license_path
  replicated_password                = var.replicated_password
  replicated_seq_number              = var.replicated_seq_number
  node_on_prem_test                  = var.node_on_prem_test
  enable_vpn_gateway                 = true
  propagate_private_route_tables_vgw = true
  propagate_public_route_tables_vgw  = true
  node_on_prem_public_key_path       = var.node_on_prem_public_key_path
}
