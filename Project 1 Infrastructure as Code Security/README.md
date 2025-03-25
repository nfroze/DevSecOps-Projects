# 🛠️ Project 1: Infrastructure as Code (IaC) Security

## 1. Overview 🚀
This project showcases **secure AWS infrastructure provisioning** with **Terraform**, enforcing **least privilege** IAM policies. It features a **two-step CI/CD pipeline**—one job for **IaC scanning** and another for **deployment**—integrating **Checkov** to detect misconfigurations before anything goes live.

---

## 2. Key Technologies 🛠
- **Terraform** ⚙️  
  - Defines AWS resources in `main.tf` and manages state via a secured S3 backend.
- **AWS** ☁️  
  - Focus on IAM, CloudTrail, GuardDuty, ensuring robust access control and logging.
- **Checkov** 🔎  
  - Automatically scans Terraform code for potential security issues or misconfigurations.
- **GitHub Actions** 🤖  
  - Orchestrates a multi-job pipeline (scan & deploy) to validate and apply Terraform changes.

---

## 3. Security Highlights 🔒
- **Least Privilege IAM Policies**  
  - IAM roles (admins, developers, devsecops) each have only the permissions required.
- **Automated IaC Security Scanning**  
  - Checkov flags insecure configurations during pull requests, blocking them from merging if issues persist.
- **Dedicated State Management**  
  - Terraform’s state stored in an S3 backend, serving as a single source of truth and preventing local conflicts.
- **Two-Step CI/CD Pipeline**  
  - Splits security scanning (`iac-scan`) from the actual deployment (`iac-deploy`), ensuring only safe code is applied.

---

## 4. CI/CD Workflow 🔄
1. **Code Checkout & AWS Setup**  
   - The pipeline retrieves source code from the `Project-1-IaC-Security` directory and configures AWS credentials via GitHub Actions secrets.
2. **Terraform Init**  
   - Runs `terraform init` within the project folder to prepare necessary plugins and modules.
3. **Checkov Scan**  
   - Uses `checkov -d ./Project-1-IaC-Security` to detect security misconfigurations before proceeding.
4. **Plan & (If Safe) Deploy**  
   - `terraform plan` helps validate infrastructure changes.  
   - If scanning passes, the second job (`iac-deploy`) applies (`terraform apply -auto-approve`) the changes to AWS.

> **Note:** The **`iac-deploy`** job only runs if the **`iac-scan`** step succeeds, reflecting a true *shift-left* security model.

---

## 5. Value for Organizations 💼
- **Auditable Deployments**  
  - Version-controlled Terraform code with automated plan/apply ensures traceability and repeatability.
- **Reduced Attack Surface**  
  - **Least privilege** IAM roles prevent excessive permissions and mitigate potential breaches.
- **Early Issue Detection**  
  - Checkov flags issues in pull requests, stopping insecure configurations from reaching production.
- **Scalable & Repeatable**  
  - Automated provisioning with Terraform in a managed CI/CD pipeline reduces manual errors and friction.

---

## 6. Conclusion ✅
By combining **Terraform**, **Checkov**, and **GitHub Actions** in a **two-step** (scan → deploy) pipeline, this project exemplifies **secure, repeatable** IaC practices. The workflow integrates seamlessly with existing Git-based processes, ensuring **only validated configurations** are ever deployed, thereby enhancing **compliance** and **infrastructure reliability**.