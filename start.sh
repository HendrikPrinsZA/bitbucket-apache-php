#!/bin/bash

# PHP configuration
echo "VERSION_PHP: ${VERSION_PHP}"
/bin/sed -i "s/\;date\.timezone\ \=/date\.timezone\ \=\ ${DATE_TIMEZONE}/" /etc/php/${VERSION_PHP}/apache2/php.ini 2>/dev/null
/bin/sed -i "s/short_open_tag\ \=\ Off/short_open_tag\ \=\ On/g" /etc/php/${VERSION_PHP}/apache2/php.ini 2>/dev/null

&>/dev/null /usr/sbin/apachectl -DFOREGROUND -k start
