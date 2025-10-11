
FROM debian:trixie-slim

ARG OSSUTIL_VERSION=2.1.2

# 安装必须依赖并下载/解压 ossutil（仅 Linux 包）
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends ca-certificates curl unzip cron ; \
    # rm -rf /var/lib/apt/lists/*; \
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
    # 构建期自检
    ossutil --help >/dev/null

# WORKDIR /work
