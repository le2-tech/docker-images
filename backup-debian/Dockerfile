ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest

ARG APT_REPOSITORY

# 替换为国内镜像源加速下载
RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

# 安装运行依赖
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=backup-debian-apt-cache \
    --mount=type=cache,target=/var/lib/apt,sharing=locked,id=backup-debian-apt-lib \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      postgresql-common \
    ; \
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        postgresql-client-18; \
    rm -rf \
      /usr/share/doc/* \
      /usr/share/man/* \
      /usr/share/info/* \
      /usr/share/lintian/* \
      /usr/share/bug/*

# 下载 Supercronic
# https://github.com/aptible/supercronic
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64) supercronic_arch="linux-amd64" ;; \
      arm64) supercronic_arch="linux-arm64" ;; \
      *) echo "unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    curl -fsSL --retry 5 --retry-delay 3 --retry-all-errors --connect-timeout 20 \
      -o /usr/local/bin/supercronic \
      "https://github.com/aptible/supercronic/releases/latest/download/supercronic-${supercronic_arch}"; \
    chmod 755 /usr/local/bin/supercronic

# 下载 mc（MinIO Client）
# https://github.com/minio/mc#binary-download
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64) mc_arch="linux-amd64" ;; \
      arm64) mc_arch="linux-arm64" ;; \
      *) echo "unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    curl -fsSL --retry 5 --retry-delay 3 --retry-all-errors --connect-timeout 20 \
      -o /usr/local/bin/mc \
      "https://dl.min.io/client/mc/release/${mc_arch}/mc"; \
    chmod 755 /usr/local/bin/mc

# 下载 ossutil（阿里云 OSS 命令行工具）
# https://help.aliyun.com/zh/oss/developer-reference/install-ossutil2
RUN set -eux; \
    OSSUTIL_VERSION=2.3.0; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64) osspkg="linux-amd64" ;; \
      arm64) osspkg="linux-arm64" ;; \
      *) echo "unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    curl -fsSL --retry 5 --retry-delay 3 --retry-all-errors --connect-timeout 20 \
      -o /tmp/ossutil.zip \
      "https://gosspublic.alicdn.com/ossutil/v2/${OSSUTIL_VERSION}/ossutil-${OSSUTIL_VERSION}-${osspkg}.zip"; \
    unzip -q /tmp/ossutil.zip -d /tmp/; \
    install -m 755 "/tmp/ossutil-${OSSUTIL_VERSION}-${osspkg}/ossutil" /usr/local/bin/ossutil; \
    rm -fr /tmp/ossutil*
