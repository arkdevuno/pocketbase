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

# Health check
HEALTHCHECK --interval=60s --timeout=10s --start-period=120s --retries=5 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/_/ || exit 1

# Start as root, fix permissions, then switch to pocketbase user
CMD ["sh", "-c", "echo 'Fixing volume permissions...' && chown -R pocketbase:pocketbase /pb_data && echo 'Starting PocketBase...' && su pocketbase -c '/pb/pocketbase serve --http=0.0.0.0:8080 --dir=/pb_data'"]
