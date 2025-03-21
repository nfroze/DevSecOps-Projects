# 🌐 Project 1: Infrastructure as Code (IaC) Security

## 1. Overview 🚀
This project demonstrates how to **securely provision AWS infrastructure** using **Terraform** while enforcing **least privilege** principles. It integrates **automated IaC security scanning** (via Checkov) within a CI/CD pipeline to verify each change before deployment.

---

## 2. Key Technologies 🛠
- **Terraform** ⚙️  
  Defines AWS resources and manages state via a secured S3 backend.
- **AWS** ☁️  
  Focuses on IAM, CloudTrail, GuardDuty for strong access control and monitoring.
- **Checkov** 🔎  
  Automatically scans Terraform code for misconfigurations and vulnerabilities.
- **GitHub Actions** 🤖  
  Automates Terraform plan/apply and security checks in the CI/CD workflow.

---

## 3. Security Highlights 🔒
- **Least Privilege IAM**  
  Separate roles for admins, developers, and devsecops, each with only the permissions required.
- **Automated Security Scanning**  
  Checkov flags issues before code is deployed, ensuring secure configurations.
- **Remote State Management**  
  Terraform state stored in a secured S3 backend, providing a single source of truth and preventing state conflicts.

---

## 4. CI/CD Workflow 🔄
1. **Write Code**  
   - Define AWS resources in `main.tf` using Terraform.
2. **Scan**  
   - Checkov runs on pull requests, catching vulnerabilities or misconfigurations early.
3. **Plan & Apply**  
   - GitHub Actions validates (`terraform plan`) and deploys (`terraform apply`) the resources to AWS upon approval.

---

## 5. Value for Organizations 💼
- **Auditable Deployments**  
  All infrastructure changes are version-controlled, simplifying traceability and rollback.
- **Scalable & Repeatable**  
  Terraform automates provisioning, reducing human error and ensuring consistency.
- **Reduced Attack Surface**  
  Least privilege IAM policies help prevent unauthorized access.
- **Early Issue Detection**  
  Potential security flaws are identified before reaching production, mitigating risk.

---

## 6. Conclusion ✅
By combining **Terraform**, **Checkov**, and **GitHub Actions**, this project delivers a **secure, repeatable** deployment workflow. It exemplifies how DevSecOps best practices—including shifting security left—lead to **enhanced compliance** and **robust, reliable infrastructure**.