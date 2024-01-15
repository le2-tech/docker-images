# Use the official Go image as the base image
FROM golang:latest

# Install system packages, clean up apt cache, and remove unnecessary files in a single RUN step
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
       git vim tree zip less \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc /usr/share/man /tmp/*

# Install AWS CLI
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" \
#     && unzip awscliv2.zip \
#     && ./aws/install \
#     && rm -rf aws awscliv2.zip

# Optionally, set environment variables if needed
# ENV GOROOT /app

# Your additional Dockerfile instructions go here
