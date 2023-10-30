

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


resource "google_storage_bucket_iam_member" "backup_bucket" {
  bucket = google_storage_bucket.backup_bucket.name
  role   = "roles/storage.objectUser"
  member = google_service_account.sa_yba_instance.member
}


resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = "roles/owner"
  member  = google_service_account.sa_yba_instance.member
}

//SA to generate credentials for the backup bucket
resource "google_service_account" "sa_backup_bucket" {
  account_id   = "${local.name_prefix}-sa-backup-bucket"
  display_name = "SA for ${local.name_prefix} Backup access "
}

resource "google_storage_bucket_iam_member" "backup_bucket_sa" {
  bucket = google_storage_bucket.backup_bucket.name
  role   = "roles/storage.objectUser"
  member = google_service_account.sa_backup_bucket.member
}

resource "google_service_account_key" "google_key" {
  service_account_id = google_service_account.sa_backup_bucket.name
}
