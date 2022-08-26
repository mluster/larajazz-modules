ARG VERSION=8.0
FROM php:${VERSION}-fpm-alpine

ARG VERSION=8.0

RUN apk update && \
    apk add g++ make autoconf && \
    pecl channel-update pecl.php.net

RUN docker-php-ext-install \
        bcmath \
        ctype \
        exif \
        fileinfo

### XDEBUG #####################################################################
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug
COPY docker/xdebug.ini /usr/local/etc/php/conf.d/99-xdebug.ini

RUN apk del g++ make autoconf && \
    rm /var/cache/apk/*

RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

COPY docker/local.ini /usr/local/etc/php/conf.d/

RUN chmod -R 755 /var/www

ARG WORKDIR=/var/www
WORKDIR ${WORKDIR}
CMD ["php-fpm"]
EXPOSE 9000
