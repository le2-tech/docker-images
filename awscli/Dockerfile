# FROM ubuntu:latest
FROM debian:sid-slim

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    	mysql-client curl ca-certificates unzip net-tools socat procps less jq; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip"; \
    unzip -q awscliv2.zip; \
    ./aws/install; \
    rm -fr awscliv2.zip; \
    aws --version; \
    echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc


# 安装 Session Manager 插件
# 根据目标架构选择相应的链接
# https://docs.aws.amazon.com/zh_cn/systems-manager/latest/userguide/install-plugin-linux.html
RUN set -eux; \
    arch=$(uname -m); \
    case "$arch" in \
      x86_64)  pkg="ubuntu_64bit" ;; \
      i686)    pkg="ubuntu_32bit" ;; \
      aarch64) pkg="linux_arm64" ;; \
      *) echo "Unsupported architecture: $arch" >&2 && exit 1 ;; \
    esac; \
    plugin_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${pkg}/session-manager-plugin.deb"; \
    # -f = fail on HTTP errors, -S = show errors, -L = follow redirects
    curl -fSL "$plugin_url" -o session-manager-plugin.deb; \
    dpkg -i session-manager-plugin.deb; \
    rm session-manager-plugin.deb
