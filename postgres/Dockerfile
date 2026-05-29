
# postgresql-18-postgis-3 在 debian package 里只有sid源中有. https://packages.debian.org/sid/postgresql-18-postgis-3
# postgresql-17-postgis-3 在 trixie 源里有。 https://packages.debian.org/sid/postgresql-17-postgis-3
# FROM postgres:17-trixie
# https://wiki.postgresql.org/wiki/Apt 有办法安装最新的postgresql版本
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}postgres:18-trixie

ARG APT_REPOSITORY

RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi;

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      locales \
      ; \
    sed -i '/^# zh_CN.UTF-8/s/^# //g' /etc/locale.gen; \
    locale-gen; \
    locale -a | grep zh_CN.utf8

# 设置环境变量
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 安装 postgis
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      ; \
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      postgis \
      postgresql-$PG_MAJOR-postgis-3; \
    dpkg -l | grep postgis

