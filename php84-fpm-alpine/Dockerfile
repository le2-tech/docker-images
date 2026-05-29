# syntax=docker/dockerfile:1

ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}composer:2 AS composer

ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}mlocati/php-extension-installer:latest AS php-ext-installer

ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}php:8.4-fpm-alpine

# 使用 mlocati 的扩展安装器（兼容 Alpine）
RUN --mount=type=bind,from=php-ext-installer,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    # sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
    install-php-extensions zip pdo_pgsql gd bcmath intl redis xdebug

# 安装 Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# 使用生产配置
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Modify PHP-FPM configuration (listen on 9000)
RUN sed -i -e "s|^listen *=.*|listen = 9000|g" /usr/local/etc/php-fpm.d/www.conf

RUN apk add --no-cache \
    git \
    tzdata

# 工作目录
WORKDIR /www
