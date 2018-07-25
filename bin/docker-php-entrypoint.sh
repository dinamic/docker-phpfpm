#!/bin/sh
set -e

if [ ! -z "$XDEBUG_CONFIG" ]; then
  xdebug_enable.sh
else
  xdebug_disable.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"