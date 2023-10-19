module "gcp-vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 5.2"
  project_id   = var.project_id # Replace this with your project ID in quotes
  network_name = local.name_prefix
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "${local.name_prefix}-${var.gcp_region}-subnet"
      subnet_ip     = "10.1.0.0/16"
      subnet_region = var.gcp_region
    }
  ]
}


resource "google_compute_firewall" "yb_anywhere_db_node" {
  name    = "${local.name_prefix}-yba-db-node"
  network = module.gcp-vpc.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = local.yb_ports
  }

  source_tags   = ["yb-db-node", "yb-anywhere-inst"]
  target_tags   = ["yb-db-node"]
  source_ranges = local.allowed_sources
}


resource "google_compute_firewall" "yb_anywhere_inst" {
  name    = "${local.name_prefix}-yba-inst-fw"
  network = module.gcp-vpc.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = local.yb_anywhere_port
  }

  source_tags   = ["yb-db-node"]
  target_tags   = ["yb-anywhere-inst","yb-db-node"]
  source_ranges = local.allowed_sources
}


