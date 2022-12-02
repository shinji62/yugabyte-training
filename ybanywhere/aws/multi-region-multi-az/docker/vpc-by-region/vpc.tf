// Create VPC with 3 AZ 
// 3 Private/Public subnet and one NAT gw by AZ

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "${local.name_prefix}-ya"
  cidr = var.vpc_cidr_block

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  create_database_subnet_group = false

  //One NAT Gateway by AZ
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true


  enable_vpn_gateway                 = var.enable_vpn_gateway
  propagate_private_route_tables_vgw = var.propagate_private_route_tables_vgw
  propagate_public_route_tables_vgw  = var.propagate_public_route_tables_vgw
}

