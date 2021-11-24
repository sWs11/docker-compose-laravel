#FROM nginx:1.21.3
#
#ADD nginx/default.conf /etc/nginx/conf.d/
#
#RUN userdel -f www-data &&\
#    if getent group www-data ; then groupdel www-data; fi &&\
#    groupadd -g 1000 www-data &&\
#    useradd -l -u 1000 -g www-data www-data &&\
#    install -d -m 0755 -o www-data -g www-data /home/www-data
#
#WORKDIR /var/www/html

FROM nginx:1.20.2

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup --gid ${GID} --system laravel
RUN adduser --ingroup laravel --system --disabled-password --shell /bin/bash --uid ${UID} laravel
RUN sed -i "s/user  nginx/user laravel/g" /etc/nginx/nginx.conf

ADD ./dockerfiles/nginx/default.conf /etc/nginx/conf.d/

RUN mkdir -p /var/www/html