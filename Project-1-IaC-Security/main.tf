###############################################################################
# Terraform Settings
###############################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "s3" {
    bucket  = "my-terraform-state-bucket-devsecops-project"
    key     = "project-1-iac-security/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

###############################################################################
# KMS Key for Encryption
###############################################################################
resource "aws_kms_key" "state_bucket_kms" {
  description         = "KMS key for Terraform state bucket encryption"
  enable_key_rotation = true

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "Allow administration of the key",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}

###############################################################################
# S3 Bucket for Terraform State
###############################################################################
resource "aws_s3_bucket" "state_bucket" {
  bucket        = "my-terraform-state-bucket-devsecops-project"
  force_destroy = true

  # Skip non-critical checks for a state file bucket:
  # checkov:skip=CKV_AWS_144: Cross-region replication not required for state bucket
  # checkov:skip=CKV2_AWS_62: Event notifications not required for state bucket
  # checkov:skip=CKV_AWS_18: Access logging not required for state bucket
}

###############################################################################
# Public Access Block
###############################################################################
resource "aws_s3_bucket_public_access_block" "state_bucket_public_access" {
  bucket = aws_s3_bucket.state_bucket.bucket

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

###############################################################################
# Server-Side Encryption Configuration
###############################################################################
resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.state_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.state_bucket_kms.arn
    }
  }
}

###############################################################################
# Versioning
###############################################################################
resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

###############################################################################
# Lifecycle Rule (Abort Incomplete Uploads)
###############################################################################
resource "aws_s3_bucket_lifecycle_configuration" "state_bucket_lifecycle" {
  bucket = aws_s3_bucket.state_bucket.bucket

  rule {
    id     = "AbortIncompleteMultipart"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

###############################################################################
# IAM Groups and Policy Attachments
###############################################################################
resource "aws_iam_group" "admins" {
  name = "admins"
}

resource "aws_iam_group_policy_attachment" "admin_full_access" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  # checkov:skip=CKV_AWS_274: AdministratorAccess is intentionally used for demo purposes.
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_policy_attachment" "developer_full_access" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_group" "devsecops_engineers" {
  name = "devsecops-engineers"
}

resource "aws_iam_group_policy_attachment" "devsecops_read_only" {
  group      = aws_iam_group.devsecops_engineers.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}