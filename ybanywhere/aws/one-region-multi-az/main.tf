// Create VPC with 3 AZ 
// 3 Private/Public subnet and one NAT gw by AZ

module "r1" {
  source              = "../multi-region-multi-az/vpc-by-region"
  aws_region          = var.aws_region
  default_tags        = var.default_tags
  resource_prefix     = var.resource_prefix
  vpc_cidr_block      = "10.1.0.0/16"
  private_subnet_cidr = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
  public_subnet_cidr  = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
  allowed_sources     = concat(["10.0.0.0/8", "221.110.31.103/32"], var.allowed_sources)

  create_yba_instances         = true
  ssh_keypair_name             = var.ssh_keypair_name
  node_on_prem_test            = var.node_on_prem_test
  node_on_prem_public_key_path = var.node_on_prem_public_key_path
  private_subnets_tag          = var.private_subnets_tag
  public_subnets_tag           = var.public_subnets_tag
  yba_public_key_path          = var.node_on_prem_public_key_path
  create_backup_bucket         = true
  create_kms_permission        = false
}


