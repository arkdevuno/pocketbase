# Use a specific version of Alpine to ensure consistent builds and avoid breaking changes
FROM alpine:3.19

# Install necessary packages
RUN apk add --no-cache \
    unzip \
    ca-certificates && \
    mkdir -p /pb

# Use environment variable for PocketBase version
ENV PB_VERSION=${PB_VERSION:-0.29.2}

# Download PocketBase
RUN wget -qO /tmp/pb.zip https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip && \
    unzip /tmp/pb.zip -d /pb/ && \
    chmod +x /pb/pocketbase && \
    rm /tmp/pb.zip

# Create a non-root user
RUN adduser -D -s /bin/sh pocketbase

# Set working directory
WORKDIR /pb

# Expose the default PocketBase port
EXPOSE 8080

# Longer healthcheck intervals - give more time for startup
HEALTHCHECK --interval=60s --timeout=10s --start-period=120s --retries=5 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/_/ || exit 1

# Switch to non-root user
USER pocketbase

# Wait longer for volume mount with timeout
CMD ["sh", "-c", "echo 'Waiting for volume mount...' && timeout=60 && while [ ! -d /pb_data ] && [ $timeout -gt 0 ]; do echo 'Volume not ready, waiting... ($timeout seconds left)'; sleep 5; timeout=$((timeout-5)); done && if [ ! -d /pb_data ]; then echo 'Volume mount failed after 60 seconds'; exit 1; fi && echo 'Volume mounted successfully, starting PocketBase...' && /pb/pocketbase serve --http=0.0.0.0:8080 --dir=/pb_data"]
