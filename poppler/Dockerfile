

FROM debian:latest

# 1. 安装 poppler-utils 使用 pdftotext（Poppler 工具集）
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      poppler-utils \
    && rm -rf /var/lib/apt/lists/*
