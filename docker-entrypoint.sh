#!/bin/sh
mysqld_safe --datadir=/var/lib/mysql &>/dev/null &
sleep 1
/code/vendor/bin/phpunit "$@"
