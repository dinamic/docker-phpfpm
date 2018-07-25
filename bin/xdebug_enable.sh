#!/bin/sh

echo "Enabling XDebug..";

docker-php-ext-enable xdebug

echo "xdebug.remote_enable=on" | tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo "xdebug.remote_autostart=off" | tee -a /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
