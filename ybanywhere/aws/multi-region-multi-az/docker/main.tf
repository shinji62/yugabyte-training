// Create VPC with 3 AZ 
// 3 Private/Public subnet and one NAT gw by AZ

module "r1" {
  source              = "./vpc-by-region"
  aws_region          = var.aws_region_1
  default_tags        = var.default_tags
  resource_prefix     = var.resource_prefix
  vpc_cidr_block      = "10.1.0.0/16"
  private_subnet_cidr = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
  public_subnet_cidr  = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
  allowed_sources     = concat(["10.0.0.0/8"], var.allowed_sources)

  create_yba_instances = true
  ssh_keypair_name     = var.ssh_keypair_name
  license_path         = var.license_path
}

module "r2" {
  source              = "./vpc-by-region"
  aws_region          = var.aws_region_2
  default_tags        = var.default_tags
  resource_prefix     = var.resource_prefix
  vpc_cidr_block      = "10.2.0.0/16"
  private_subnet_cidr = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24"]
  public_subnet_cidr  = ["10.2.3.0/24", "10.2.4.0/24", "10.2.5.0/24"]
  allowed_sources     = concat(["10.0.0.0/8"], var.allowed_sources)
  ssh_keypair_name    = null
  license_path        = null
}
module "r3" {
  source              = "./vpc-by-region"
  aws_region          = var.aws_region_3
  default_tags        = var.default_tags
  resource_prefix     = var.resource_prefix
  vpc_cidr_block      = "10.3.0.0/16"
  private_subnet_cidr = ["10.3.0.0/24", "10.3.1.0/24", "10.3.2.0/24"]
  public_subnet_cidr  = ["10.3.3.0/24", "10.3.4.0/24", "10.3.5.0/24"]
  allowed_sources     = concat(["10.0.0.0/8"], var.allowed_sources)
  ssh_keypair_name    = null
  license_path        = null
}


# Peering

#Peering r1-r2
module "vpc-peering-r1-r2" {
  source  = "grem11n/vpc-peering/aws"
  version = "5.0.0"

  providers = {
    aws.this = aws.region-1
    aws.peer = aws.region-2
  }

  this_vpc_id = module.r1.yugabyte_anywhere_vpc_id
  peer_vpc_id = module.r2.yugabyte_anywhere_vpc_id

  auto_accept_peering = true

  tags = {
    Name = "${var.resource_prefix}-${var.aws_region_1}-${var.aws_region_2}-peering"
  }
}


module "vpc-peering-r1-r3" {
  source  = "grem11n/vpc-peering/aws"
  version = "5.0.0"

  providers = {
    aws.this = aws.region-1
    aws.peer = aws.region-3
  }

  this_vpc_id = module.r1.yugabyte_anywhere_vpc_id
  peer_vpc_id = module.r3.yugabyte_anywhere_vpc_id

  auto_accept_peering = true

  tags = {
    Name = "${var.resource_prefix}-${var.aws_region_1}-${var.aws_region_3}-peering"
  }
}



module "vpc-peering-r2-r3" {
  source  = "grem11n/vpc-peering/aws"
  version = "5.0.0"

  providers = {
    aws.this = aws.region-2
    aws.peer = aws.region-3
  }

  this_vpc_id = module.r2.yugabyte_anywhere_vpc_id
  peer_vpc_id = module.r3.yugabyte_anywhere_vpc_id

  auto_accept_peering = true

  tags = {
    Name = "${var.resource_prefix}-${var.aws_region_2}-${var.aws_region_3}-peering"
  }
}

