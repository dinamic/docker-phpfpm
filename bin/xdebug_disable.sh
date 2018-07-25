#!/bin/sh

echo "Disabling XDebug..";

rm -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
