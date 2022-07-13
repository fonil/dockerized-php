# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 php:8.1.8-fpm-buster

WORKDIR /code

# Install dependencies via <apt>

RUN apt update && apt upgrade -y && apt install -y --fix-missing \
        zip \
        unzip \
        zlib1g-dev \
        libzip-dev \
    && pecl install pcov \
    && docker-php-ext-install zip \
    && docker-php-ext-enable pcov

# Install cgi-fcgi via <apt-get>

RUN apt-get update && apt-get install -y \
        libfcgi0ldbl

# Install Composer

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
