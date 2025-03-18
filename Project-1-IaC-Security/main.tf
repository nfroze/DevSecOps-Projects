provider "aws" {
  region = "eu-west-2"
}

# Create an S3 bucket
resource "aws_s3_bucket" "devsecops_live_project" {
  bucket = "devsecops-live-project-cv"
  force_destroy = true
}

# Secure S3 Bucket - Enable Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.devsecops_live_project.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Secure S3 Bucket - Enable Versioning
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.devsecops_live_project.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Secure S3 Bucket - Enable Access Logging
resource "aws_s3_bucket_logging" "s3_logging" {
  bucket        = aws_s3_bucket.devsecops_live_project.id
  target_bucket = aws_s3_bucket.devsecops_live_project.id
  target_prefix = "log/"
}
