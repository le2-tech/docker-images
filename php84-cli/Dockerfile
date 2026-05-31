
# 预下载 composer 二进制（通过镜像源加速）
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}composer:2 AS composer

# 预下载 php-extension-installer（通过镜像源加速）
ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}mlocati/php-extension-installer:latest AS php-ext-installer

ARG IMAGE_MIRROR
FROM ${IMAGE_MIRROR}php:8.4-cli

ARG APT_REPOSITORY

# 安装 PHP 扩展
RUN  --mount=type=bind,from=php-ext-installer,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    install-php-extensions zip pdo_pgsql gd bcmath intl redis xdebug pcntl

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /www
