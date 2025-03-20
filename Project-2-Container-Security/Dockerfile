# Use the official Python image from Docker Hub as the base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the contents of the local "app" directory to the container's /app directory
COPY app /app

# Expose port 80 so the container can communicate with the outside world
EXPOSE 80

# Run Python's built-in HTTP server on port 80
CMD ["python3", "-m", "http.server", "80"]