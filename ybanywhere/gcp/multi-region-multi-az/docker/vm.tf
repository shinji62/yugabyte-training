data "google_compute_image" "ubuntu2004" {
  project = "ubuntu-os-cloud"
  name    = var.vm_image
}

#tfsec:ignore:google-compute-disk-encryption-customer-key
resource "google_compute_disk" "yba_boot_disk" {
  project = var.project_id
  name    = "${local.name_prefix}-bd"
  type    = "pd-ssd"
  zone    = "${var.gcp_region_1}-b"
  size    = var.volume_size
  image   = data.google_compute_image.ubuntu2004.self_link
}



#tfsec:ignore:google-compute-enable-shielded-vm-im
#tfsec:ignore:google-compute-enable-shielded-vm-vtpm
#tfsec:ignore:google-compute-no-project-wide-ssh-keys
resource "google_compute_instance" "yugabyte_anywhere_instances" {
  name         = "${local.name_prefix}-yba-inst"
  machine_type = var.instance_type
  zone         = "${var.gcp_region_1}-b"
  tags         = ["yb-anywhere-inst"]
  #tfsec:ignore:google-compute-vm-disk-encryption-customer-key
  boot_disk {
    source = google_compute_disk.yba_boot_disk.name
  }
  labels = var.default_tags

  metadata = {
    user-data = templatefile(
      "${path.module}/scripts/cloud-init.yml.tpl",
      {
        replicated_conf      = base64encode(file("${path.module}/files/replicated.conf"))
        license_bucket       = google_storage_bucket.license_bucket.name
        application_settings = base64encode(file("${path.module}/files/application_settings.conf"))
        public_key           = file(var.public_key_path)
        replicated_password  = local.replicated_password
      }
    )
  }
  service_account {
    email  = google_service_account.sa_yba_instance.email
    scopes = ["cloud-platform"]
  }
  network_interface {
    subnetwork = module.gcp-vpc.subnets_names[0]
    access_config {
      // Ephemeral IP
    }
  }
}
