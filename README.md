[Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) [Docker](https://www.docker.com/) image based on [Ubuntu](https://hub.docker.com/_/ubuntu/).

## Packages installed
- [Node.js](https://nodejs.org/) `8.11`
- [NPM](https://www.npmjs.com/) `5.6`
  - [Gulp](http://gulpjs.com/), [Webpack](https://webpack.github.io/), [Mocha](https://mochajs.org/), [Grunt](http://gruntjs.com/), [Codeception](https://codeception.com/), [Yarn](https://yarnpkg.com/)
- [Perl](https://www.perl.org/) `5.22`
- [PHP](http://www.php.net/) `7.2`
  - `bcmath`,`bz2`,`cgi`,`cli`,`common`,`curl`,`dev`,`enchant`,`fpm`,`gd`,`gmp`,`imap`,`interbase`,`intl`,`json`,`ldap`,`mbstring`,`mysql`,`odbc`,`opcache`,`pgsql`,`phpdbg`,`pspell`,`readline`,`snmp`,`sqlite3`,`sybase`,`tidy`,`xmlrpc`,`xsl`,`zip`,`xdebug`
- [PHPUnit](https://phpunit.de/) `5.7.27`
- [Python](https://www.python.org/) `2.7`
- [Ruby](https://www.ruby-lang.org/) `2.3`
- [Sencha CMD](http://docs.sencha.com/cmd/) `6.5.3.6`
- [Composer](https://getcomposer.org/) `1.6.5`,
- Other
  - `apt-transport-https`, `bzip2`, `ca-certificates`, `clean-css-cli`, `curl`, `gettext`, `git`, `imagemagick`, `memcached`, `mysql-client`, `openjdk-7-jre`, `openssh-client`, `perl`, `python`, `python3`, `rsync`, `ruby`, `software-properties-common`, `subversion`, `unzip`, `uglify-js`, `wget`, `zip`

## Example - Build the image locally
```SHELL
git clone git@github.com:HendrikPrinsZA/bitbucket-apache-php.git && cd bitbucket-apache-php
docker build . --tag bitbucket-apache-php-local
docker run -it --volume=/var/www/html/project:/project --workdir="/project" --entrypoint=/bin/bash bitbucket-apache-php-local
```

## Example - Remote image
```SHELL
docker run -it --volume=/var/www/html/project:/project --workdir="/project" --entrypoint=/bin/bash hendrikprinsza/bitbucket-apache-php
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
            - /var/www/html:/var/www/html
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
