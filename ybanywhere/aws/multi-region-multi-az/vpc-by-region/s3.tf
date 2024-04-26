// Create bucket to put the license into
// Small workaround for the limitation of userData

#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-encryption-customer-key tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-specify-public-access-block
resource "aws_s3_bucket" "backup_bucket" {
  count         = var.create_backup_bucket ? 1 : 0
  bucket_prefix = local.name_prefix
}

resource "aws_s3_bucket_acl" "backup_bucket_acl" {
  count      = var.create_backup_bucket ? 1 : 0
  bucket     = one(aws_s3_bucket.backup_bucket[*].id)
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.backup_ownership]
}

resource "aws_s3_bucket_public_access_block" "license_block_publicacl" {
  count  = var.create_backup_bucket ? 1 : 0
  bucket = one(aws_s3_bucket.backup_bucket[*].id)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "backup_ownership" {
  count  = var.create_backup_bucket ? 1 : 0
  bucket = one(aws_s3_bucket.backup_bucket[*].id)
  rule {
    object_ownership = "ObjectWriter"
  }
}
