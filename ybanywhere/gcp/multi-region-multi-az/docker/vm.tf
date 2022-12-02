data "google_compute_image" "ubuntu2004" {
  project = "ubuntu-os-cloud"
  name    = var.vm_image
}

#tfsec:ignore:google-compute-disk-encryption-customer-key
resource "google_compute_disk" "yba_boot_disk" {
  project = var.project_id
  name    = "${local.name_prefix}-bd"
  type    = "pd-ssd"
  zone    = "${var.gcp_regions[0]}-b"
  size    = var.volume_size
  image   = data.google_compute_image.ubuntu2004.self_link
}



#tfsec:ignore:google-compute-enable-shielded-vm-im
#tfsec:ignore:google-compute-enable-shielded-vm-vtpm
#tfsec:ignore:google-compute-no-project-wide-ssh-keys
resource "google_compute_instance" "yugabyte_anywhere_instances" {
  name         = "${local.name_prefix}-yba-inst"
  machine_type = var.instance_type
  zone         = "${var.gcp_regions[0]}-b"
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
        replicated_conf       = base64encode(file("${path.module}/files/replicated.conf"))
        license_bucket        = google_storage_bucket.license_bucket.name
        application_settings  = base64encode(file("${path.module}/files/application_settings.conf"))
        public_key            = file(var.public_key_path)
        replicated_password   = local.replicated_password
        replicated_seq_number = var.replicated_seq_number
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



# Node VM to test on-prem cloud provider with GCP VM


#tfsec:ignore:google-compute-disk-encryption-customer-key
resource "google_compute_disk" "yb_node_disk" {
  count   = (var.node_on_prem_test == true ? 3 : 0)
  project = var.project_id
  name    = "${local.name_prefix}-${element(var.gcp_regions, count.index)}-b-disk"
  type    = "pd-ssd"
  zone    = "${element(var.gcp_regions, count.index)}-b"
  size    = var.volume_size
}



#tfsec:ignore:google-compute-enable-shielded-vm-im
#tfsec:ignore:google-compute-enable-shielded-vm-vtpm
#tfsec:ignore:google-compute-no-project-wide-ssh-keys
resource "google_compute_instance" "yugabyte_node_instances" {
  count        = (var.node_on_prem_test == true ? 3 : 0)
  name         = "${local.name_prefix}-yb-node-inst-${count.index}"
  machine_type = var.instance_type
  // If single region we distrubte accross AZ
  zone = (length(var.gcp_regions) == 3 ? "${element(var.gcp_regions, count.index)}-b" : "${var.gcp_regions[0]}-${element(local.gcp-az, count.index)}")
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

  network_interface {
    subnetwork = module.gcp-vpc.subnets_names[(length(var.gcp_regions) == 3 ? count.index : 0)]
    access_config {
      // Ephemeral IP
    }
  }
}
