# Use the official Go image as the base image
FROM golang:latest

# Install system packages, clean up apt cache, and remove unnecessary files in a single RUN step
RUN set -eux; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends \
       git vim tree zip less \
       ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*;\
    go version;
