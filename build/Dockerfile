# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 php:8.3.0-fpm-alpine3.18 AS base

LABEL Maintainer="Alcides Ramos <info@alcidesramos.com>"
LABEL Description="Lightweight Docker development environment for PHP applications"

ARG CURRENT_UNAME=host-user
ARG CURRENT_GNAME=host-user-group
ARG CURRENT_UID=1000
ARG CURRENT_GID=$UID

ARG DEFAULT_UNAME=www-data
ARG DEFAULT_GNAME=www-data

RUN apk update && apk add --no-cache \
        bash \
        fcgi \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        zip

RUN addgroup --gid ${CURRENT_GID} ${CURRENT_GNAME}  \
    && adduser --shell /bin/bash --uid ${CURRENT_UID} --ingroup ${CURRENT_GNAME} --ingroup ${DEFAULT_GNAME} --disabled-password --gecos '' ${CURRENT_UNAME}

COPY ./usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -r "s/USER-NAME/${CURRENT_UNAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/${DEFAULT_GNAME}/g" /usr/local/etc/php-fpm.d/www.conf

WORKDIR /code


FROM base as development

RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        xhprof \
        pcov \
        uopz

COPY --from=composer /usr/bin/composer /usr/bin/composer


FROM base as production
