# Use a specific version of Alpine to ensure consistent builds and avoid breaking changes
FROM alpine:3.19

# Install necessary packages: unzip for extracting PocketBase, ca-certificates for SSL
RUN apk add --no-cache \
    unzip \
    ca-certificates && \
    # Create directories for PocketBase
    mkdir -p /pb && \
    mkdir -p /pb_data

# Use environment variable for PocketBase version - UPDATED TO LATEST
ENV PB_VERSION=${PB_VERSION:-0.29.2}

# Download PocketBase zip file using wget
RUN wget -qO /tmp/pb.zip https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip && \
    # Unzip the downloaded file into the /pb directory
    unzip /tmp/pb.zip -d /pb/ && \
    # Make the binary executable
    chmod +x /pb/pocketbase && \
    # Remove the zip file to reduce image size
    rm /tmp/pb.zip

# Create a non-root user for security (optional but recommended)
RUN adduser -D -s /bin/sh pocketbase && \
    chown -R pocketbase:pocketbase /pb /pb_data

# Set working directory
WORKDIR /pb

# Railway handles volumes - no VOLUME keyword needed
# Data will be mounted at /pb_data via Railway volume configuration

# Expose the default PocketBase port
EXPOSE 8080

# Switch to non-root user
USER pocketbase

# Health check to ensure PocketBase is running properly
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/_/ || exit 1

# Start PocketBase server with proper data directory and binding
# CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/pb_data"]
CMD ["sh", "-c", "sleep 5 && /pb/pocketbase serve --http=0.0.0.0:8080 --dir=/pb_data"]
