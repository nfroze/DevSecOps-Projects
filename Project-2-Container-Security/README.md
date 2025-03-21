# 🐳 Project 2: Container Security (Docker, ECS)

## 1. Overview 🚀
This project demonstrates how to **securely build, scan, and deploy** a containerized application using **Docker** and **Amazon ECS**. The pipeline employs **Trivy** for vulnerability scanning and **GitHub Actions** for continuous integration and delivery, ensuring security checks occur automatically before new images reach ECS.

---

## 2. Key Technologies 🛠
- **Docker** ⚙️  
  - Packages the application into a container, including static content (`index.html`) for demonstration.
- **Amazon ECS** ☁️  
  - A fully managed container orchestration service, handling rolling updates for minimal downtime.
- **Trivy** 🔎  
  - Scans Docker images for high and critical vulnerabilities, preventing insecure images from being deployed.
- **GitHub Actions** 🤖  
  - Runs a two-job pipeline to build & scan, then update ECS if scans pass, reinforcing shift-left security.

---

## 3. Security Highlights 🔒
- **Trusted Base Images**  
  - The Dockerfile starts with an official, verified base image to reduce inherent vulnerabilities.
- **Automated Vulnerability Scanning**  
  - **Trivy** checks each build for high or critical vulnerabilities, halting deployment if any are found.
- **Least Privilege IAM Roles**  
  - ECS tasks and services are granted only the permissions they actually need, minimizing attack surfaces.
- **Continuous Delivery**  
  - Containers are automatically rebuilt, rescanned, and redeployed with every eligible code change, ensuring up-to-date security.

---

## 4. CI/CD Workflow 🔄
### Job 1: Build, Scan, and Push
1. **Checkout**  
   - Fetches the repository source for the `Project-2-Container-Security` directory.
2. **Build Docker Image**  
   - Constructs the Docker image (using the provided `Dockerfile`) tagged as `latest`.
3. **Install & Run Trivy**  
   - Trivy scans the newly built image for **HIGH** and **CRITICAL** vulnerabilities.
   - Deployment stops if the scan fails, ensuring no insecure images are pushed.
4. **Docker Hub Push**  
   - Logs in using GitHub secrets, then pushes the image to Docker Hub.

### Job 2: Update ECS
- **AWS Credentials**  
  - Configures AWS credentials (from secrets) to interact with ECS.
- **ECS Deployment**  
  - Runs `aws ecs update-service --force-new-deployment`, pulling the **latest secure** image to ECS.  
  - Old tasks are seamlessly replaced, maintaining **zero downtime**.

> **Note**: The second job (`ecs-update`) only runs **if the first job succeeds**, reflecting a true *shift-left* approach where images must pass security scans before ECS updates occur.

---

## 5. Value for Organizations 💼
- **Early Vulnerability Detection**  
  - High and critical issues never reach production, significantly reducing security risks.
- **Automated Release Cycle**  
  - The pipeline builds and deploys your app without manual intervention, speeding up go-to-market.
- **Scalable & Reliable**  
  - ECS easily handles fluctuating workloads, with rolling updates ensuring continuous service availability.
- **Proactive Security Posture**  
  - Continuous scanning and enforced least privilege stand as pillars of DevSecOps best practices.

---

## 6. Conclusion ✅
By integrating **Docker**, **Trivy**, **ECS**, and **GitHub Actions** into a cohesive pipeline, this project achieves **secure, automated** container deployments. Each code push triggers a **build-and-scan** job, followed by an **ECS update** if the image passes vulnerability checks. This flow ensures a **consistent, repeatable** release process that aligns with modern DevSecOps principles—reducing risk while maintaining agility.