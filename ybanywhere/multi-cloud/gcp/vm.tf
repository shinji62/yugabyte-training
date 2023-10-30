data "google_compute_image" "ubuntu2004" {
  project = "ubuntu-os-cloud"
  name    = var.vm_image
}


# Node VM to test on-prem cloud provider with GCP VM


#tfsec:ignore:google-compute-disk-encryption-customer-key
resource "google_compute_disk" "yb_node_disk" {
  count   = var.node_on_prem_test
  project = var.project_id
  name    = "${local.name_prefix}-${var.gcp_region}-${element(local.gcp-az, count.index)}-disk"
  type    = "pd-ssd"
  zone    = "${var.gcp_region}-${element(local.gcp-az, count.index)}"
  size    = var.volume_size
}



#tfsec:ignore:google-compute-enable-shielded-vm-im
#tfsec:ignore:google-compute-enable-shielded-vm-vtpm
#tfsec:ignore:google-compute-no-project-wide-ssh-keys
resource "google_compute_instance" "yugabyte_node_instances" {
  count        = var.node_on_prem_test
  name         = "${local.name_prefix}-yb-node-inst-${count.index}"
  machine_type = var.instance_type
  // If single region we distrubte accross AZ
  zone = "${var.gcp_region}-${element(local.gcp-az, count.index)}"
  tags = ["yb-db-node"]
  #tfsec:ignore:google-compute-vm-disk-encryption-customer-key
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu2004.self_link
    }
  }
  labels = var.default_tags

  attached_disk {
    source      = google_compute_disk.yb_node_disk[count.index].id
    device_name = "node-m-disk"
  }

  metadata = {
    user-data = templatefile(
      "${path.module}/scripts/cloud-init-node.yml.tpl",
      {
        public_key_node = file(local.node_ssh_key)
      }
    )
  }
  depends_on = [google_compute_firewall.yb_anywhere_db_node, google_compute_firewall.yb_anywhere_inst, google_project_iam_member.project]
  network_interface {
    subnetwork = module.gcp-vpc.subnets_names[0]
  }
}
