# postgresql-18-postgis-3 在 debian package 里只有sid源中有. https://packages.debian.org/sid/postgresql-18-postgis-3
# postgresql-17-postgis-3 在 trixie 源里有。 https://packages.debian.org/sid/postgresql-17-postgis-3
# FROM postgres:17-trixie
# https://wiki.postgresql.org/wiki/Apt 有办法安装最新的postgresql版本
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}postgres:18-trixie

ARG APT_REPOSITORY

# 替换为国内镜像源加速下载
RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

# 生成中文 locale
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      locales \
    ; \
    sed -i '/^# zh_CN.UTF-8/s/^# //g' /etc/locale.gen; \
    locale-gen

ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 安装 PostGIS 扩展（$PG_MAJOR 由基础镜像 postgres:18-trixie 提供）
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      postgis \
      postgresql-$PG_MAJOR-postgis-3
