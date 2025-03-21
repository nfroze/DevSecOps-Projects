terraform {
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

# Create the Project 1 IaC Security S3 bucket
resource "aws_s3_bucket" "project_1_iac_security_bucket" {
  bucket        = "project-1-iac-security"
  force_destroy = true
  versioning {
    enabled = true
  }
}

# Enable MFA Delete
resource "aws_s3_bucket_versioning" "project_1_iac_security_versioning" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id
  versioning_configuration {
    status    = "Enabled"
    mfa_delete = "Enabled"
  }
}

# Enable Access Control Lists (ACLs) for Fine-Grained Control
resource "aws_s3_bucket_acl" "project_1_iac_security_acl" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id
  acl    = "private"
}

# Block public access
resource "aws_s3_bucket_public_access_block" "project_1_iac_security_block" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable Server Access Logging
resource "aws_s3_bucket_logging" "project_1_iac_security_logging" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  target_bucket = aws_s3_bucket.project_1_iac_security_bucket.id
  target_prefix = "logs/"
}

# Define IAM Policy for Admins: Full access
resource "aws_iam_policy" "admin_s3_full_access" {
  name        = "AdminS3FullAccess"
  description = "Full access to the S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:*"
        Effect    = "Allow"
        Resource  = [
          "${aws_s3_bucket.project_1_iac_security_bucket.arn}/*",
          "${aws_s3_bucket.project_1_iac_security_bucket.arn}"
        ]
      }
    ]
  })
}

# Attach Admin Policy to Admin Group
resource "aws_iam_group_policy_attachment" "admin_s3_access" {
  group      = aws_iam_group.admins.name
  policy_arn = aws_iam_policy.admin_s3_full_access.arn
}

# Define IAM Policy for Developers: Read/Write access to specific folder in S3
resource "aws_iam_policy" "developer_s3_access" {
  name        = "DeveloperS3Access"
  description = "Read and write access to the developers' folder in S3"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject", "s3:PutObject"]
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.project_1_iac_security_bucket.arn}/developers/*"
      }
    ]
  })
}

# Attach Developer Policy to Developer Group
resource "aws_iam_group_policy_attachment" "developer_s3_access" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_s3_access.arn
}

# Define IAM Policy for Sysadmins: Full access to EC2-related folders
resource "aws_iam_policy" "sysadmin_s3_access" {
  name        = "SysadminS3Access"
  description = "Full access to the sysadmin folder in S3"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:*"]
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.project_1_iac_security_bucket.arn}/sysadmins/*"
      }
    ]
  })
}

# Attach Sysadmin Policy to Sysadmins Group
resource "aws_iam_group_policy_attachment" "sysadmin_s3_access" {
  group      = aws_iam_group.sysadmins.name
  policy_arn = aws_iam_policy.sysadmin_s3_access.arn
}

# Define IAM Policy for Read-Only Access (Example for External Auditors or Restricted Access)
resource "aws_iam_policy" "readonly_s3_access" {
  name        = "ReadOnlyS3Access"
  description = "Read-only access to the S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.project_1_iac_security_bucket.arn}/*"
      }
    ]
  })
}

# Attach Read-Only Policy to a specific group (e.g., auditors)
resource "aws_iam_group_policy_attachment" "readonly_s3_access" {
  group      = aws_iam_group.readonly.name
  policy_arn = aws_iam_policy.readonly_s3_access.arn
}