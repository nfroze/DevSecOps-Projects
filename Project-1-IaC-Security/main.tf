provider "aws" {
  region = "eu-west-2"
}

# Create an S3 bucket
resource "aws_s3_bucket" "project_1_iac_security" {
  bucket        = "project-1-iac-security"
  # For demos, you can force_destroy to easily remove the bucket later.
  force_destroy = true
}

# Secure S3 Bucket - Enable Encryption (KMS or AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.project_1_iac_security.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
      # If you want to demonstrate KMS, uncomment and specify a KMS key ARN:
      # sse_algorithm     = "aws:kms"
      # kms_master_key_id = "arn:aws:kms:eu-west-2:YOUR_ACCOUNT_ID:key/YOUR_KMS_KEY_ID"
    }
  }
}

# Secure S3 Bucket - Enable Versioning
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.project_1_iac_security.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Secure S3 Bucket - Enable Access Logging
# (Note: Typically you'd log to a separate bucket, but for simplicity we log here)
resource "aws_s3_bucket_logging" "s3_logging" {
  bucket        = aws_s3_bucket.project_1_iac_security.id
  target_bucket = aws_s3_bucket.project_1_iac_security.id
  target_prefix = "logs/"
}

# Lifecycle Rule
resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle" {
  bucket = aws_s3_bucket.project_1_iac_security.id

  rule {
    id     = "lifecycle-rule"
    status = "Enabled"

    # Example rule: delete objects older than 365 days
    expiration {
      days = 365
    }
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.project_1_iac_security.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
