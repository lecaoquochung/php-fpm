FROM php:7.4-fpm

LABEL lehungio <me@lehungio.com>

# Replace shell with bash so we can source files
# https://stackoverflow.com/questions/25899912/how-to-install-nvm-in-docker
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

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
# TODO debconf: delaying package configuration, since apt-utils is not installed

# imagick
RUN pecl install imagick

# Install intl extension
RUN docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-enable intl

# Node dependencies
# https://github.com/nodejs/Release
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 12
# Instal nvm, node, yarn
# https://github.com/nvm-sh/nvm
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
#     && export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" \
#     && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
#     && nvm install $NODE_VERSION \
#     && nvm alias default $NODE_VERSION \
#     && nvm use default \
#     && npm install yarn -g

# ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
# ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# install node and npm

## nvm
# https://gist.github.com/remarkablemark/aacf14c29b3f01d6900d13137b21db3a#file-dockerfile
# RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash
# RUN source $NVM_DIR/nvm.sh \
#     && nvm install $NODE_VERSION \
#     && nvm alias default $NODE_VERSION \
#     && nvm use default \
#     && npm install yarn -g 
# # add node and npm to path so the commands are available
# ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
# ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# TODO This loads nvm
# this command can not load properly when build, but  can run directly in ssh
# RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
# https://stackoverflow.com/questions/25899912/how-to-install-nvm-in-docker

# update the repository sources list
# and install dependencies
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install -y nodejs npm
RUN npm install yarn -g

# mysql dependencies
RUN apt-get update && apt-get install -y \
    vim \
    default-mysql-client \
    netcat

# Summary installation
# 01. PHP
RUN php -r "phpinfo();"
RUN php --ini
RUN php --version

RUN uname -a

# RUN source ~/.bashrc
# 02. NVM / Node / Yarn
# RUN nvm --version
# RUN command -v nvm
# RUN nvm ls-remote
# RUN nvm list
RUN node -v
RUN npm -v
RUN yarn -v

# 03. MYSQL CLIENT
RUN mysql --version

# Disk usage
RUN df -h
