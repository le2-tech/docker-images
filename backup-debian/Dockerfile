ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:trixie-slim AS download

ARG APT_REPOSITORY

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=backup-debian-apt-cache \
    --mount=type=cache,target=/var/lib/apt,sharing=locked,id=backup-debian-apt-lib \
    set -eux; \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      ;

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
    chmod 755 /usr/local/bin/mc; \
    mc --version

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
    rm -fr /tmp/ossutil*; \
    ossutil version

ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:trixie-slim

ARG APT_REPOSITORY

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=backup-debian-apt-cache \
    --mount=type=cache,target=/var/lib/apt,sharing=locked,id=backup-debian-apt-lib \
    set -eux; \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      busybox-static \
      ca-certificates \
      postgresql-client \
      ; \
    ln -sf /bin/busybox /usr/sbin/crond; \
    printf '%s\n' '#!/bin/sh' 'exec /usr/sbin/crond "$@"' > /usr/sbin/cron; \
    chmod 755 /usr/sbin/cron; \
    rm -rf \
      /usr/share/doc/* \
      /usr/share/man/* \
      /usr/share/info/* \
      /usr/share/lintian/* \
      /usr/share/bug/*

COPY --from=download /usr/local/bin/mc /usr/local/bin/mc
COPY --from=download /usr/local/bin/ossutil /usr/local/bin/ossutil

RUN set -eux; \
    ossutil version; \
    psql -V; \
    mc --version; \
    busybox --list | grep -x crond
