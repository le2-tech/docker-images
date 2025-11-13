
# FROM ubuntu:latest
# FROM ubuntu:rolling

# https://packages.debian.org/search?suite=all&searchon=names&keywords=libreoffice-core
# https://packages.ubuntu.com/search?suite=all&searchon=names&keywords=libreoffice-core
FROM debian:latest

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
