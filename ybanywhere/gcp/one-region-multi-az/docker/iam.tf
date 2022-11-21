

resource "google_service_account" "sa_yba_instance" {
  account_id   = "${local.name_prefix}-sa-yba-inst"
  display_name = "SA for ${local.name_prefix} deployment"
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 10"
  }
  triggers = {
    "before" = "${google_service_account.sa_yba_instance.id}"
  }
}


resource "google_storage_bucket_iam_member" "license_bucket" {
  bucket = google_storage_bucket.license_bucket.name
  role   = "roles/storage.objectViewer"
  member = google_service_account.sa_yba_instance.member
}


resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = "roles/owner"
  member  = google_service_account.sa_yba_instance.member
}  