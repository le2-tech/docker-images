
# FROM ubuntu:latest
# FROM ubuntu:rolling

# https://packages.debian.org/search?suite=all&searchon=names&keywords=libreoffice-core
# https://packages.ubuntu.com/search?suite=all&searchon=names&keywords=libreoffice-core
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest

ARG APP_ENV=prod

RUN set -eux; \
  if [ "${APP_ENV:-}" = "dev" ]; then \
  sed -i "s|http://deb.debian.org|http://mirrors.aliyun.com|g" /etc/apt/sources.list.d/debian.sources; \
  fi

# 1. 安装 LibreOffice
# https://packages.ubuntu.com/source/plucky/libreoffice
RUN set -eux; \
  apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  libreoffice-core-nogui \
  libreoffice-writer-nogui \
  ; \
  apt-get clean; \
  rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/* \
  /usr/share/doc/* \
  /usr/share/man/* \
  /usr/share/info/* \
  /usr/share/lintian/* \
  /usr/share/bug/* \
  /usr/share/bash-completion/* \
  /usr/share/locale/* \
  /usr/lib/libreoffice/share/gallery \
  /usr/lib/libreoffice/share/template
