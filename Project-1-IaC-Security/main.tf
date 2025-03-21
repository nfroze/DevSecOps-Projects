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
}

# Enable versioning on the S3 bucket using the separate versioning resource
resource "aws_s3_bucket_versioning" "project_1_iac_security_versioning" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  versioning_configuration {
    status    = "Enabled"
    mfa_delete = "Disabled"  # Optional, enable if you want MFA for deletion
  }
}

# Enable server-side encryption using the separate resource
resource "aws_s3_bucket_server_side_encryption" "project_1_iac_security_encryption" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Block public access for the S3 bucket
resource "aws_s3_bucket_public_access_block" "project_1_iac_security_public_access" {
  bucket = aws_s3_bucket.project_1_iac_security_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Create IAM Group Policies for Admins
resource "aws_iam_policy" "admin_full_access" {
  name        = "AdminFullAccess"
  description = "Full access to all AWS services"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:*"
        Effect    = "Allow"
        Resource  = "*"
      },
      {
        Action    = "iam:*"
        Effect    = "Allow"
        Resource  = "*"
      },
      {
        Action    = "ec2:*"
        Effect    = "Allow"
        Resource  = "*"
      },
      {
        Action    = "vpc:*"
        Effect    = "Allow"
        Resource  = "*"
      }
    ]
  })
}

# Attach Admin Policy to Admin Group
resource "aws_iam_group_policy_attachment" "admin_s3_access" {
  group      = aws_iam_group.admins.name
  policy_arn = aws_iam_policy.admin_full_access.arn
}

# Create IAM Group Policies for Developers
resource "aws_iam_policy" "developer_s3_access" {
  name        = "DeveloperS3Access"
  description = "Read/Write access to S3 and EC2 for developers"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject", "s3:PutObject"]
        Effect    = "Allow"
        Resource  = "arn:aws:s3:::project-1-iac-security/*"  # Access to specific bucket
      },
      {
        Action    = ["ec2:Describe*", "ec2:StartInstances", "ec2:StopInstances"]
        Effect    = "Allow"
        Resource  = "*"
      }
    ]
  })
}

# Attach Developer Policy to Developer Group
resource "aws_iam_group_policy_attachment" "developer_s3_access" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_s3_access.arn
}

# Create IAM Group Policies for DevSecOps Engineers
resource "aws_iam_policy" "devsecops_s3_readonly" {
  name        = "DevSecOpsS3ReadOnly"
  description = "Read-only access to S3 for DevSecOps engineers"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "arn:aws:s3:::*/*"  # Read-only access to all S3 buckets
      }
    ]
  })
}

resource "aws_iam_policy" "devsecops_security_access" {
  name        = "DevSecOpsSecurityAccess"
  description = "Full access to security services (GuardDuty, CloudTrail, etc.)"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "iam:List*"
        Effect    = "Allow"
        Resource  = "*"
      },
      {
        Action    = "cloudtrail:DescribeTrails"
        Effect    = "Allow"
        Resource  = "*"
      },
      {
        Action    = "guardduty:ListDetectors"
        Effect    = "Allow"
        Resource  = "*"
      }
    ]
  })
}

# Attach DevSecOps Policies to DevSecOps Engineers Group
resource "aws_iam_group_policy_attachment" "devsecops_s3_readonly" {
  group      = aws_iam_group.devsecops_engineers.name
  policy_arn = aws_iam_policy.devsecops_s3_readonly.arn
}

resource "aws_iam_group_policy_attachment" "devsecops_security_access" {
  group      = aws_iam_group.devsecops_engineers.name
  policy_arn = aws_iam_policy.devsecops_security_access.arn
}

# Create User Groups
resource "aws_iam_group" "admins" {
  name = "admins"
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group" "devsecops_engineers" {
  name = "devsecops-engineers"
}