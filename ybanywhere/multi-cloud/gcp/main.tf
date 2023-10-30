locals {
  name_prefix      = var.resource_prefix
  yb_anywhere_port = var.yba_port
  yb_ports         = var.yb_port
  # 35.235.240.0/20 is Cloud IAP
  allowed_sources = concat(var.allowed_sources, ["10.0.0.0/8"], ["35.235.240.0/20"])
  gcp-az          = ["a", "b", "c"]
  node_ssh_key    = (var.node_on_prem_public_key_path != null ? var.node_on_prem_public_key_path : var.public_key_path)
}
