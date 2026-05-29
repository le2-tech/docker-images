# FROM ubuntu:latest
# FROM ubuntu:rolling

# https://packages.debian.org/search?suite=all&searchon=names&keywords=libreoffice-core
# https://packages.ubuntu.com/search?suite=all&searchon=names&keywords=libreoffice-core
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}debian:latest

ARG APT_REPOSITORY

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      fontconfig \
      fonts-liberation2 \
      fonts-noto-cjk \
      libreoffice-core-nogui \
      libreoffice-writer-nogui \
      locales \
      ; \
    sed -i '/^# *zh_CN.UTF-8 UTF-8/s/^# *//g' /etc/locale.gen; \
    locale-gen zh_CN.UTF-8; \
    fc-cache -f; \
    fc-match "Noto Sans CJK SC"; \
    libreoffice --version; \
    rm -rf \
      /tmp/* \
      /var/tmp/* \
      /usr/share/doc/* \
      /usr/share/man/* \
      /usr/share/info/* \
      /usr/share/i18n/* \
      /usr/share/lintian/* \
      /usr/share/bug/* \
      /usr/share/bash-completion/* \
      /usr/share/locale/* \
      /usr/share/libreoffice/share/config \
      /usr/lib/libreoffice/share/gallery \
      /usr/lib/libreoffice/share/template

ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8
