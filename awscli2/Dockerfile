# 第一阶段：构建 AWS CLI
FROM python:3.11-slim-bookworm AS awscli-builder

WORKDIR /usr/src/aws-cli

# 安装 AWS CLI 所需的依赖
RUN set -eux ;\
    apt-get update ; \
    apt-get install -y --no-install-recommends \
        git \
        gcc \
        libc-dev \
        libffi-dev \
        libssl-dev \
    ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* ;

# 克隆并安装 AWS CLI
# https://github.com/aws/aws-cli/
RUN set -eux ;\
    git clone --branch v2 --depth 1 https://github.com/aws/aws-cli.git . ; \
    pip install --no-cache-dir . --target /usr/local/aws-cli 

# 第二阶段：构建 session-manager-plugin，基于 GoLang 镜像
FROM golang:1.19 AS session-manager-builder

WORKDIR /usr/src/session-manager-plugin

# 克隆并编译 session-manager-plugin
# https://github.com/aws/session-manager-plugin/blob/mainline/makefile
RUN set -eux ;\
    git clone https://github.com/aws/session-manager-plugin.git . ; \
    gofmt -w . ;\
    # make checkstyle ; \
    ARCH=$(uname -m) ; \
    if [ "$ARCH" = "x86_64" ]; then \
        make build-linux-amd64 ; \
    elif [ "$ARCH" = "aarch64" ]; then \
        make build-arm64 ; \
    else \
        echo "Unsupported architecture: $ARCH" ; exit 1 ; \
    fi ;

# 最终阶段：合并所需的组件到一个新的镜像中
FROM debian:sid-slim

# 安装 Python
# https://packages.debian.org/sid/python3
RUN set -eux ;\
    apt update ; \
    apt install -y --no-install-recommends \
        python3 \
        # python3-pip \
        ; \
    rm -rf /var/lib/apt/lists/* ;\
    ln -svT /usr/bin/python3 /usr/local/bin/python ;\
    python --version ;

# https://packages.debian.org/sid/mysql-client
RUN set -eux ;\
    apt update ; \
    apt install -y --no-install-recommends \
        mysql-client \
        ; \
    rm -rf /var/lib/apt/lists/* ;\
    mysql --version ;

RUN set -eux ;\
    apt update ; \
    apt install -y --no-install-recommends \
        curl ca-certificates unzip net-tools socat procps \
        ; \
    rm -rf /var/lib/apt/lists/* ;

# 复制 AWS CLI 和它的依赖
COPY --from=awscli-builder /usr/local/aws-cli /usr/local/aws-cli

# 复制 session-manager-plugin 的二进制文件到最终镜像
COPY --from=session-manager-builder /usr/src/session-manager-plugin/bin/* /usr/local/session-manager-plugin/

# 设置 PYTHONPATH 环境变量来包括 AWS CLI 的库
ENV PYTHONPATH="/usr/local/aws-cli:${PYTHONPATH}"

ENV PATH=/usr/local/aws-cli/bin:/usr/local/session-manager-plugin/:${PATH}

RUN set -eux; \
    aws --version; \
    echo "complete -C '/usr/local/aws-cli/bin/aws_completer' aws" >> ~/.bashrc
