# syntax=docker/dockerfile:experimental

# Stage 1 (composer as builder)
FROM php:8.2-fpm-alpine as builder

RUN apk --update add \
    curl \
    git \
    openssh-client

COPY composer.json /var/www/html/composer.json
COPY composer.lock /var/www/html/composer.lock
COPY database /var/www/html/database
COPY bootstrap /var/www/html/bootstrap

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN cd /var/www/html \
    && composer install --no-interaction --prefer-dist --ignore-platform-reqs --no-scripts

# Stage 2
FROM php:8.2-fpm-alpine as final

RUN apk --update add \
    bash \
    make \
    autoconf \
    libc6-compat \
    gcompat \
    g++ \
    shadow \
    mariadb-connector-c-dev \
    linux-headers \     
    && wget https://github.com/FriendsOfPHP/pickle/releases/latest/download/pickle.phar \
    && chmod +x pickle.phar \
    && mv pickle.phar pickle \
    && ./pickle install redis@5.3.7 \
    && docker-php-ext-enable redis \
    && docker-php-ext-install pdo_mysql mysqli opcache sockets bcmath pcntl \
    && apk del make autoconf g++ linux-headers \           
    && apk del make autoconf g++ \
    && rm -rf /var/cache/apk/* /var/lib/apt/lists/* /tmp/* \
    && rm pickle

WORKDIR /var/www/html

# config FPM and PHP.ini
COPY ./docker/app/php.ini $PHP_INI_DIR/php.ini
COPY ./docker/app/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/config/ssh.sh /usr/local/bin/

# create group and user app
RUN addgroup -g 1001 app && \
    adduser -u 1000 -G app -s /bin/bash -D app

# copy vendor from composer build & entrypoint 
COPY --from=builder /var/www/html /var/www/html
COPY docker/app/entrypoint.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start

# copy proejct
COPY --chown=app:app . .

# create cache directory and setup permission
RUN mkdir -p \
    /var/www/html/storage/framework/cache \
    /var/www/html/storage/framework/testing \
    /var/www/html/storage/framework/sessions \
    /var/www/html/storage/framework/views \
    && chmod -R 755 /var/www/html/storage \
    /var/www/html/bootstrap

# entrypoint
CMD ["/usr/local/bin/start"]