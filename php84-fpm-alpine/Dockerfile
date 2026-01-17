# syntax=docker/dockerfile:1
FROM php:8.4-fpm-alpine

# Install PHP extensions via mlocati installer (works on Alpine)
RUN --mount=type=bind,from=mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    # sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
    install-php-extensions zip pdo_pgsql gd bz2 bcmath intl redis xdebug msgpack apcu

# 可按需启用内置扩展（Alpine 同样适用）
# RUN docker-php-ext-install mysqli
# RUN docker-php-ext-install exif
# RUN docker-php-ext-install sockets

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configure PHP settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Modify PHP-FPM configuration (listen on 9000)
RUN sed -i -e "s|^listen *=.*|listen = 9000|g" /usr/local/etc/php-fpm.d/www.conf

# Install additional packages (Alpine / apk 版本示例)
# RUN --mount=type=cache,target=/var/cache/apk,sharing=locked,id=apk-cache \
#     set -eux; \
#     apk add --no-cache \
#         curl \
#         procps \
#         vim \
#         jq \
#         iputils \
#         net-tools \
#         git \
#         gnupg \
#         tzdata \
#         bash

RUN apk add --no-cache git tzdata

# Set working directory
WORKDIR /www
