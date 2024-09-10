
ARG BASE_IMAGE
ARG BASE_IMAGE_TAG
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}

# Set Environment Variables
ENV DEBIAN_FRONTEND=noninteractive

ARG DOCKER_ENV=prod

RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
            curl \
            libmemcached-dev \
            libz-dev \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
            libfreetype6-dev \
            libssl-dev \
            libwebp-dev \
            libxpm-dev \
            libmcrypt-dev \
            libonig-dev; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    # Install the PHP pdo_mysql extention
    docker-php-ext-install pdo_mysql; \
    # Install the PHP pdo_pgsql extention
    docker-php-ext-install pdo_pgsql; \
    # Install the PHP gd library
    docker-php-ext-configure gd \
            --prefix=/usr \
            --with-jpeg \
            --with-webp \
            --with-xpm \
            --with-freetype; \
    docker-php-ext-install gd; \
    php -r 'var_dump(gd_info());'


# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq; \
    pecl channel-update pecl.php.net; \
    apt-get install -yqq \
      apt-utils \
      gnupg2 \
      git \
      libzip-dev zip unzip; \
    #   if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
    #     docker-php-ext-configure zip; \
    #   else \
    #     docker-php-ext-configure zip --with-libzip; \
    #   fi; \
      # Install the zip extension
      docker-php-ext-install zip; \
      php -m | grep -q 'zip'

ARG INSTALL_BZ2=true

RUN if [ ${INSTALL_BZ2} = true ]; then \
        apt-get -yqq install libbz2-dev; \
        docker-php-ext-install bz2; \
    fi

ARG INSTALL_BCMATH=true

RUN if [ ${INSTALL_BCMATH} = true ]; then \
        docker-php-ext-install bcmath; \
    fi

ARG INSTALL_MYSQLI=true

RUN if [ ${INSTALL_MYSQLI} = true ]; then \
        docker-php-ext-install mysqli; \
    fi

ARG INSTALL_EXIF=true

RUN if [ ${INSTALL_EXIF} = true ]; then \
        docker-php-ext-install exif; \
    fi

ARG INSTALL_OPCACHE=true

RUN if [ ${INSTALL_OPCACHE} = true ] && [ "${DOCKER_ENV}" = "prod" ]; then \
        docker-php-ext-install opcache; \
    fi

ARG INSTALL_SOCKETS=true

RUN if [ ${INSTALL_SOCKETS} = true ]; then \
        docker-php-ext-install sockets; \
    fi

ARG INSTALL_INTL=true

RUN if [ ${INSTALL_INTL} = true ]; then \
        apt-get install -yqq zlib1g-dev libicu-dev g++; \
        docker-php-ext-configure intl ; \
        docker-php-ext-install intl; \
    fi


ARG INSTALL_XDEBUG=true

RUN if [ ${INSTALL_XDEBUG} = true ] && [ "${DOCKER_ENV}" = "dev" ]; then \
        # Install the xdebug extension
        # https://xdebug.org/docs/compat
        # https://pecl.php.net/package/xdebug
        if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
                pecl install xdebug-3.3.2; \
            elif [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
                pecl install xdebug-3.1.6; \
            fi; \
        docker-php-ext-enable xdebug; \
    fi

ARG INSTALL_PHPREDIS=true

RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
        pecl install -o -f redis; \
        rm -rf /tmp/pear; \
        docker-php-ext-enable redis; \
    fi

ARG INSTALL_PHPMSGPACK=true

RUN if [ ${INSTALL_PHPMSGPACK} = true ]; then \
        pecl install -o -f msgpack; \
        rm -rf /tmp/pear; \
        docker-php-ext-enable msgpack; \
    fi

ARG INSTALL_APCU=true

RUN if [ ${INSTALL_APCU} = true ]; then \
        pecl install apcu; \
        docker-php-ext-enable apcu; \
    fi

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    php -r "unlink('composer-setup.php');"

# Configure PHP settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Copy custom PHP configuration
COPY config/ /tmp/

RUN if [ "$DOCKER_ENV" = "dev" ]; then \
        mv /tmp/php.ini-dev $PHP_INI_DIR/conf.d/php.ini; \
    else \
        mv /tmp/php.ini-prod $PHP_INI_DIR/conf.d/php.ini; \
    fi

# Modify PHP-FPM configuration
RUN if [ -f /usr/local/etc/php-fpm.d/www.conf ]; then \
        sed -i -e "s/www-data/www/g" /usr/local/etc/php-fpm.d/www.conf; \
        sed -i -e "s/^listen *=.*/listen = 9000/g" \
            -e "s/^listen.allowed_clients *=.*/;listen.allowed_clients = 127.0.0.1/g" \
            -e "s/^;listen.owner *=.*/listen.owner = www-data/g" \
            -e "s/^;listen.group *=.*/listen.group = www-data/g" \
            -e "s/^;listen.mode *=.*/listen.mode = 0660/g" /usr/local/etc/php-fpm.d/www.conf; \
    fi

# Set user and group IDs if provided as build arguments
ARG USER_ID=1000
ARG GROUP_ID=1000

# Modify www-data user and group IDs, create directories, and set permissions
RUN groupmod -o -g ${GROUP_ID} www-data ; \
    usermod -o -u ${USER_ID} -g www-data www-data ; \
    mkdir -p /home/www-data /www /var/www ; \
    chown -R www-data:www-data /home/www-data /www /var/www

# Install system dependencies and clean up
RUN set -eux; \
    apt-get update -y ; \
    apt-get install -y --no-install-recommends \
        procps \
        wget \
        vim \
        jq \ 
        iputils-ping \
        zlib1g-dev \
        mariadb-client \
        net-tools \
        ; \
    rm -rf /var/lib/apt/lists/*


# Set user and working directory
USER www-data
WORKDIR /www

# Expose PHP-FPM port
EXPOSE 9000
