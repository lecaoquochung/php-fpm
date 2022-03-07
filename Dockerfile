# https://github.com/docker-library/php
FROM php:8.1.1-fpm

LABEL lehungio <me@lehungio.com>

# https://gist.github.com/lehungio/acc2bfc681349f678965a5d677168e88#file-dockerfile-L5
# SHELL ["/bin/bash", "-l", "-euxo", "pipefail", "-c"]
SHELL ["/bin/bash", "--login", "-c"]

RUN apt-get update; \
    apt-get full-upgrade -y; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# https://stackoverflow.com/a/25908200
RUN apt-get update && \
      apt-get -y install sudo

# Replace shell with bash so we can source files
# https://stackoverflow.com/questions/25899912/how-to-install-nvm-in-docker
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
# debconf: delaying package configuration, since apt-utils is not installed
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN pecl install redis \
    && pecl install xdebug \
    && docker-php-ext-enable redis xdebug

# Deprecated libpng12-dev
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpq-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libssl-dev \
    libssl-doc \
    libsasl2-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    zip \
    git

RUN apt-get install -y -q --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    python \
    rsync \
    software-properties-common \
    devscripts \
    autoconf \
    ssl-cert \
    && apt-get clean


# Deprecated mbstring, mcrypt, zip
RUN docker-php-ext-install bz2
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install soap

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# exif
RUN docker-php-ext-configure exif
RUN docker-php-ext-install exif
# RUN docker-php-ext-enable exif 
# warning: exif (exif.so) is already loaded!

# zip
RUN apt-get install -y libzip-dev zip && docker-php-ext-install zip

# intl
RUN docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-enable intl

# imagick
RUN pecl install imagick

# Node dependencies
# https://github.com/nodejs/Release
# Fix node -v command not found
# https://gist.github.com/remarkablemark/aacf14c29b3f01d6900d13137b21db3a
# https://gist.github.com/remarkablemark/aacf14c29b3f01d6900d13137b21db3a#gistcomment-3067813
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16.13.2

RUN mkdir -p "$NVM_DIR"; \
    curl -o- \
        "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh" | \
        bash \
    ; \
    source $NVM_DIR/nvm.sh; \
    nvm install --lts --latest-npm

# TODO This loads nvm
# this command can not load properly when build, but  can run directly in ssh
# RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
# https://stackoverflow.com/questions/25899912/how-to-install-nvm-in-docker

# update the repository sources list
# and install dependencies
# https://github.com/nodesource/distributions/blob/master/deb/src/_setup.sh#L114
# RUN curl -sL https://deb.nodesource.com/setup_17.x | bash -
# RUN apt-get install -y nodejs npm
RUN npm install yarn -g

# mysql dependencies
RUN apt-get update && apt-get install -y \
    vim \
    default-mysql-client \
    netcat

# ENV
# /usr/local/nvm/versions/node/v16.13.1/bin/node
# /usr/local/nvm/versions/node/v16.13.1/lib/node_modules/
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Summary installation
# 01. PHP
RUN php -r "phpinfo();"
RUN php --ini
RUN php --version

RUN uname -a
RUN whoami
RUN pwd

# https://stackoverflow.com/questions/55206227/why-bashrc-is-not-executed-when-run-docker-container
# CMD source ~/.bashrc
# 02. NVM / Node / Yarn
RUN nvm --version
RUN node -v
RUN npm -v
RUN yarn -v

# 03. MYSQL CLIENT
RUN mysql --version

# Disk usage
RUN df -h