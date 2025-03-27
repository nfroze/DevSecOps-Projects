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
    bucket  = "my-terraform-state-bucket-devsecops-project-3"  # Updated bucket name
    key     = "project-3/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

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
