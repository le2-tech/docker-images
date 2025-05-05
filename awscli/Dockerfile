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
# https://docs.aws.amazon.com/zh_cn/systems-manager/latest/userguide/install-plugin-debian-and-ubuntu.html
# RUN set -eux; \
#     architecture=$(uname -m); \
#     case $architecture in \
#         x86_64) plugin_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" ;; \
#         i686) plugin_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_32bit/session-manager-plugin.deb" ;; \
#         aarch64) plugin_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" ;; \
#         *) echo "Unsupported architecture: $architecture" && exit 1 ;; \
#     esac \
#     ; \
#     curl "$plugin_url" -o "session-manager-plugin.deb"; \
#     dpkg -i session-manager-plugin.deb; \
#     rm -f session-manager-plugin.deb

RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64)  pkg="ubuntu_64bit" ;; \
      i686)    pkg="ubuntu_32bit" ;; \
      aarch64) pkg="ubuntu_arm64" ;; \
      *) echo "Unsupported architecture: $arch" >&2 && exit 1 ;; \
    esac; \
    plugin_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${pkg}/session-manager-plugin.deb"; \
    # -f 失败时报错，-S 显示错误信息，-L 跟随重定向
    curl -fSL "$plugin_url" -o session-manager-plugin.deb; \
    dpkg -i session-manager-plugin.deb; \
    rm session-manager-plugin.deb