terraform {
  backend "s3" {
    bucket  = "my-terraform-state-bucket-devsecops-project"  # Unique state bucket name
    key     = "project-1-iac-security/terraform.tfstate"     # Unique key for Project 1
    region  = "eu-west-2"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

###############################################################################
# S3 Bucket and Security Configurations
###############################################################################
# Create the primary S3 bucket for IaC Security.
# checkov:skip=CKV_AWS_144: Cross-region replication not required for demo.
resource "aws_s3_bucket" "project_1_iac_security_bucket" {
  bucket        = "project-1-iac-security"
  force_destroy = true
}

# Block public access using a separate resource.
resource "aws_s3_bucket_public_access_block" "project_1_iac_security_public_access" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.bucket

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Enable versioning for the S3 bucket.
resource "aws_s3_bucket_versioning" "project_1_iac_security_versioning" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = false
  }
}

# Create a KMS key for encrypting the S3 bucket.
resource "aws_kms_key" "s3_bucket_kms_key" {
  description = "KMS key for S3 bucket encryption"
}

# Enable server-side encryption using KMS (satisfies CKV_AWS_145).
resource "aws_s3_bucket_server_side_encryption_configuration" "project_1_iac_security_encryption" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_bucket_kms_key.arn
    }
  }
}

# Add a lifecycle configuration to satisfy CKV2_AWS_61.
resource "aws_s3_bucket_lifecycle_configuration" "project_1_iac_security_lifecycle" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  rule {
    id     = "ExpireOldVersions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}

# (Optional) S3 bucket notification resource.
# checkov:skip=CKV2_AWS_62: Event notifications not required for demo.
resource "aws_s3_bucket_notification" "project_1_notification" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  # No notifications configured
}

# Create a separate S3 bucket for access logs.
resource "aws_s3_bucket" "logging_bucket" {
  bucket        = "project-1-iac-security-logs"
  force_destroy = true
}

# Enable access logging on the primary S3 bucket to satisfy CKV_AWS_18.
resource "aws_s3_bucket_logging" "project_1_iac_security_bucket_logging" {
  bucket        = aws_s3_bucket.project_1_iac_security_bucket.id
  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "access-logs/"
}

###############################################################################
# IAM Groups and Policy Attachments
###############################################################################
# Admins Group: Using AdministratorAccess for demo purposes.
# checkov:skip=CKV_AWS_274: Demo purposes require AdministratorAccess for the admin group.
resource "aws_iam_group" "admins" {
  name = "admins"
}

resource "aws_iam_group_policy_attachment" "admin_full_access" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Developers Group: Attaching PowerUserAccess.
resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_policy_attachment" "developer_full_access" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# DevSecOps Engineers Group: Attaching SecurityAudit.
resource "aws_iam_group" "devsecops_engineers" {
  name = "devsecops-engineers"
}

resource "aws_iam_group_policy_attachment" "devsecops_read_only" {
  group      = aws_iam_group.devsecops_engineers.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}