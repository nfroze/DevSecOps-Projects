# Stage 1: Builder Stage using Node 16 on Debian Buster
FROM node:16-buster as builder

WORKDIR /juice-shop

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Update apt-get and install Python3 and build-essential
RUN apt-get update && \
    apt-get install -y python3 build-essential && \
    rm -rf /var/lib/apt/lists/*

# Explicitly configure npm to use python3 for node-gyp
RUN npm config set python /usr/bin/python3
ENV PYTHON=/usr/bin/python3
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Install production dependencies using npm ci
RUN npm ci --production --verbose

# Copy the rest of the application source code
COPY . .

# Stage 2: Final Runtime Image using Node 16 on Debian Buster
FROM node:16-buster

WORKDIR /juice-shop

# Copy the built application from the builder stage
COPY --from=builder /juice-shop .

EXPOSE 3000

CMD ["npm", "start"]
