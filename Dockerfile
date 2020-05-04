FROM alpine:3.11

ARG WP_VERSION=5.4

RUN apk add -u --no-cache \
	php7 \
	php7-pecl-imagick \
	php7-dom \
	php7-mysqli \
	php7-xml \
	php7-exif \
	php7-simplexml \
	mysql \
	mysql-client \
	imagemagick \
	composer \
	subversion

RUN wget -nv -O /tmp/wordpress.tar.gz https://wordpress.org/wordpress-${WP_VERSION}.tar.gz \
	&& mkdir /wordpress \
	&& tar --strip-components=1 -zxmf /tmp/wordpress.tar.gz -C /wordpress \
	&& rm /tmp/wordpress.tar.gz

RUN wget -nv -O /tmp/wp-phpunit.tar.gz https://github.com/wp-phpunit/wp-phpunit/archive/5.4.0.tar.gz \
	&& mkdir /wp-phpunit \
	&& tar --strip-components=1 -zxmf /tmp/wp-phpunit.tar.gz -C /wp-phpunit \
	&& rm /tmp/wp-phpunit.tar.gz

RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql
RUN sh -c 'mysqld_safe --datadir=/var/lib/mysql &' && sleep 4 && mysql -u root -e "CREATE DATABASE wordpress"

ENV WP_DEVELOP_DIR=/wp-phpunit
ENV WP_PHPUNIT__TESTS_CONFIG=/wp-tests-config.php

VOLUME ["/code"]
WORKDIR /code
COPY ./docker-entrypoint.sh /entrypoint.sh
COPY ./wp-tests-config.php /wp-tests-config.php
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
