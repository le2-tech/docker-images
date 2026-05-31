
# 预下载 composer 二进制（通过镜像源加速）
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}composer:2 AS composer

# 预下载 php-extension-installer（通过镜像源加速）
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}mlocati/php-extension-installer:latest AS php-ext-installer

ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}php:8.4-fpm-alpine

ARG ALPINE_MIRROR

# 替换为国内镜像源加速下载
RUN set -eux; \
    if [ -n "${ALPINE_MIRROR:-}" ]; then \
      sed -i "s|https://dl-cdn.alpinelinux.org|${ALPINE_MIRROR}|g" /etc/apk/repositories; \
    fi

# 安装 PHP 扩展（兼容 Alpine 的 mlocati 安装器）
RUN --mount=type=bind,from=php-ext-installer,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    install-php-extensions zip pdo_pgsql gd bcmath intl redis xdebug

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# 配置 PHP-FPM 监听端口
RUN sed -i -e "s|^listen *=.*|listen = 9000|g" /usr/local/etc/php-fpm.d/www.conf

# 安装运行依赖
RUN apk add --no-cache \
    ca-certificates \
    git \
    tzdata

WORKDIR /www
