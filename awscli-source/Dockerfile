# 第一阶段：编译 AWS CLI（从 GitHub 源码 pip install）
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}python:latest AS awscli-builder

WORKDIR /usr/src/aws-cli

ARG APT_REPOSITORY

# 替换为国内镜像源加速下载
RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

# 安装编译依赖
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git \
        gcc \
        libc-dev \
        libffi-dev \
        libssl-dev \
        ;

# 克隆并安装 AWS CLI v2
# https://github.com/aws/aws-cli/
ARG AWS_CLI_VERSION=v2
RUN set -eux; \
    git clone --progress --branch "${AWS_CLI_VERSION}" --depth 1 https://github.com/aws/aws-cli.git . ; \
    pip install --no-cache-dir . --target /usr/local/aws-cli

# 第二阶段：编译 session-manager-plugin
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}golang:latest AS session-manager-builder

WORKDIR /usr/src/session-manager-plugin

# 克隆并编译 session-manager-plugin
# https://github.com/aws/session-manager-plugin/blob/mainline/makefile
ARG SSM_PLUGIN_VERSION=mainline
RUN set -eux; \
    git clone --branch "${SSM_PLUGIN_VERSION}" --depth 1 https://github.com/aws/session-manager-plugin.git . ; \
    sed -i 's/go build -i/go build/' makefile; \
    gofmt -w . ;\
    ARCH=$(uname -m) ; \
    if [ "$ARCH" = "x86_64" ]; then \
        make build-linux-amd64 ; \
    elif [ "$ARCH" = "aarch64" ]; then \
        make build-arm64 ; \
    else \
        echo "Unsupported architecture: $ARCH" ; exit 1 ; \
    fi ;

# 最终阶段：合并产物到精简运行镜像
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest

ARG APT_REPOSITORY

# 替换为国内镜像源加速下载
RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

# 安装 Python 运行环境
# https://packages.debian.org/sid/python3
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3 \
        ; \
    ln -svT /usr/bin/python3 /usr/local/bin/python;

COPY --from=awscli-builder /usr/local/aws-cli /usr/local/aws-cli

# 修复 shebang：构建阶段 python 路径与最终镜像不同
RUN find /usr/local/aws-cli/bin -type f -exec sed -i '1s|^#!/usr/local/bin/python[0-9.]*|#!/usr/bin/python3|' {} \;

COPY --from=session-manager-builder /usr/src/session-manager-plugin/bin/* /usr/local/session-manager-plugin/

# 创建 symlink 到标准 PATH
RUN set -eux; \
    ln -sf /usr/local/aws-cli/bin/aws /usr/local/bin/aws; \
    ln -sf /usr/local/aws-cli/bin/aws_completer /usr/local/bin/aws_completer; \
    echo "complete -C '/usr/local/aws-cli/bin/aws_completer' aws" >> ~/.bashrc

ENV PYTHONPATH=/usr/local/aws-cli
ENV PATH=/usr/local/aws-cli/bin:/usr/local/session-manager-plugin:${PATH}
