#!/bin/sh
mysqld_safe --datadir=/var/lib/mysql &>/dev/null &

# Wait up to 5 seconds for mysql to start, checking once a second.
retries=5
until [ "$(pgrep mysql | wc -l)" <> 0 ] || [ $retries -le 0 ]; do
    retries=$((retries-1))
    sleep 1
done

# Run https://github.com/krakjoe/pcov-clobber if installed.
if [ -f /code/vendor/bin/pcov ]; then /code/vendor/bin/pcov clobber; fi

/code/vendor/bin/phpunit "$@"
