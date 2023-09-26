# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 php:8.2.9-fpm-alpine3.18

#------------------------------------------------------------------------------
# DOCKER IMAGE CONTEXT
#------------------------------------------------------------------------------

LABEL Maintainer="Alcides Ramos <info@alcidesramos.com>"
LABEL Description="Photo book maker tool based on PHP8 and ImageMagick"

# Arguments

ARG CURRENT_UNAME=host-user
ARG CURRENT_GNAME=host-group
ARG CURRENT_UID=1000
ARG CURRENT_GID=$UID

# Default PHP user/group

ARG DEFAULT_UID=82
ARG DEFAULT_GID=82
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
# REPLICATE HOST USER & ASSIGN IT TO DEFAULT GROUP
#
# This way solves issues related with file permissions on internally created
# files
#------------------------------------------------------------------------------

RUN addgroup --gid $CURRENT_GID $CURRENT_GNAME && \
    adduser --shell /bin/bash --disabled-password --no-create-home --uid $CURRENT_UID --ingroup $DEFAULT_GNAME --ingroup $CURRENT_GNAME $CURRENT_UNAME

#USER $CURRENT_UNAME

#------------------------------------------------------------------------------
# COPY PHP-FPM CONFIG FILE
#
# By default PHP-FPM is running using replicated user & www-data group
#------------------------------------------------------------------------------

COPY ./usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN sed -i -r "s/USER-NAME/${CURRENT_UNAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/${DEFAULT_GNAME}/g" /usr/local/etc/php-fpm.d/www.conf

#------------------------------------------------------------------------------
# DEFINE WORKING DIRECTORY
#------------------------------------------------------------------------------

WORKDIR /code
