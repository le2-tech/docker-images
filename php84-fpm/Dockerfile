# syntax=docker/dockerfile:1
FROM php:8.4-fpm

# Install the PHP zip extention
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libzip-dev zip unzip ; \
    docker-php-ext-install -j"$(nproc)" zip; \
    apt-get purge -y --auto-remove libzip-dev; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libzip5 ; \
    php -m | grep zip;

# Install the PHP pdo_pgsql extention
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libpq-dev \
    ; \
    # Install the PHP pdo_mysql extention
    # docker-php-ext-install -j"$(nproc)" pdo_mysql; \
    # Install the PHP pdo_pgsql extention
    docker-php-ext-install -j"$(nproc)" pdo_pgsql; \
    apt-get purge -y --auto-remove libpq-dev; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libpq5 ; \
    php -m | grep pdo_pgsql;

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libjpeg-dev libpng-dev libwebp-dev libxpm-dev libfreetype-dev ; \
    docker-php-ext-configure gd --prefix=/usr --with-jpeg --with-webp --with-xpm --with-freetype; \
    docker-php-ext-install -j"$(nproc)" gd; \
    apt-get purge -y --auto-remove libjpeg-dev libpng-dev libwebp-dev libxpm-dev libfreetype-dev; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libpng16-16 libfreetype6 ; \
    php -m | grep gd;


RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libbz2-dev ; \
    docker-php-ext-install -j"$(nproc)" bz2; \
    apt-get purge -y --auto-remove libbz2-dev ; \
    php -m | grep bz2;

RUN docker-php-ext-install -j"$(nproc)" bcmath; \
    php -m | grep bcmath;

# RUN docker-php-ext-install -j"$(nproc)" mysqli;

# RUN docker-php-ext-install -j"$(nproc)" exif; \

# RUN docker-php-ext-install -j"$(nproc)" sockets; \

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
    set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libicu-dev ; \
    docker-php-ext-configure intl ; \
    docker-php-ext-install -j"$(nproc)" intl; \
    apt-get purge -y --auto-remove libicu-dev; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libicu76 ;\
    php -m | grep intl;

RUN --mount=type=cache,target=/tmp/pear,sharing=locked,id=pear-tmp \
    set -eux; \
    pecl install -o -f redis; \
    docker-php-ext-enable redis;\
    php -m | grep redis;

# Install the xdebug extension
# https://xdebug.org/docs/compat
# https://pecl.php.net/package/xdebug
RUN --mount=type=cache,target=/tmp/pear,sharing=locked,id=pear-tmp \
    set -eux; \
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
        # pecl install xdebug-3.4.6; \
        pecl install xdebug; \
    elif [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
        pecl install xdebug-3.1.6; \
    fi; \
    docker-php-ext-enable xdebug; \
    php -m | grep xdebug;

RUN --mount=type=cache,target=/tmp/pear,sharing=locked,id=pear-tmp \
    set -eux; \
    pecl install -o -f msgpack; \
    docker-php-ext-enable msgpack; \
    php -m | grep msgpack;

RUN --mount=type=cache,target=/tmp/pear,sharing=locked,id=pear-tmp \
    set -eux; \
    pecl install apcu; \
    docker-php-ext-enable apcu; \
    php -m | grep apcu;

# Install Composer
# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
#     php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
#     php -r "unlink('composer-setup.php');"
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configure PHP settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Modify PHP-FPM configuration
RUN sed -i -e "s/^listen *=.*/listen = 9000/g" /usr/local/etc/php-fpm.d/www.conf;

# Install additional packages
# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=apt-cache \
#     --mount=type=cache,target=/var/lib/apt/lists,sharing=locked,id=apt-lists \
#     apt-get update; \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#         curl \
#         procps \
#         vim \
#         jq \
#         iputils-ping \
#         net-tools \
#         apt-utils \
#         gnupg2 \
#         git \
#     ;

# Set working directory
WORKDIR /www