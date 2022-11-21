resource "random_id" "gcs_bucket_random" {
  byte_length = 8
}

#tfsec:ignore:google-storage-bucket-encryption-customer-key
resource "google_storage_bucket" "license_bucket" {
  name          = lower("${local.name_prefix}-${random_id.gcs_bucket_random.id}")
  location      = var.gcp_region_1
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}


resource "google_storage_bucket_object" "picture" {
  name   = "license.rli"
  source = var.license_path
  bucket = google_storage_bucket.license_bucket.name
}
