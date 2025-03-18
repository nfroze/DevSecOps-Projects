Project 3: CI/CD Pipeline Security
Project Overview
Objective: Implement a secure CI/CD pipeline with security checks.
Key Focus: Automate SAST, SCA, IaC, secret scanning, and container image scanning.
Technologies Used
GitHub Actions, Terraform, Docker, AWS
Semgrep (SAST), Trivy (SCA & Image Scanning), Checkov (IaC Security)
Key Features
✔️ GitHub Actions pipeline with security scanning
✔️ SAST (Semgrep) for code vulnerabilities
✔️ SCA (Trivy) for dependency security
✔️ IaC scan (Checkov) for Terraform security
✔️ Container Image Scan (Trivy)

Security Considerations
🔹 Pipeline enforces security scanning before deployment
🔹 Secrets detection prevents credential leaks
🔹 Scans run automatically on code push events