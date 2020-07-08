#!/bin/sh
mysqld_safe --datadir=/var/lib/mysql &>/dev/null &

retries=5
status=1
until [ $status -eq 0 ] || [ $retries -le 0 ]; do
    mysql -uroot 2>/dev/null
    status=$?
    retries=$((retries-1))
    sleep 1
done

# Run https://github.com/krakjoe/pcov-clobber if installed.
if [ -f /code/vendor/bin/pcov ]; then /code/vendor/bin/pcov clobber; fi

/code/vendor/bin/phpunit "$@"
