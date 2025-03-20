
ARG BASE_IMAGE
ARG BASE_IMAGE_TAG
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}

# ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update; \
    # apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
        curl \
        # libz-dev \
        # libpq-dev \
        # libjpeg-dev \
        # libpng-dev \
        # libfreetype6-dev \
        libssl-dev \
        # libwebp-dev \
        # libxpm-dev \
        # libmcrypt-dev \
        # libonig-dev; \
        procps \
        # wget \
        vim \
        jq \
        iputils-ping \
        # zlib1g-dev \
        # mariadb-client \
        net-tools \
        poppler-utils \
        apt-utils \
        gnupg2 \
        git \
    ; \
    rm -rf /var/lib/apt/lists/*

# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    # apt-get update -yqq; \
    # pecl channel-update pecl.php.net; \
    apt-get update; \
    apt-get install -yqq \
        libzip-dev zlib1g-dev libz-dev zip unzip \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    #   if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
    #     docker-php-ext-configure zip; \
    #   else \
    #     docker-php-ext-configure zip --with-libzip; \
    #   fi; \
    # Install the zip extension
    docker-php-ext-install zip; \
    php -m | grep -q 'zip'

RUN set -eux; \
    apt-get update; \
    apt-get install -yqq \
        libpq-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    # Install the PHP pdo_mysql extention
    docker-php-ext-install pdo_mysql; \
    # Install the PHP pdo_pgsql extention
    docker-php-ext-install pdo_pgsql; 

# Install the PHP gd library
RUN set -eux; \
    apt-get update; \
    apt-get install -yqq \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libwebp-dev \
        libxpm-dev \
        libz-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure gd \
    --prefix=/usr \
    --with-jpeg \
    --with-webp \
    --with-xpm \
    --with-freetype; \
    docker-php-ext-install gd; \
    php -r 'var_dump(gd_info());'


RUN set -eux; \
    apt-get update; \
    apt-get -yqq install \
        libbz2-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-install bz2;

RUN docker-php-ext-install bcmath;

RUN docker-php-ext-install mysqli;

RUN docker-php-ext-install exif; 

RUN docker-php-ext-install opcache;

RUN docker-php-ext-install sockets;

RUN set -eux; \
    apt-get update; \
    apt-get install -yqq \
        libicu-dev zlib1g-dev g++ \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure intl ; \
    docker-php-ext-install intl;

# Install the xdebug extension
# https://xdebug.org/docs/compat
# https://pecl.php.net/package/xdebug
RUN if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
        pecl install xdebug-3.4.2; \
    elif [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
        pecl install xdebug-3.1.6; \
    fi; \
    docker-php-ext-enable xdebug;

RUN pecl install -o -f redis; \
    rm -rf /tmp/pear; \
    docker-php-ext-enable redis;

RUN pecl install -o -f msgpack; \
    rm -rf /tmp/pear; \
    docker-php-ext-enable msgpack;

RUN pecl install apcu; \
    docker-php-ext-enable apcu;

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    php -r "unlink('composer-setup.php');"

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
        set -eux;\
        apt-get update; \
        apt-get -y install --no-install-recommends \
            cron \
            sudo \
        ; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists/*; \
        echo "www-data ALL=(ALL) NOPASSWD: /usr/sbin/cron" >> /etc/sudoers; \
    fi

# Set working directory
WORKDIR /www