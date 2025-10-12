# syntax=docker/dockerfile:1
FROM php:8.4-fpm

# Install the PHP zip extention
RUN  --mount=type=bind,from=mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    install-php-extensions zip pdo_pgsql gd bz2 bcmath intl redis xdebug msgpack apcu


# RUN docker-php-ext-install mysqli;

# RUN docker-php-ext-install exif; \

# RUN docker-php-ext-install sockets; \

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