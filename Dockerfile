# syntax=docker/dockerfile:1

#----------------------------------------------------------
# STAGE: BASE-IMAGE
#----------------------------------------------------------

FROM php:8.3.12-fpm-alpine AS base-image

#----------------------------------------------------------
# STAGE: COMMON
#----------------------------------------------------------

FROM base-image AS common

# Add OS dependencies
RUN apk update && apk add --no-cache \
        fcgi \
        libzip

# Add a custom HEALTHCHECK script
# Ensure the `healthcheck.sh` can be executed inside the container
COPY --chmod=777 build/healthcheck.sh /healthcheck.sh
HEALTHCHECK --interval=30s --timeout=1s --retries=3 --start-period=10s --start-interval=2s CMD /healthcheck.sh

WORKDIR /var/www/html

#----------------------------------------------------------
# STAGE: EXTENSIONS-BUILDER-COMMON
#----------------------------------------------------------

FROM base-image AS extensions-builder-common

# Add, compile and configure PHP extensions
RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        zip

#----------------------------------------------------------
# STAGE: EXTENSIONS-BUILDER-DEV
#----------------------------------------------------------

FROM extensions-builder-common AS extensions-builder-dev

# Add, compile and configure PHP extensions
RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
        pcov \
        uopz \
        xdebug

#----------------------------------------------------------
# STAGE: BUILD-DEVELOPMENT
#----------------------------------------------------------

FROM common AS build-development

ARG HOST_USER_ID=1000
ARG HOST_USER_NAME=host-username
ARG HOST_GROUP_ID=1000
ARG HOST_GROUP_NAME=host-groupname

ENV ENV=DEVELOPMENT

# Add custom user to www-data group
RUN addgroup --gid ${HOST_GROUP_ID} ${HOST_GROUP_NAME} \
    && adduser --shell /bin/bash --uid ${HOST_USER_ID} --ingroup ${HOST_GROUP_NAME} --ingroup www-data --disabled-password --gecos '' ${HOST_USER_NAME}

# Empty working dir and make it writtable by current user
RUN chown -Rf ${HOST_USER_NAME}:${HOST_GROUP_NAME} /var/www/html \
    && find /var/www/html -type f -delete \
    && rm -Rf /var/www/html/*

# Add __ONLY__ compiled extensions & their config files
COPY --from=extensions-builder-dev /usr/local/lib/php/extensions/*/* /usr/local/lib/php/extensions/no-debug-non-zts-20230831/
COPY --from=extensions-builder-dev /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/

# Add Composer from public Docker image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Add OS dependencies related with development
RUN apk update && apk add --no-cache \
        git \
        make \
        ncurses \
        util-linux

# Setup PHP-FPM
COPY build/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -r "s/USER-NAME/${HOST_USER_NAME}/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/${HOST_GROUP_NAME}/g" /usr/local/etc/php-fpm.d/www.conf

# Setup xDebug
COPY build/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN touch /var/log/xdebug.log \
    && chown ${HOST_USER_NAME}:${HOST_GROUP_NAME} /var/log/xdebug.log

#----------------------------------------------------------
# STAGE: OPTIMIZE-PHP-DEPENDENCIES
#----------------------------------------------------------

FROM composer AS optimize-php-dependencies

# First copy Composer files
COPY ./src/composer.json ./src/composer.lock /app/

# Docker will cache this step and reuse it if no any change has being done on previuos step
RUN composer install \
    --ignore-platform-reqs \
    --no-ansi \
    --no-autoloader \
    --no-interaction \
    --no-scripts \
    --prefer-dist \
    --no-dev

# Ensure to copy __ONLY__ the PHP application folder(s)
# Ensure to omit the `./src/vendor` folder and avoid to install development dependencies into the optimized folder
COPY src/app /app/app
COPY src/public /app/public

# Recompile application cache
RUN composer dump-autoload \
    --optimize \
    --classmap-authoritative

#----------------------------------------------------------
# STAGE: BUILD-PRODUCTION
#----------------------------------------------------------

FROM common AS build-production

ENV ENV=PRODUCTION

# Setup the FPM service name and port
RUN sed -i -r "s/LISTEN/${LISTEN}/g" /healthcheck.sh

# Add __ONLY__ compiled extensions & their config files
COPY --from=extensions-builder-common /usr/local/lib/php/extensions/*/* /usr/local/lib/php/extensions/no-debug-non-zts-20230831/
COPY --from=extensions-builder-common /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/

# Add the optimized for production application
COPY --from=optimize-php-dependencies --chown=www-data:www-data /app /var/www/html

# Setup PHP-FPM
COPY build/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i -r "s/USER-NAME/www-data/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i -r "s/GROUP-NAME/www-data/g" /usr/local/etc/php-fpm.d/www.conf
