# 🐳 Project 2: Container Security (Docker, Kubernetes)

## 📌 Project Overview
This project focuses on securing containerized environments using **Docker** and **Kubernetes**. The goal is to demonstrate best practices for **container security**, **image vulnerability scanning**, and **Kubernetes security hardening**.

> **Note:** In a real-world production scenario, AWS EKS is typically used for container orchestration. However, to save on costs and simplify the demo environment, this project uses a Kubernetes cluster deployed on an EC2 instance. This approach still demonstrates the same security principles and best practices while acknowledging the industry standard.

## 🛠️ Technologies Used
- **Docker** – Containerization platform
- **Kubernetes** – Container orchestration (deployed on an EC2 instance for demo purposes)
- **Trivy** – Image vulnerability scanning
- **Kube-Bench** – Kubernetes security benchmarking
- **Minikube** – Local Kubernetes cluster for testing (if needed)

## 🔑 Key Features
✅ Secure **Docker image creation** using best practices  
✅ Image scanning for vulnerabilities using **Trivy**  
✅ Kubernetes security hardening with **RBAC & Network Policies**  
✅ **Kube-Bench** scan to enforce Kubernetes security benchmarks  

## 🔒 Security Considerations
- **Only trusted base images** are used to minimize vulnerabilities  
- **RBAC (Role-Based Access Control)** to restrict access to Kubernetes resources  
- **Network policies** to control inter-container communication  
- **Regular image scanning** to detect vulnerabilities early