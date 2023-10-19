data "google_compute_image" "ubuntu2004" {
  project = "ubuntu-os-cloud"
  name    = var.vm_image
}

#tfsec:ignore:google-compute-disk-encryption-customer-key
resource "google_compute_disk" "yba_boot_disk" {
  project = var.project_id
  name    = "${local.name_prefix}-bd"
  type    = "pd-ssd"
  zone    = "${var.gcp_region}-b"
  size    = var.volume_size
  image   = data.google_compute_image.ubuntu2004.self_link
}



#tfsec:ignore:google-compute-enable-shielded-vm-im
#tfsec:ignore:google-compute-enable-shielded-vm-vtpm
#tfsec:ignore:google-compute-no-project-wide-ssh-keys
resource "google_compute_instance" "yugabyte_anywhere_instances" {
  name         = "${local.name_prefix}-yba-inst"
  machine_type = var.instance_type
  zone         = "${var.gcp_region}-b"
  tags         = ["yb-anywhere-inst", ]
  #tfsec:ignore:google-compute-vm-disk-encryption-customer-key
  boot_disk {
    source = google_compute_disk.yba_boot_disk.name
  }
  labels = var.default_tags

  metadata = {
    user-data = templatefile(
      "${path.module}/scripts/cloud-init.yml.tpl",
      {
        public_key = file(var.yba_ssh_public_key_path)
      }
    )
  }
  service_account {
    email  = google_service_account.sa_yba_instance.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = one(module.gcp-vpc.subnets_names[*])
    access_config {
      // Ephemeral IP
    }
  }
  depends_on = [ google_compute_firewall.yb_anywhere_db_node,google_compute_firewall.yb_anywhere_inst,google_project_iam_member.project ]
}
