
# postgresql-18-postgis-3 在 debian package 里只有sid源中有. https://packages.debian.org/sid/postgresql-18-postgis-3
# postgresql-17-postgis-3 在 trixie 源里有。 https://packages.debian.org/sid/postgresql-17-postgis-3
# FROM postgres:17-trixie
# https://wiki.postgresql.org/wiki/Apt 有办法安装最新的postgresql版本
FROM postgres:18-trixie

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      locales \
      ; \
    sed -i '/^# zh_CN.UTF-8/s/^# //g' /etc/locale.gen; \
    locale-gen; \
    rm -rf /var/lib/apt/lists/*

# 设置环境变量
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 1. 安装 postgis
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      postgresql-common ca-certificates \
      ; \
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      postgis \
      postgresql-$PG_MAJOR-postgis-3 \
      ; \
    rm -rf /var/lib/apt/lists/*

# 4) 初始化脚本：首次启动时为目标数据库创建扩展
# COPY initdb/ /docker-entrypoint-initdb.d/