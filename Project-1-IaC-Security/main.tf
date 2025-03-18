terraform {
  backend "s3" {
    bucket  = "my-terraform-state-bucket-devsecops-project"  # Unique state bucket name
    key     = "project-1-iac-security/terraform.tfstate"       # Unique key for Project 1
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-2"
}

# Create the Project 1 IaC Security S3 bucket
resource "aws_s3_bucket" "project_1_iac_security_bucket" {
  bucket        = "project-1-iac-security"
  force_destroy = true
}

# Create a KMS key for encryption
resource "aws_kms_key" "project_1_iac_security_kms_key" {
  description = "KMS key for Project 1 IaC Security S3 bucket encryption"
}

# Enable Server-Side Encryption using KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "project_1_iac_security_encryption" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.project_1_iac_security_kms_key.arn
    }
  }
}

# Enable Versioning on the bucket
resource "aws_s3_bucket_versioning" "project_1_iac_security_versioning" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Access Logging (logging to the same bucket for demo simplicity)
resource "aws_s3_bucket_logging" "project_1_iac_security_logging" {
  bucket        = aws_s3_bucket.project_1_iac_security_bucket.id
  target_bucket = aws_s3_bucket.project_1_iac_security_bucket.id
  target_prefix = "project-1-iac-security/logs/"
}

# Configure a Lifecycle Rule (expire objects after 365 days & abort incomplete uploads)
resource "aws_s3_bucket_lifecycle_configuration" "project_1_iac_security_lifecycle" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  rule {
    id     = "project-1-iac-security-lifecycle-rule"
    status = "Enabled"

    expiration {
      days = 365
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "project_1_iac_security_public_access" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}