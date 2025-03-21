###############################################################################
# Terraform Settings
###############################################################################
terraform {
  # (Optional) Pin the AWS provider to a version that supports your setup
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }

  backend "s3" {
    bucket  = "my-terraform-state-bucket-devsecops-project"  # Unique state bucket name
    key     = "project-1-iac-security/terraform.tfstate"     # Unique key for Project 1
    region  = "eu-west-2"
    encrypt = true  # Encrypt state file
  }
}

provider "aws" {
  region = "eu-west-2"
}

###############################################################################
# S3 Bucket and Security Configurations
###############################################################################
# 1) Create the Project 1 IaC Security S3 bucket
resource "aws_s3_bucket" "project_1_iac_security_bucket" {
  bucket        = "project-1-iac-security"
  force_destroy = true
}

# 2) Block public access using a separate resource
resource "aws_s3_bucket_public_access_block" "project_1_iac_security_public_access" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.bucket

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# 3) Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "project_1_iac_security_versioning" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"  # Optional, enable if you want MFA for deletion
  }
}

# 4) Enable server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "project_1_iac_security_encryption" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # Use AES256 for server-side encryption
    }
  }
}

###############################################################################
# IAM Groups and Policy Attachments
###############################################################################
# Admins
resource "aws_iam_group" "admins" {
  name = "admins"
}

resource "aws_iam_group_policy_attachment" "admin_full_access" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Developers
resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_policy_attachment" "developer_full_access" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# DevSecOps Engineers
resource "aws_iam_group" "devsecops_engineers" {
  name = "devsecops-engineers"
}

resource "aws_iam_group_policy_attachment" "devsecops_read_only" {
  group      = aws_iam_group.devsecops_engineers.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}