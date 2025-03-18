provider "aws" {
  region = "eu-west-2"
}

# Create an S3 bucket for the infrastructure
resource "aws_s3_bucket" "project_1_iac_security" {
  bucket        = "project-1-iac-security"
  force_destroy = true
}

# Secure S3 Bucket - Enable Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.project_1_iac_security.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
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
resource "aws_s3_bucket_logging" "s3_logging" {
  bucket        = aws_s3_bucket.project_1_iac_security.id
  target_bucket = aws_s3_bucket.project_1_iac_security.id
  target_prefix = "log/"
}

# Terraform Backend Configuration (Store the Terraform state in S3)
terraform {
  backend "s3" {
    bucket = "project-1-iac-security"  # Your bucket name
    key    = "terraform/state/project1/terraform.tfstate"  # The path where the state file will be stored
    region = "eu-west-2"  # The AWS region where your bucket is located
  }
}