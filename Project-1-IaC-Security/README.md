# 📌 Project 1: Infrastructure as Code (IaC) Security  

## 📖 Project Overview  
This project demonstrates **secure infrastructure deployment** using **Terraform** in **AWS**. The primary focus is on applying **security best practices** to AWS services such as **IAM** (Identity and Access Management), **S3**, and **KMS** (Key Management Service), along with **IaC scanning**. The goal is to automate the provisioning and securing of resources with an emphasis on **least privilege** IAM roles and policies, as well as secure configuration of infrastructure.

## 🛠️ Technologies Used  
- **Terraform** – Infrastructure as Code for defining and provisioning infrastructure.
- **AWS** (IAM, S3, KMS) – Cloud services to create and manage resources.
- **Checkov** – Infrastructure as Code security scanner to ensure Terraform scripts follow best security practices.
- **GitHub Actions** – CI/CD pipeline to automate the provisioning and validation of the infrastructure.

## 🔑 Key Features  
✅ **Secure S3 bucket policies** (encryption, versioning, and access control).  
✅ **Least privilege IAM policies** ensuring groups have only the permissions required for their roles.  
✅ **Checkov security scan** integrated to flag any misconfigurations in Terraform code.  
✅ **Automated infrastructure deployment** using GitHub Actions to apply Terraform configurations securely.  

## 🔒 Security Considerations  
- **IAM policies** strictly follow the **least privilege** principle by ensuring that each user group (admin, developers, sysadmins, etc.) only has access to the services and actions necessary for their role.  
- **Encryption at rest** for S3 buckets using **KMS** to ensure data protection.  
- **Automated IaC scans** using Checkov to detect and correct security misconfigurations before deployment.  
- **Automated deployment** with GitHub Actions ensures that infrastructure changes are validated and applied securely.

## 🌐 State File Management  

In this project, the **Terraform state file** is stored securely in an **S3 bucket** to ensure proper state management, versioning, and collaboration. Using an S3 bucket for storing the state file provides the following benefits:

- **Centralized and versioned state**: The state file is stored in an S3 bucket with **versioning enabled**, allowing for easy tracking of changes over time and rolling back to previous states if necessary.
- **Collaborative infrastructure**: Storing the state file in S3 ensures that multiple users or CI/CD pipelines can access and update the state file simultaneously, without conflicts or data loss.
- **Secure storage**: The state file is **encrypted** using **KMS** (Key Management Service), ensuring that sensitive information such as resource IDs and configurations are kept secure.
- **Consistency in infrastructure updates**: By keeping the state file in a centralized location, Terraform always applies changes based on the latest infrastructure state, reducing the risk of configuration drift.

This setup helps automate the deployment of resources securely and consistently, providing a robust foundation for collaborative infrastructure management.

## 📝 Workflow  
The GitHub Actions pipeline automates the following steps:

1. **IaC Scan** – The pipeline first runs a **Checkov** scan to validate the Terraform scripts for any security misconfigurations or best practice violations.  
2. **Terraform Init** – Initializes Terraform to set up the working environment, ensuring dependencies are loaded.  
3. **Terraform Plan** – Generates a Terraform execution plan, showing the infrastructure changes that will be made.  
4. **Terraform Apply** – If the plan is valid, Terraform will apply the changes to AWS, provisioning or updating resources like IAM groups, S3 buckets, and KMS keys.

## 🔄 IaC Deployment Process  
The workflow consists of two main stages:
- **IaC Scan**: This step scans the Terraform code for security misconfigurations using **Checkov**.
- **IaC Deploy**: If the scan passes successfully, Terraform deploys the resources to AWS, creating or updating resources like IAM groups and secure S3 buckets.

This automated approach ensures that any infrastructure deployed adheres to **security best practices**, and any changes to the infrastructure are validated and securely applied.