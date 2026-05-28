ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest AS download

ARG APT_REPOSITORY

RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
      ;

RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "${arch}" in \
      amd64) aws_arch="x86_64" ;; \
      arm64) aws_arch="aarch64" ;; \
      *) echo "Unsupported architecture: ${arch}" >&2; exit 1 ;; \
    esac; \
    curl -fsSL --retry 5 --retry-delay 3 --retry-all-errors --connect-timeout 20 \
      "https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}.zip" \
      -o /tmp/awscliv2.zip; \
    unzip -q /tmp/awscliv2.zip -d /tmp; \
    /tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin; \
    rm -rf /tmp/aws /tmp/awscliv2.zip

RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "${arch}" in \
      amd64) ssm_arch="ubuntu_64bit" ;; \
      arm64) ssm_arch="ubuntu_arm64" ;; \
      *) echo "Unsupported architecture: ${arch}" >&2; exit 1 ;; \
    esac; \
    curl -fsSL --retry 5 --retry-delay 3 --retry-all-errors --connect-timeout 20 \
      "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/${ssm_arch}/session-manager-plugin.deb" \
      -o /tmp/session-manager-plugin.deb; \
    mkdir -p /tmp/session-manager-plugin-root; \
    dpkg-deb -x /tmp/session-manager-plugin.deb /tmp/session-manager-plugin-root; \
    rm -f /tmp/session-manager-plugin.deb

ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest

ARG APT_REPOSITORY

RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      ;

COPY --from=download /usr/local/aws-cli /usr/local/aws-cli
COPY --from=download /tmp/session-manager-plugin-root/usr/local/sessionmanagerplugin /usr/local/sessionmanagerplugin

RUN set -eux; \
    ln -sf /usr/local/aws-cli/v2/current/bin/aws /usr/local/bin/aws; \
    ln -sf /usr/local/aws-cli/v2/current/bin/aws_completer /usr/local/bin/aws_completer; \
    ln -sf /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin; \
    aws --version; \
    session-manager-plugin; \
    echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc
