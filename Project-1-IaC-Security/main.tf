terraform {
  backend "s3" {
    bucket  = "my-terraform-state-bucket-devsecops-project"  # Unique state bucket name
    key     = "project-1-iac-security/terraform.tfstate"     # Unique key for Project 1
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
      kms_master_key_id = aws_kms_key.project_1_iac_security_kms_key.id
    }
  }
}

# Define IAM Groups
resource "aws_iam_group" "admins" {
  name = "admins"
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group" "devsecops_engineers" {
  name = "devsecops-engineers"
}

resource "aws_iam_group" "sysadmins" {
  name = "sysadmins"
}

# Attach Policies to IAM Groups

# Admin group - Full administrative access
resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Developers group - Limited access to EC2 and S3 for managing infrastructure and application resources
resource "aws_iam_group_policy_attachment" "developer_policy" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "developer_s3_policy" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"  # Developers can have read-only access to S3, or write access if necessary
}

# DevSecOps Engineers group - Security-focused policies for auditing and security management
resource "aws_iam_group_policy_attachment" "devsecops_engineer_policy" {
  group      = aws_iam_group.devsecops_engineers.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# Sysadmins group - Permissions for infrastructure management without full administrative access
resource "aws_iam_group_policy_attachment" "sysadmin_s3_policy" {
  group      = aws_iam_group.sysadmins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "sysadmin_ec2_policy" {
  group      = aws_iam_group.sysadmins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}