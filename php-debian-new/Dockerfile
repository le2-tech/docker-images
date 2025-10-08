
ARG BASE_IMAGE
ARG BASE_IMAGE_TAG
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}

# Install the PHP zip extention
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
        libzip-dev zlib1g-dev libz-dev zip unzip \
    ; \
    docker-php-ext-install zip; 
    # docker-php-source delete;
    # apt-get purge -y --auto-remove libzip-dev zlib1g-dev libz-dev; \
    # apt-get install -yqq libzip5 zlib1g; \
    # rm -rf /var/lib/apt/lists/*; 

# Install the PHP pdo_pgsql extention
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
        libpq-dev \
    ; \
    # Install the PHP pdo_mysql extention
    # docker-php-ext-install pdo_mysql; \
    # Install the PHP pdo_pgsql extention
    docker-php-ext-install pdo_pgsql;
    # docker-php-source delete;
    # apt-get purge -y --auto-remove libpq-dev; \
    # apt-get install -yqq libpq5; \
    # rm -rf /var/lib/apt/lists/*;

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
        libjpeg-dev libpng-dev libwebp-dev libxpm-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure gd \
    --prefix=/usr \
    --with-jpeg \
    --with-webp \
    --with-xpm \
    --with-freetype; \
    docker-php-ext-install gd;
    # docker-php-source delete;
    # apt-get purge -y --auto-remove libjpeg-dev libpng-dev libwebp-dev libxpm-dev; \
    # apt-get install -yqq libjpeg62-turbo libpng16-16t64 libwebp7 libxpm4; \
    # rm -rf /var/lib/apt/lists/*;


RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libbz2-dev \
    ; \
    docker-php-ext-install bz2; \
    # docker-php-source delete;
    # apt-get purge -y --auto-remove libbz2-dev; \
    # apt-get install -yqq libbz2-1.0; \
    rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install bcmath; 
    # docker-php-source delete;

# RUN docker-php-ext-install mysqli; \
#     docker-php-source delete;

# RUN docker-php-ext-install exif; \
#     docker-php-source delete;

RUN docker-php-ext-install opcache; 
    # docker-php-source delete;

# RUN docker-php-ext-install sockets; \
    # docker-php-source delete;

RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
        libicu-dev g++ \
    ; \
    docker-php-ext-configure intl ; \
    docker-php-ext-install intl; \
    # docker-php-source delete;
    # apt-get purge -y --auto-remove libicu-dev g++; \
    # apt-get install -yqq libicu76; \
    rm -rf /var/lib/apt/lists/*;

# Install the xdebug extension
# https://xdebug.org/docs/compat
# https://pecl.php.net/package/xdebug
RUN if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
        pecl install xdebug-3.4.6; \
    elif [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
        pecl install xdebug-3.1.6; \
    fi; \
    docker-php-ext-enable xdebug; \
    rm -rf /tmp/pear;

RUN pecl install -o -f redis; \
    docker-php-ext-enable redis; \
    rm -rf /tmp/pear; 

RUN pecl install -o -f msgpack; \
    docker-php-ext-enable msgpack; \
    rm -rf /tmp/pear;

RUN pecl install apcu; \
    docker-php-ext-enable apcu; \
    rm -rf /tmp/pear;

# Install Composer
# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
#     php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
#     php -r "unlink('composer-setup.php');"
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Configure PHP settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Modify PHP-FPM configuration
RUN if [ -f /usr/local/etc/php-fpm.d/www.conf ]; then \
        sed -i -e "s/www-data/www/g" /usr/local/etc/php-fpm.d/www.conf; \
        sed -i -e "s/^listen *=.*/listen = 9000/g" \
        -e "s/^listen.allowed_clients *=.*/;listen.allowed_clients = 127.0.0.1/g" \
        -e "s/^;listen.owner *=.*/listen.owner = www-data/g" \
        -e "s/^;listen.group *=.*/listen.group = www-data/g" \
        -e "s/^;listen.mode *=.*/listen.mode = 0660/g" /usr/local/etc/php-fpm.d/www.conf; \
    fi

RUN if [ ! -f /usr/local/etc/php-fpm.d/www.conf ]; then \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            cron \
            sudo \
        ; \
        rm -rf /var/lib/apt/lists/*; \
        echo "www-data ALL=(ALL) NOPASSWD: /usr/sbin/cron" >> /etc/sudoers; \
    fi

# Install additional packages
# RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
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