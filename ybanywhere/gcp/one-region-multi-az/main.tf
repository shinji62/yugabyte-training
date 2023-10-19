locals {
  name_prefix      = var.resource_prefix
  yb_anywhere_port = var.yba_port
  yb_ports         = var.yb_port
  # 35.235.240.0/20 is Cloud IAP
  allowed_sources = concat(var.allowed_sources, module.gcp-vpc.subnets_ips, ["35.235.240.0/20"])
  yba_private_ip  = google_compute_instance.yugabyte_anywhere_instances.network_interface.0.network_ip
  yba_public_ip   = google_compute_instance.yugabyte_anywhere_instances.network_interface.0.access_config.0.nat_ip
}