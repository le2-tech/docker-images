# 预下载 composer 二进制（通过镜像源加速）
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}composer:2 AS composer

# 预下载 php-extension-installer（通过镜像源加速）
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}mlocati/php-extension-installer:latest AS php-ext-installer

ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}php:8.4-fpm

# 替换为国内镜像源加速下载
ARG APT_REPOSITORY
RUN set -eux; \
    if [ -n "${APT_REPOSITORY:-}" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i "s|http://deb.debian.org|${APT_REPOSITORY}|g" /etc/apt/sources.list.d/debian.sources; \
    fi

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        tzdata \
    ; \
    rm -rf /var/lib/apt/lists/*

# 安装 PHP 扩展
RUN --mount=type=bind,from=php-ext-installer,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    install-php-extensions zip pdo_pgsql gd bcmath intl redis xdebug

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /www
