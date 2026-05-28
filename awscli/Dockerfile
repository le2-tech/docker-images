ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest

ARG APT_REPOSITORY
ARG TARGETARCH

RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      ; \
    case "${TARGETARCH:-$(dpkg --print-architecture)}" in \
      amd64) aws_arch="x86_64"; ssm_arch="ubuntu_64bit" ;; \
      arm64) aws_arch="aarch64"; ssm_arch="ubuntu_arm64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH:-$(dpkg --print-architecture)}" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}.zip" -o /tmp/awscliv2.zip; \
    unzip -q /tmp/awscliv2.zip -d /tmp; \
    /tmp/aws/install; \
    curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${ssm_arch}/session-manager-plugin.deb" -o /tmp/session-manager-plugin.deb; \
    dpkg -i /tmp/session-manager-plugin.deb; \
    apt-get purge -y --auto-remove curl unzip; \
    rm -rf \
      /var/lib/apt/lists/* \
      /var/cache/apt/* \
      /tmp/* \
      /var/tmp/*

RUN set -eux; \
    aws --version; \
    session-manager-plugin; \
    echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc
