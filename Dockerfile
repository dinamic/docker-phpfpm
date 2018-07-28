FROM dinamic/php-unix-socket:7.2

COPY ext/opcache.ini /usr/local/etc/php/conf.d/
COPY php.ini /usr/local/etc/php
COPY bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

RUN docker-php-source extract && \
	apk add --no-cache --update --virtual .build-dependencies binutils build-base autoconf libzip-dev libpng-dev gmp-dev openssl-dev curl-dev icu-dev openssh-client tree git && \
	cd /usr/src && \
	curl -L https://github.com/redis/hiredis/archive/v0.13.3.tar.gz --output hiredis.tar.gz && tar fxz hiredis.tar.gz && \
	cd hiredis-0.13.3 && \
	make -j4 && make install && \
	cd .. && \
	curl -L https://github.com/nrk/phpiredis/archive/v1.0.0.tar.gz --output phpiredis-1.0.0.tar.gz && tar fxz phpiredis-1.0.0.tar.gz && \
	cd phpiredis-1.0.0/ && \
	phpize && ./configure --enable-phpiredis --with-hiredis-dir=/usr/local --with-php-config=/usr/local/bin/php-config && \
	make -j4 && make install && \
	cd .. && \
	rm -rf hiredis* phpiredis* && \
	docker-php-ext-install -j4 gd zip pdo pdo_mysql gmp intl sockets && \
	docker-php-ext-enable phpiredis && \
	pecl install -f swoole xdebug && \
	docker-php-ext-enable swoole

RUN curl -L https://getcomposer.org/installer --output composer-setup.php && \
	php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	rm composer-setup.php && \
	chmod +x /usr/local/bin/composer && \
	composer global require "hirak/prestissimo" && \
	composer global require "pyrech/composer-changelogs"

RUN rm -rf /var/cache/apk/* && \
	docker-php-source delete

WORKDIR /var/www

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint.sh"]
CMD ["php-fpm"]
