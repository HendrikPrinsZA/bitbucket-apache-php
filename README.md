[Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) [Docker](https://www.docker.com/) image based on [PHP's official image](https://hub.docker.com/_/php).

## Core
- [PHP](http://www.php.net/) `v7.4`
- [Apache](https://httpd.apache.org/) `v2.4`

## Build & compiler
- [Sencha CMD](http://docs.sencha.com/cmd/) `v7.3`
- [Node.js](https://nodejs.org/) `v14.15`
- [NPM](https://www.npmjs.com/) `v6.14`
- [Composer](https://getcomposer.org/) `v2.0`

## Other
- [Perl](https://www.perl.org/) `v5.28`

# Examples
There are multiple ways to use this image. As you're most likely going to use it to build your CI/CD, it's very handy to test locally.

## Example - Run container from local image
```SHELL
git clone git@github.com:HendrikPrinsZA/bitbucket-apache-php.git && cd bitbucket-apache-php
docker build . --tag bitbucket-apache-php-local
docker run -it --volume="/path/to/clevva:/var/www/html/clevva" --workdir="/var/www/html/clevva" --entrypoint=/bin/bash bitbucket-apache-php-local
```

## Example - Run container from remote image
```SHELL
docker run -it --volume="/path/to/clevva:/var/www/html/clevva" --workdir="/var/www/html/clevva" --entrypoint=/bin/bash hendrikprinsza/bitbucket-apache-php
```

## Example - Simulate [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) locally
You might want to simulate how your pipelines will be run remotely in Bitbucket's Pipelines.
```YAML
version: '3'

services:
    bitbucket-apache-php:
        image: bitbucket-pipelines-ubuntu-local
        container_name: bitbucket-apache-php
        ports:
            - 80:80
            - 443:443
        volumes:
            - /path/to/clevva:/var/www/html/clevva
        links:
            - bitbucket-mysql

    bitbucket-mysql:
        image: mariadb:10.2
        container_name: bitbucket-mysql
        ports:
            - 3306:3306
        environment:
            MYSQL_DATABASE: my_database
            MYSQL_ROOT_PASSWORD: my_root_pass
            MYSQL_USER: my_user
            MYSQL_PASSWORD: my_user_pass
```

## Example - [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines)
```YAML
pipelines:
  default:
    - step:
        image: hendrikprinsza/bitbucket-apache-php
        script:
          - phpunit --version
          - mysql -h127.0.0.1 -uroot -pmy_root_pass -e "SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';"
        services:
          - mysql

definitions:
  services:
    mysql:
      image: mariadb:10.2
      environment:
        MYSQL_DATABASE: my_database
        MYSQL_ROOT_PASSWORD: my_root_pass
```
