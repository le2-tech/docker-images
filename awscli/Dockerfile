# FROM ubuntu:latest
FROM debian:sid-slim

RUN apt-get update -y \
        && apt-get install -y --no-install-recommends \
            mysql-client curl ca-certificates unzip net-tools socat procps less \
        && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip"; \
    unzip awscliv2.zip; \
    ./aws/install; \
    rm -fr awscliv2.zip; \
    aws --version; \
    echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc


# 安装 Session Manager 插件
# 根据目标架构选择相应的链接
# https://docs.aws.amazon.com/zh_cn/systems-manager/latest/userguide/install-plugin-linux.html
RUN architecture=$(uname -m) && \
    case $architecture in \
        x86_64) plugin_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" ;; \
        i686) plugin_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_32bit/session-manager-plugin.deb" ;; \
        aarch64) plugin_url="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" ;; \
        *) echo "Unsupported architecture: $architecture" && exit 1 ;; \
    esac \
    && curl "$plugin_url" -o "session-manager-plugin.deb" \
    && dpkg -i session-manager-plugin.deb \
    && rm -f session-manager-plugin.deb
