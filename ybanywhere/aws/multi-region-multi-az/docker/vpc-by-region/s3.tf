// Create bucket to put the license into
// Small workaround for the limitation of userData

#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-encryption-customer-key tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-specify-public-access-block
resource "aws_s3_bucket" "license_bucket" {
  count = var.create_yba_instances ? 1 : 0
  bucket_prefix = local.name_prefix
}

resource "aws_s3_bucket_acl" "license_bucket_acl" {
  count = var.create_yba_instances ? 1 : 0
  bucket = one(aws_s3_bucket.license_bucket[*].id)
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "license_block_publicacl" {
  count = var.create_yba_instances ? 1 : 0
  bucket = one(aws_s3_bucket.license_bucket[*].id)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_object" "license_upload" {
  count = var.create_yba_instances ? 1 : 0
  bucket      = one(aws_s3_bucket.license_bucket[*].id)
  key         = "license.rli"
  source      = var.license_path
  source_hash = filemd5(var.license_path)
}




