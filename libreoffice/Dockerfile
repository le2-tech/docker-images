
# FROM ubuntu:latest
FROM ubuntu:rolling

# 1. 安装 LibreOffice
# https://packages.ubuntu.com/source/plucky/libreoffice
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libreoffice-core \
      libreoffice-writer \
      ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
