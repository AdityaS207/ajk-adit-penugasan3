FROM php:8.1-fpm-alpine

RUN apk update && apk --no-cache add\
    git\
    curl\
    libzip-dev\
    libxml2-dev\
    zip\
    unzip\
    yarn \
    && apk cache clean && rm -rf var/lib/apt/lists/*

WORKDIR /var/www/html

COPY . /var/www/html

RUN docker-php-ext-install pdo pdo_mysql \
    && apk --no-cache add nodejs npm

RUN yarn

RUN yarn build

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data \
    /var/www/html \
    /var/www/html/bootstrap/cache

RUN chmod -R 775 \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache
    
RUN composer install

RUN php artisan key:generate

