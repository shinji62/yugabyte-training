// Locals and other required data
locals {
  name_prefix      = var.resource_prefix
  region           = var.aws_region
  yb_anywhere_port = [22, 80, 8800, 9090, 54422]
  yb_ports         = [22, 5433, 6379, 7000, 7100, 9000, 9100, 9300, 9042, 11000, 54422]
  allowed_sources  = concat(var.allowed_sources, [module.vpc.vpc_cidr_block])

  vpc_subnet_mapping = { for k, az in(module.vpc.azs) : az => {
    private_subnet = module.vpc.private_subnets[k]
    public_subnet  = module.vpc.public_subnets[k]
    }
  }
}

//Getting AZ for the regios
data "aws_availability_zones" "available" {
  state = "available"
}

