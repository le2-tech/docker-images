
ARG BASE_IMAGE
ARG BASE_IMAGE_TAG
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}

ARG DOCKER_ENV=prod

RUN set -eux; \
    apk update; \
    apk upgrade; \
    apk add --no-cache \
        build-base \
        autoconf \
        ;

RUN set -eux; \
    apk add --no-cache \
        tzdata \
        ; 
    # cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime ; \
    # echo "Asia/Tokyo" > /etc/timezone ;

RUN set -eux; \
    pecl channel-update pecl.php.net; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ] && [ $(php -r "echo PHP_MINOR_VERSION;") = "2" ]; then \
        apk add --no-cache libmcrypt-dev; \
        pecl install mcrypt; \
        docker-php-ext-enable mcrypt; \
    fi;

RUN if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ] && [ $(php -r "echo PHP_MINOR_VERSION;") = "2" ]; then \
        pecl install redis; \
        docker-php-ext-enable redis; \
    fi;

RUN if [ "${DOCKER_ENV}" = "dev" ]; then \
        if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ] && [ $(php -r "echo PHP_MINOR_VERSION;") = "0" ]; then \
            pecl install xdebug-2.8.1; \
        elif [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ] && [ $(php -r "echo PHP_MINOR_VERSION;") = "2" ]; then \
            pecl install xdebug-3.1.6; \
        fi; \
        docker-php-ext-enable xdebug; \
    fi

RUN apk add --no-cache \
        zip \
        zlib \
        zlib-dev; \
    docker-php-ext-install zip;

RUN docker-php-ext-install mysqli;

RUN docker-php-ext-install pdo_mysql;

# 配置 PHP
RUN { \
        echo "upload_max_filesize = 20M"; \
        echo "post_max_size = 20M"; \
    } | tee $PHP_INI_DIR/conf.d/php.ini; \
    if [ "${DOCKER_ENV}" = "dev" ]; then \
        { \
            echo "; xdebug3"; \
            echo "xdebug.mode= \"debug\""; \
            echo "xdebug.client_host=\"host.docker.internal\""; \
            echo "xdebug.client_port = \"900\""; \
        } | tee -a $PHP_INI_DIR/conf.d/php.ini; \
    fi