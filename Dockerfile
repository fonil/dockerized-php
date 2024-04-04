# syntax=docker/dockerfile:1

# STAGE: BASE-IMAGE

FROM php:8.3.4-fpm-alpine AS base-image


# STAGE: COMMON

FROM base-image AS common

RUN apk update && apk add --no-cache \
    	fcgi

COPY --chmod=777 build/healthcheck.sh /healthcheck.sh
HEALTHCHECK \
    --interval=10s \
    --timeout=1s \
    --retries=3 \
    CMD /healthcheck.sh

WORKDIR /code


# STAGE: EXTENSIONS-BUILDER

FROM base-image AS extensions-builder

RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        zip


# STAGE: EXTENSIONS-SETUP

FROM base-image AS extensions-setup

COPY --from=extensions-builder /usr/local/lib/php/extensions/*/* /usr/local/lib/php/extensions/no-debug-non-zts-20230831/


# STAGE: BUILD-DEVELOPMENT

FROM common AS build-development

ARG HOST_USER_ID=1000
ARG HOST_USER_NAME=host-user-name

ARG HOST_GROUP_ID=1000
ARG HOST_GROUP_NAME=host-group-name

ENV ENV=DEVELOPMENT

RUN apk update && apk add --no-cache \
        bash \
        make \
        ncurses \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        pcov \
        uopz

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN addgroup --gid ${HOST_GROUP_ID} ${HOST_GROUP_NAME} \
    && adduser --shell /bin/bash --uid ${HOST_USER_ID} --ingroup ${HOST_GROUP_NAME} --ingroup www-data --disabled-password --gecos '' ${HOST_USER_NAME}

COPY build/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -r "s/USER-NAME/${HOST_USER_NAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/${HOST_GROUP_NAME}/g" /usr/local/etc/php-fpm.d/www.conf


# STAGE: OPTIMIZE-PHP-DEPENDENCIES

FROM composer as optimize-php-dependencies

COPY ./src/composer.json ./src/composer.lock /app/

RUN composer install \
    --ignore-platform-reqs \
    --no-ansi \
    --no-autoloader \
    --no-interaction \
    --no-scripts \
    --prefer-dist \
    --no-dev

# Just copy the PHP application folder without the ./src/vendor folder
COPY src/app /app/app
COPY src/public /app/public

RUN composer dump-autoload \
	--optimize \
	--classmap-authoritative


# STAGE: BUILD-PRODUCTION

FROM common AS build-production

ARG HOST_USER_ID=82
ARG HOST_USER_NAME=www-data

ARG HOST_GROUP_ID=82
ARG HOST_GROUP_NAME=www-data

ENV ENV=PRODUCTION

COPY --from=optimize-php-dependencies --chown=www-data:www-data /app /code

COPY build/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -r "s/USER-NAME/www-data/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/www-data/g" /usr/local/etc/php-fpm.d/www.conf
