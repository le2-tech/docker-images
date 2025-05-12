
# FROM ubuntu:latest
# FROM ubuntu:rolling
FROM debian:experimental

# 1. 安装 LibreOffice
# https://packages.ubuntu.com/source/plucky/libreoffice
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libreoffice-core \
      libreoffice-writer \
    && rm -rf /var/lib/apt/lists/*
