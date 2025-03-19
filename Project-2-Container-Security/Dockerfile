# Use Alpine as the base image
FROM alpine:3.16

# Install Python3 (and pip if needed) so we can run a web server
RUN apk add --no-cache python3

# Create a non-root user and group for the application
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Switch to the non-root user
USER appuser

# Set the working directory inside the container
WORKDIR /app

# Copy the contents of the local "app" folder into the container's /app folder
COPY --chown=appuser:appgroup ./app /app

# Expose port 8080 so the container can communicate externally
EXPOSE 8080

# Run Python's built-in HTTP server on port 8080
CMD ["python3", "-m", "http.server", "8080"]
