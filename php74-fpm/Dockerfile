# Use the official PHP 7.4 image as a base image
FROM php:7.4-fpm

# Set the environment variable
ARG DOCKER_ENV=dev

# Set user and group IDs if provided as build arguments
ARG USER_ID=1000
ARG GROUP_ID=1000

# Install system dependencies and clean up
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libwebp-dev libicu-dev \
        git procps grep curl wget unzip vim jq iputils-ping \
        zlib1g-dev mariadb-client libzip-dev libpq-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
        net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions and configure them
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) bcmath zip mysqli pdo_mysql gd exif opcache intl && \
    if [ "$DOCKER_ENV" = "local" ]; then \
        pecl install xdebug-3.1.6 && \
        docker-php-ext-enable xdebug; \
    fi && \
    pecl install redis msgpack apcu && \
    docker-php-ext-enable redis msgpack apcu

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# Copy custom PHP configuration
COPY config/ /tmp/

# Configure PHP settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN if [ "$DOCKER_ENV" = "local" ]; then \
mv /tmp/php.ini-dev $PHP_INI_DIR/conf.d/php.ini; \
    else \
        mv /tmp/php.ini-prod $PHP_INI_DIR/conf.d/php.ini; \
    fi

# Modify PHP-FPM configuration
RUN sed -i -e "s/www-data/www/g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e "s/^listen *=.*/listen = 9000/g" \
           -e "s/^listen.allowed_clients *=.*/;listen.allowed_clients = 127.0.0.1/g" \
           -e "s/^;listen.owner *=.*/listen.owner = www-data/g" \
           -e "s/^;listen.group *=.*/listen.group = www-data/g" \
           -e "s/^;listen.mode *=.*/listen.mode = 0660/g" /usr/local/etc/php-fpm.d/www.conf

# Modify www-data user and group IDs, create directories, and set permissions
RUN groupmod -g ${GROUP_ID} www-data && \
    usermod -u ${USER_ID} www-data && \
    mkdir -p /home/www-data /www /var/www && \
    chown -R www-data:www-data /home/www-data /www /var/www

# Set user and working directory
USER www-data
WORKDIR /www

# Expose PHP-FPM port
EXPOSE 9000
