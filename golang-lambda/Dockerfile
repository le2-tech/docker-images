# Use the official Golang image as the base image
FROM golang:latest

# Set environment variable for AWS Lambda Runtime Interface Emulator binary
ENV RIE_BINARY /aws-lambda/aws-lambda-rie

# Detect the architecture and set the appropriate binary URL
RUN set -eux; \
    arch=$(uname -m) ; \
    base_url="https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download" ;\
    case "$arch" in \
        x86_64) binary="aws-lambda-rie-x86_64" ;; \
        aarch64) binary="aws-lambda-rie-arm64" ;; \
        *) echo "Unknown architecture" && exit 1 ;; \
        esac ; \
    mkdir -p /aws-lambda ; \
    curl -Lo "$RIE_BINARY" "$base_url/$binary" ; \
    chmod +x "$RIE_BINARY" ;
