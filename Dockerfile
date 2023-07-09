# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 php:8.2.7-fpm-alpine3.18

# Docker image context

LABEL Maintainer="Alcides Ramos <info@alcidesramos.com>"
LABEL Description="Lightweight PHP8-FPM environment"

# Install dependencies

RUN apk update && apk add --no-cache \
        bash \
        fcgi \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        @composer \
        pcov \
        uopz \
        zip

# Define the working directory

WORKDIR /code
