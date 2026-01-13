# syntax=docker/dockerfile:1
FROM php:8.4-cli-alpine

# 使用 mlocati 的扩展安装器（兼容 Alpine）
RUN --mount=type=bind,from=mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    # sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
    install-php-extensions zip pdo_pgsql gd bz2 bcmath intl redis xdebug msgpack apcu \
    pcntl

# 可选扩展（与原文件一致，按需开启）
# RUN docker-php-ext-install mysqli
# RUN docker-php-ext-install exif
# RUN docker-php-ext-install sockets

# 安装 Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 使用生产配置
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 安装系统包：Alpine 下使用 apk；cron 对应 crond（dcron 包）
RUN set -eux; \
    apk add --no-cache cronie sudo; \
    echo "www-data ALL=(ALL) NOPASSWD: /usr/sbin/crond" >> /etc/sudoers

# （可选）更多常用工具，按需打开
# RUN apk add --no-cache \
#     curl \
#     procps \
#     vim \
#     jq \
#     iputils \
#     net-tools \
#     git \
#     gnupg

RUN apk add --no-cache git

# 工作目录
WORKDIR /www
