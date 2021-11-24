#FROM composer:2
#
#WORKDIR /var/www/html

FROM composer:2

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup --gid ${GID} --system laravel
RUN adduser --ingroup laravel --system --disabled-password --shell /bin/bash --uid ${UID} laravel

WORKDIR /var/www/html