# ⚙️ Project 3: CI/CD Pipeline Security

## 📌 Project Overview
This project implements a **secure CI/CD pipeline** that integrates **automated security checks** into the **software development lifecycle (SDLC)**. The pipeline scans for security misconfigurations, vulnerabilities, and secrets.

## 🛠️ Technologies Used
- **GitHub Actions** – CI/CD automation  
- **Trivy** – Static Code Analysis (SAST), Software Composition Analysis (SCA)  
- **Checkov** – Infrastructure-as-Code (IaC) security scanning  
- **Gitleaks** – Secret scanning  

## 🔑 Key Features
✅ **Automated security checks** integrated into CI/CD pipeline  
✅ **SAST, SCA, IaC scanning** for vulnerabilities and misconfigurations  
✅ **Secret scanning** to detect hardcoded API keys, credentials  
✅ **Fail-fast mechanism** to prevent vulnerable code from reaching production  

## 🔒 Security Considerations
- **Shift-left security** – Catch vulnerabilities early in the SDLC  
- **Fail pipeline on critical security issues** to enforce compliance  
- **Least privilege IAM roles** for pipeline execution  