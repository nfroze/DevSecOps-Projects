# Use Alpine as the base image
FROM alpine:3.16

# Install any necessary packages (if needed, e.g., for a web server)
# RUN apk add --no-cache <package-name>

# Create a non-root user and group for the application
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Switch to the non-root user
USER appuser

# Create an application directory and copy your app code (for demo, we'll use a simple script)
WORKDIR /app
COPY --chown=appuser:appgroup ./app /app

# Expose a port (if applicable; adjust as necessary)
EXPOSE 8080

# Define the default command (for demo, a simple echo and sleep)
CMD ["sh", "-c", "echo 'Hello from a secure container' && sleep 3600"]