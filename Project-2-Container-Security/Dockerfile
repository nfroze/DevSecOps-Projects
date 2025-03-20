# Use the official Python image from Docker Hub as the base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Update apt packages to get the latest security patches for perl-base and zlib1g
RUN apt-get update && apt-get upgrade -y perl-base zlib1g && rm -rf /var/lib/apt/lists/*

# Install the latest version of setuptools to fix vulnerabilities
RUN pip install --upgrade setuptools

# Install any additional dependencies, if necessary
# For example, if you want to install other Python packages:
# RUN pip install <package-name>

# Copy the contents of the local "app" directory to the container's /app directory
COPY app /app

# Expose port 80 so the container can communicate with the outside world
EXPOSE 80

# Run Python's built-in HTTP server on port 80
CMD ["python3", "-m", "http.server", "80"]