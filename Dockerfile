FROM php:7.4-fpm-alpine
RUN apk update

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS openssl \
    bash-doc bash-completion postgresql-dev zlib-dev php-phpdbg \
    libzip-dev libpng-dev jpegoptim optipng pngquant gifsicle nginx \
    libpng libpng-dev sqlite-dev sqlite mysql mysql-client php7-phpdbg git openssh

RUN adduser -D -g 'www' www
RUN docker-php-ext-install pdo \
    pdo_pgsql \
    pdo_mysql \
    sockets \
    gd \
    zip \
    pdo_sqlite

RUN pecl install pcov && docker-php-ext-enable pcov
WORKDIR /var/www
RUN ls -la

RUN rm -rf /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo "max_file_uploads=100" >> /usr/local/etc/php/conf.d/docker-php-ext-max_file_uploads.ini
RUN echo "post_max_size=120M" >> /usr/local/etc/php/conf.d/docker-php-ext-post_max_size.ini
RUN echo "upload_max_filesize=120M" >> /usr/local/etc/php/conf.d/docker-php-ext-upload_max_filesize.ini

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN ln -s public html

EXPOSE 9000