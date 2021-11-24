#FROM php:8.0-fpm-alpine
#
#RUN pecl install xdebug-3.1.1 && docker-php-ext-enable xdebug
#
#RUN userdel -f www-data &&\
#    if getent group www-data ; then groupdel www-data; fi &&\
#    groupadd -g 1000 www-data &&\
#    useradd -l -u 1000 -g www-data www-data &&\
#    install -d -m 0755 -o www-data -g www-data /home/www-data
#
#RUN mkdir -p /var/www/html
#
#WORKDIR /var/www/html
#
#RUN docker-php-ext-install pdo pdo_mysql
#
#CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]

FROM php:8.0-fpm

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN pecl install xdebug-3.1.1 && docker-php-ext-enable xdebug

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup --gid ${GID} --system laravel
RUN adduser --ingroup laravel --system --disabled-password --shell /bin/bash --uid ${UID} laravel

RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-install pdo pdo_mysql

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
