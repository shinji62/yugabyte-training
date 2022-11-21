locals {
  name_prefix      = var.resource_prefix
  yb_anywhere_port = [22, 80, 8800, 9090, 54422]
  yb_ports         = [22, 5433, 6379, 7000, 7100, 9000, 9100, 9300, 9042, 11000, 14000, 18018, 54422]
  # 35.235.240.0/20 is Cloud IAP
  allowed_sources     = concat(var.allowed_sources, module.gcp-vpc.subnets_ips, ["35.235.240.0/20"])
  replicated_password = (var.replicated_password != null ? var.replicated_password : random_password.replicated_password.result)
}

resource "random_password" "replicated_password" {
  length      = 16
  special     = false
  min_lower   = 5
  min_numeric = 3
  min_upper   = 3
}
