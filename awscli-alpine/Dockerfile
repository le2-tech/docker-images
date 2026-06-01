ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}alpine:latest

ARG ALPINE_MIRROR

# 替换为国内镜像源加速下载
RUN set -eux; \
    if [ -n "${ALPINE_MIRROR:-}" ]; then \
        sed -i "s|https://dl-cdn.alpinelinux.org|${ALPINE_MIRROR}|g" /etc/apk/repositories; \
    fi; \
    apk add --no-cache \
        aws-cli \
        # aws-session-manager-plugin 
    ; \
    aws --version
