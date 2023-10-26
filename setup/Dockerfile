# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 php:8.2.9-fpm-alpine3.18 AS build

#------------------------------------------------------------------------------
# DOCKER IMAGE CONTEXT
#------------------------------------------------------------------------------

LABEL Maintainer="Alcides Ramos <info@alcidesramos.com>"
LABEL Description="Lightweight Docker development environment for PHP applications"

# Arguments

ARG CURRENT_UNAME=host-user
ARG CURRENT_GNAME=host-user-group
ARG CURRENT_UID=1000
ARG CURRENT_GID=$UID

# Default PHP user/group

ARG DEFAULT_UNAME=www-data
ARG DEFAULT_GNAME=www-data

#------------------------------------------------------------------------------
# INSTALL DEPENDENCIES
#------------------------------------------------------------------------------

RUN apk update && apk add --no-cache \
        bash \
        fcgi \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        @composer \
        pcov \
        uopz \
        zip

#------------------------------------------------------------------------------
# CREATE NON-ROOT USER
#------------------------------------------------------------------------------

RUN addgroup --gid ${CURRENT_GID} ${CURRENT_GNAME}  \
    && adduser --shell /bin/bash --uid ${CURRENT_UID} --ingroup ${CURRENT_GNAME} --ingroup ${DEFAULT_GNAME} --disabled-password --gecos '' ${CURRENT_UNAME}

#------------------------------------------------------------------------------
# SETUP PHP-FPM
#------------------------------------------------------------------------------

COPY ./usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN sed -i -r "s/USER-NAME/${CURRENT_UNAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/${DEFAULT_GNAME}/g" /usr/local/etc/php-fpm.d/www.conf

#------------------------------------------------------------------------------
# DEFINE WORKING DIRECTORY
#------------------------------------------------------------------------------

WORKDIR /code
