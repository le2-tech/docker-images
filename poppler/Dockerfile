

FROM debian:latest

ARG APP_ENV=prod

RUN set -eux; \
  if [ "${APP_ENV:-}" = "dev" ]; then \
  sed -i "s|http://deb.debian.org|http://mirrors.aliyun.com|g" /etc/apt/sources.list.d/debian.sources; \
  fi

# 1. 安装 poppler-utils 使用 pdftotext（Poppler 工具集）
RUN set -eux; \
  apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  poppler-utils \
  ;\
  rm -rf /var/lib/apt/lists/*
