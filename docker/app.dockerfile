FROM php:7.2-fpm

RUN apt-get update && apt-get install -y libmcrypt-dev libgmp-dev \
    mysql-client unzip libmagickwand-dev --no-install-recommends \
    && pecl install imagick mcrypt-1.0.2;

RUN docker-php-ext-install pdo_mysql zip gmp; \
    docker-php-ext-enable mcrypt;

ENV WORKDIR=/var/www

WORKDIR $WORKDIR

RUN php -r "copy('https://getcomposer.org/composer.phar', 'composer.phar');"; \
    chmod +x ./composer.phar; \
    mv composer.phar /usr/local/bin/composer;

# Setup appuser and www-data users
RUN useradd appuser -d /home/appuser; \
    groupadd appuser; \
    mkdir /home/appuser; \
    chown -R appuser:appuser /home/appuser; \
    useradd www-data; \
    groupadd www-data; \
    usermod -a -G www-data appuser;

# Add app directory right permissions
RUN chown -R appuser:www-data ${WORKDIR}/; \
    find ./ -type d -exec chmod 755 {} \;; \
    find ./ -type f -exec chmod 644 {} \;;

# Install composer packages and copy app code as appuser
USER appuser

ADD ./composer.json ${WORKDIR}/

RUN composer install --no-autoloader

COPY ./ ${WORKDIR}/

# Set right permissions under some of the app code directories
USER root

RUN chgrp -R www-data storage bootstrap/cache; \
    chmod -R ug+rwx storage bootstrap/cache; \
    mkdir ./database/db; \
    touch ./database/db/database.sqlite; \
    chown -R appuser:appuser ./database/db; \
    chmod ug+rwx -R ./database/db;

# Autoload classes
USER appuser

RUN composer dump-autoload; \
    php artisan migrate --force; \
    echo "APP_KEY=" >> .env; \
    php artisan key:generate

CMD php artisan serve --host=0.0.0.0
