# 📌 Project 1: Infrastructure as Code (IaC) Security  

## 📖 Project Overview  
This project demonstrates **secure infrastructure deployment** using **Terraform** in **AWS**. The focus is on best practices for **S3 state bucket security**, **IAM policies**, and **IaC scanning** to ensure the infrastructure is secure and follows industry best practices.

By automating the entire infrastructure deployment process with **Terraform**, this project highlights the benefits of using **Infrastructure as Code (IaC)** and **automated security checks** to ensure a **secure, repeatable, and auditable deployment** process.

## 🛠️ Technologies Used  
- **Terraform** – Infrastructure as Code to define and provision infrastructure.
- **AWS** (S3, IAM, CloudTrail, GuardDuty) – Cloud services to create and manage resources.
- **Checkov** – IaC security scanning tool to ensure Terraform code follows security best practices.
- **GitHub Actions** – CI/CD pipeline to automate the deployment and validation of the infrastructure.

## 🔑 Key Features  
✅ **Secure S3 state bucket**:  
   - The Terraform state file is stored in an S3 bucket configured with encryption (using a customer-managed KMS key with rotation enabled), versioning, and a lifecycle rule to abort incomplete multipart uploads.  
   - **Public access** to the bucket is blocked.  
   - **Note:** Access logging and event notifications are intentionally omitted since they are not strictly necessary for a state file bucket in this demo environment.

✅ **Least privilege IAM policies**:  
   - IAM groups are defined so that each role (admins, developers, devsecops engineers) has only the permissions required for their tasks.

✅ **IaC scanning with Checkov**:  
   - Checkov automatically scans the Terraform code for potential misconfigurations and security risks before deployment.

✅ **Automated infrastructure deployment**:  
   - A CI/CD pipeline using GitHub Actions automates the Terraform plan and apply processes, ensuring secure and consistent deployments.

## 🔒 Security Considerations  
- **IAM Policies:**  
  - Roles follow the **least privilege** principle, meaning each user group is granted only the permissions required for their specific responsibilities.

- **S3 State Bucket:**  
  - **Encryption:** Data is encrypted at rest using a KMS key with rotation enabled.  
  - **Versioning:** Enabled to allow recovery of previous states if needed.  
  - **Lifecycle Rule:** Configured to abort incomplete multipart uploads, keeping the bucket lean and manageable.  
  - **Public Access:** Blocked entirely to prevent unauthorized access.  
  - **Logging and Notifications:** Omitted for simplicity, as these are not critical for a dedicated state bucket in this demo environment.

- **IaC Scanning:**  
  - Automated checks (via Checkov) catch misconfigurations early, ensuring that only secure configurations are deployed.

## 📝 Workflow  
The workflow includes the following steps:

1. **Write Terraform Code** – Define AWS resources (S3 state bucket, IAM policies, etc.) in `main.tf` using best practices for security and least privilege.
2. **IaC Security Scanning** – Use **Checkov** to scan the Terraform code for security misconfigurations and vulnerabilities.
3. **Deploy Infrastructure** – Use **GitHub Actions** to apply the Terraform configuration and deploy resources in AWS.

## 🔄 Deployment Process  
After the Terraform plan is validated, the infrastructure is deployed to AWS:
- A dedicated **S3 state bucket** is created with essential security measures (encryption, versioning, lifecycle rule, and public access block).
- **IAM user groups** are configured with least privilege policies for **admins**, **developers**, and **devsecops engineers**.
- **Checkov** runs in the pipeline to ensure that insecure configurations are caught before deployment.

This ensures that the **AWS environment** is set up securely, while unnecessary complexity is avoided for the state bucket.

## 🛠️ CI/CD Pipeline  
The **CI/CD pipeline** is fully automated using **GitHub Actions** to ensure secure and efficient infrastructure provisioning. The pipeline includes:

- **Running Checkov** to scan the Terraform code for security issues.
- **Validating the Terraform plan** to check for any misconfigurations.
- **Applying the Terraform code** to deploy infrastructure on AWS once the plan is validated.

### Pipeline Overview:
1. **`scan`**: This job uses **Checkov** to scan the Terraform code for potential security risks before applying it.
2. **`apply`**: After validation, this job automatically applies the Terraform code to deploy resources to AWS.

## 🏆 Benefits of This Project to Companies  
### **IaC with Terraform**:
- **Consistent Infrastructure:** Infrastructure is automatically provisioned and versioned, ensuring repeatability and consistency.
- **Auditability:** All changes are version-controlled, providing a full audit trail of what was deployed and when.
- **Scalability:** Infrastructure can be scaled by updating the code and reapplying it without manual intervention.

### **Automated IaC Security Scanning with Checkov**:
- **Early Detection:** Checkov scans the Terraform code to detect potential security issues before deployment.
- **Continuous Monitoring:** Integrating Checkov into the CI/CD pipeline ensures that every change adheres to security best practices.

### **Secure Infrastructure with Least Privilege IAM Roles**:
- **Reduced Attack Surface:** Each role (admins, developers, devsecops) has only the minimum permissions required, lowering the risk of excessive access.

### **S3 State Bucket Security**:
- **Essential Protections:** The state bucket is secured with encryption, versioning, and lifecycle rules, ensuring that sensitive state data remains protected.
- **Focused Security:** Only the essential security measures are implemented, avoiding unnecessary complexity while still meeting production-grade requirements.

## 📋 Conclusion  
This project demonstrates how **Infrastructure as Code (IaC)** with **Terraform** can be used to **securely deploy** and **manage** AWS infrastructure. By following **security best practices**—such as **least privilege IAM roles** and a focused, production-grade **S3 state bucket configuration**—the infrastructure is both secure and compliant with industry standards.

The integration of **Checkov** for **automated IaC security scanning** ensures that the configuration is continuously validated against security best practices. With the **CI/CD pipeline** automated via **GitHub Actions**, the deployment process is consistent, repeatable, and secure.

---

### Final Thoughts  
This **Project 1** showcases the importance of using **Infrastructure as Code** (IaC) to automate the **secure deployment** of resources. By combining **Terraform**, **Checkov**, and **least privilege IAM roles** with a tailored S3 state bucket configuration, the solution improves security posture, ensures consistent provisioning, and enables faster delivery of secure environments.