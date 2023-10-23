// Locals and other required data
locals {
  name_prefix      = var.resource_prefix
  region           = var.aws_region
  yb_anywhere_port = var.yba_port
  yb_ports         = var.yb_port
  allowed_sources  = concat(var.allowed_sources, [module.vpc.vpc_cidr_block])

  vpc_subnet_mapping = { for k, az in(module.vpc.azs) : az => {
    private_subnet = module.vpc.private_subnets[k]
    public_subnet  = module.vpc.public_subnets[k]
    }
  }
  node_ssh_key       = (var.node_on_prem_public_key_path != null ? var.node_on_prem_public_key_path : "")
  yba_public_ssh_key = (var.yba_public_key_path != null ? var.yba_public_key_path : "")
}

//Getting AZ for the regios
data "aws_availability_zones" "available" {
  state = "available"
}

