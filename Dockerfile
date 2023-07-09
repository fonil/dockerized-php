# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 php:8.2.7-fpm-alpine3.18

# Docker image context

LABEL Maintainer="Alcides Ramos <info@alcidesramos.com>"
LABEL Description="Lightweight PHP8-FPM development environment"

# Arguments

ARG UNAME=host-user
ARG GNAME=host-group
ARG UID=1000
ARG GID=$UID

# Install dependencies

RUN apk update && apk add --no-cache \
        bash \
        fcgi \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        @composer \
        pcov \
        uopz \
        zip

# Create user and group

RUN addgroup --gid $GID $GNAME \
    && adduser --shell /bin/bash --disabled-password --no-create-home --uid $UID --ingroup $GNAME $UNAME

#USER $UNAME

# Copy PHP-FPM config file

COPY ./usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN sed -i -r "s/USER-NAME/${UNAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/${GNAME}/g" /usr/local/etc/php-fpm.d/www.conf

# Define the working directory

WORKDIR /code
