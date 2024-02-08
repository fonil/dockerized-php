# syntax=docker/dockerfile:1

#-------------
# Installs the multi-stage common extensions
#-------------

FROM php:8.3.2-fpm-alpine3.19 AS extensions-builder

RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        zip

#-------------
# Creates a new stage with ONLY the compiled extensions
#-------------

FROM php:8.3.2-fpm-alpine3.19 AS base

COPY --from=extensions-builder /usr/local/lib/php/extensions/*/* /usr/local/lib/php/extensions/no-debug-non-zts-20230831/

WORKDIR /code

#-------------
# Optimizes the Application building process by caching the PHP dependencies
#-------------

FROM composer as optimize-dependencies

COPY ./src/composer.json ./src/composer.lock /app/

RUN composer install \
    --ignore-platform-reqs \
    --no-ansi \
    --no-autoloader \
    --no-interaction \
    --no-scripts \
    --prefer-dist \
    --no-dev
    
COPY ./src/ /app/

RUN composer dump-autoload \
	--optimize \
	--classmap-authoritative

#-------------
# Builds the PRODUCTION image
#-------------

FROM base AS build-production

ENV ENV=PRODUCTION

RUN apk update && apk add --no-cache \
    	bash \
    	fcgi \
    && mkdir /output \ 
    && chown www-data:www-data /output

COPY --from=optimize-dependencies --chown=www-data:www-data /app /code

COPY ./build/prod/usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY ./build/shared/usr/shared/healthchecks/php-fpm.sh /shared/usr/shared/healthchecks/php-fpm.sh

#-------------
# Builds the DEVELOPMENT image
#-------------

FROM base AS build-development

ARG HOST_USER_ID=1000
ARG HOST_USER_NAME=host-user-name

ARG HOST_GROUP_ID=1000
ARG HOST_GROUP_NAME=host-group-name

ENV ENV=DEVELOPMENT

RUN apk update && apk add --no-cache \
        bash \
        fcgi \
    && curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        pcov \
        uopz \
        xhprof

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN addgroup --gid ${HOST_GROUP_ID} ${HOST_GROUP_NAME} \
    && adduser --shell /bin/bash --uid ${HOST_USER_ID} --ingroup ${HOST_GROUP_NAME} --ingroup www-data --disabled-password --gecos '' ${HOST_USER_NAME}

COPY ./build/dev/usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -r "s/USER-NAME/${HOST_USER_NAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/${HOST_GROUP_NAME}/g" /usr/local/etc/php-fpm.d/www.conf
