#!/bin/bash

# PHP configs
# /bin/sed -i "s/short_open_tag\ \=\ Off/short_open_tag\ \=\ On/g" /etc/php/7.4/apache2/php.ini

&>/dev/null /usr/sbin/apachectl -DFOREGROUND -k start
