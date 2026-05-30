ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}golang:latest

# AWS Lambda Runtime Interface Emulator 二进制路径
ARG RIE_BINARY=/aws-lambda/aws-lambda-rie

# 下载 Lambda Runtime Interface Emulator（根据架构选择对应二进制）
RUN set -eux; \
    arch=$(uname -m) ; \
    base_url="https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download" ;\
    case "$arch" in \
        x86_64) binary="aws-lambda-rie-x86_64" ;; \
        aarch64) binary="aws-lambda-rie-arm64" ;; \
        *) echo "Unknown architecture" && exit 1 ;; \
        esac ; \
    mkdir -p /aws-lambda ; \
    curl -Lo "$RIE_BINARY" "$base_url/$binary" ; \
    chmod +x "$RIE_BINARY"
