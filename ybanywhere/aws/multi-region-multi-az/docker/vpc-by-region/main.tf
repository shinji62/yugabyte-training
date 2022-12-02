// Locals and other required data
locals {
  name_prefix      = var.resource_prefix
  region           = var.aws_region
  yb_anywhere_port = [22, 80, 8800, 9090, 54422]
  yb_ports         = [22, 5433, 6379, 7000, 7100, 9000, 9100, 9300, 9042, 11000, 14000, 18018, 54422]
  allowed_sources  = concat(var.allowed_sources, [module.vpc.vpc_cidr_block])

  vpc_subnet_mapping = { for k, az in(module.vpc.azs) : az => {
    private_subnet = module.vpc.private_subnets[k]
    public_subnet  = module.vpc.public_subnets[k]
    }
  }
  replicated_password = (var.replicated_password != null ? var.replicated_password : random_password.replicated_password.result)
  node_ssh_key        = (var.node_on_prem_public_key_path != null ? var.node_on_prem_public_key_path : "")
}

resource "random_password" "replicated_password" {
  length      = 16
  special     = false
  min_lower   = 5
  min_numeric = 3
  min_upper   = 3
}

//Getting AZ for the regios
data "aws_availability_zones" "available" {
  state = "available"
}

