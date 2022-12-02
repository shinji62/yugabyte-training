
resource "google_service_account" "sa_yba_instance" {
  count        = var.create_yba_instances ? 1 : 0
  account_id   = "${local.name_prefix}-sa-yba-inst"
  display_name = "SA for ${local.name_prefix} deployment"
}

resource "null_resource" "delay" {
  count = var.create_yba_instances ? 1 : 0
  provisioner "local-exec" {
    command = "sleep 10"
  }
  triggers = {
    "before" = "${one(google_service_account.sa_yba_instance[*].id)}"
  }
}

resource "google_storage_bucket_iam_member" "license_bucket" {
  count  = var.create_yba_instances ? 1 : 0
  bucket = one(google_storage_bucket.license_bucket[*].name)
  role   = "roles/storage.objectViewer"
  member = one(google_service_account.sa_yba_instance[*].member)
}

resource "google_project_iam_member" "project" {
  count   = var.create_yba_instances ? 1 : 0
  project = var.project_id
  role    = "roles/owner"
  member  = one(google_service_account.sa_yba_instance[*].member)
}
