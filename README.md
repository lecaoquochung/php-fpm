# image: lehungio/php-fpm:latest
Docker image for [PHP-FPM](https://php-fpm.org/).

[![Build Status](https://travis-ci.org/lehungio/php-fpm.svg?branch=master)](https://travis-ci.org/lehungio/php-fpm) [![Automated Build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/lehungio/php-fpm/builds/)

## Supported branches and respective Dockerfile links
 - [latest](https://github.com/lehungio/php-fpm/blob/master/Dockerfile)
 - [8.1.1](https://github.com/lehungio/php-fpm/blob/8.1.1/Dockerfile)
 - [7.4](https://github.com/lehungio/php-fpm/7.4/Dockerfile)
 - [7.1](https://github.com/lehungio/php-fpm/blob/7.1/Dockerfile)
 - [5.6](https://github.com/lehungio/php-fpm/blob/5.6/Dockerfile)

## What is PHP-FPM ?
PHP-FPM (FastCGI Process Manager) is an alternative FastCGI implementation for PHP.

## Getting image
```sh
sudo docker pull lehungio/php-fpm
```

## Basic usage

```sh
sudo docker run -v /path/to/your/app:/var/www/html -d lehungio/php-fpm
```

## Running your PHP script

### Running image
Run the PHP-FPM image, mounting a directory from your host.

```sh
sudo docker run -it --name phpfpm -v /path/to/your/app:/var/www/html lehungio/php-fpm php index.php
```

or using [Docker Compose](https://docs.docker.com/compose/):

### Running as server

```sh
sudo docker run --rm --name phpfpm -v /path/to/your/app:/var/www/html -p 8000:8000 lehungio/php php-fpm -S="0.0.0.0:8000" -t="/var/www/html"
```

### Logging
```sh
sudo docker logs phpfpm
```
or using [Docker Compose](https://docs.docker.com/compose/) :
```sh
sudo docker-compose logs phpfpm
```

## Installed extensions
 - bz2
 - Core
 - ctype
 - curl
 - date
 - dom
 - ereg
 - fileinfo
 - filter
 - ftp
 - gd
 - hash
 - iconv
 - imagick
 - intl
 - json
 - libxml
 - mbstring
 - mcrypt
 - mongodb
 - mysqli
 - mysqlnd
 - openssl
 - pcre
 - PDO
 - pdo_mysql
 - pdo_pgsql
 - pdo_sqlite
 - pgsql
 - Phar
 - posix
 - readline
 - redis
 - Reflection
 - session
 - SimpleXML
 - soap
 - SPL
 - sqlite3
 - standard
 - tokenizer
 - xdebug
 - xml
 - xmlreader
 - xmlwriter
 - zip
 - zlib
