ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}openjdk:22-bookworm

ARG APT_REPOSITORY

# 替换为国内镜像源加速下载
RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

# 安装 SchemaSpy 运行依赖
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      curl \
      unzip \
      graphviz \
      ;

# 下载 SchemaSpy 和 MySQL 驱动
RUN curl -L https://github.com/schemaspy/schemaspy/releases/download/v6.2.4/schemaspy-6.2.4.jar -o /tmp/schemaspy.jar \
    && curl -L https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar -o /tmp/mysql-connector-j.jar