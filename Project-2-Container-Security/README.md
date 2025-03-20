# 🐳 Project 2: Container Security (Docker, ECS)

## 📌 Project Overview
This project focuses on securing containerized environments using **Docker** and **Amazon ECS (Elastic Container Service)**. The goal is to demonstrate best practices for **container security**, **image vulnerability scanning**, and **deployment** using ECS with a Docker container.

You can view the live application at: [http://18.175.218.114/](http://18.175.218.114/)

## 🛠️ Technologies Used
- **Docker** – Containerization platform to build and run applications in containers.
- **Amazon ECS** – Managed service for running containers at scale.
- **Trivy** – Image vulnerability scanning tool to ensure security best practices are followed.
- **GitHub Actions** – CI/CD pipeline to automate building, scanning, and deploying Docker images.

## 🔑 Key Features
✅ **Docker image creation** with best security practices.  
✅ **Vulnerability scanning** using **Trivy** for high and critical vulnerabilities.  
✅ **ECS deployment** to ensure the image runs in a secure cloud environment.  
✅ **Automated CI/CD pipeline** through GitHub Actions to push images to Docker Hub and update ECS.  

## 🔒 Security Considerations
- **Only trusted base images** are used to minimize vulnerabilities.  
- **Regular image scanning** with Trivy to detect high and critical vulnerabilities.  
- **Automated deployment to ECS** with the latest secure image after every pipeline run.  
- **Least privilege IAM roles** to ensure ECS tasks and services have the minimal permissions necessary.  

## 📝 Workflow
The workflow includes the following steps:

1. **Build Docker image** – Using the Dockerfile, the image is built locally with the contents of the `app` folder.
2. **Scan Docker image** – The image is scanned using **Trivy** for vulnerabilities, and only the images that pass the scan are pushed to Docker Hub.
3. **Push Docker image to Docker Hub** – After successful scanning, the Docker image is pushed to Docker Hub for remote storage.
4. **Deploy to ECS** – Using a GitHub Actions pipeline, the image is pulled from Docker Hub and deployed to an ECS cluster, updating any existing ECS services with the new image.

## 🔄 ECS Update Process
After the Docker image is updated on Docker Hub:
- A new ECS task is created with the latest image.
- The old task is stopped once the new task starts running, ensuring seamless deployment.

This approach ensures that the ECS service is always running the most secure version of the containerized application.