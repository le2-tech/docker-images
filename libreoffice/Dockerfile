
FROM ubuntu:latest

# 1. 安装 LibreOffice
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libreoffice-core \
      libreoffice-writer \
    && rm -rf /var/lib/apt/lists/*
