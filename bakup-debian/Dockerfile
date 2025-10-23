# syntax=docker/dockerfile:1
FROM debian:sid-slim

ENV DEBIAN_FRONTEND=noninteractive

# 安装必须依赖
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl unzip cron ;

# postgresql-client 在sid源中只有18版本
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends postgresql-client;

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
    set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends minio-client; \
    ln -sf /usr/bin/minio-client /usr/local/bin/mc;

# 安装ossutil
# https://help.aliyun.com/zh/oss/developer-reference/install-ossutil2
RUN set -eux; \
    OSSUTIL_VERSION=2.1.2; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64) osspkg="linux-amd64";; \
      arm64) osspkg="linux-arm64";; \
      *) echo "unsupported architecture: $arch"; exit 1;; \
    esac; \
    curl -fsSL -o /tmp/ossutil.zip \
      "https://gosspublic.alicdn.com/ossutil/v2/${OSSUTIL_VERSION}/ossutil-${OSSUTIL_VERSION}-${osspkg}.zip"; \
    unzip -q /tmp/ossutil.zip -d /tmp/; \
    install -m 755 "/tmp/ossutil-${OSSUTIL_VERSION}-${osspkg}/ossutil" /usr/local/bin/ossutil; \
    rm -fr /tmp/ossutil*; \
    ossutil --help >/dev/null

RUN set -eux; \
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o /tmp/awscliv2.zip; \
    unzip -q /tmp/awscliv2.zip -d /tmp; \
    /tmp/aws/install --update; \
    rm -rf /tmp/awscliv2.zip /tmp/aws; \
    aws --version; \
    echo "complete -C '/usr/local/bin/aws_completer' aws" >> /etc/bash.bashrc
