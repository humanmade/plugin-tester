#!/bin/sh
mysqld_safe --datadir=/var/lib/mysql &>/dev/null &
sleep 1

# Run https://github.com/krakjoe/pcov-clobber if installed.
if [ -f /code/vendor/bin/pcov ]; then /code/vendor/bin/pcov clobber; fi

/code/vendor/bin/phpunit "$@"
