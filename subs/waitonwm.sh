#!/bin/dash

u=10000 d=5
starttime="$(date +%s)"
until [ $(( $(date +%s) - starttime )) -ge $d ]; do
    if bspc subscribe -c 1 >/dev/null 2>&1; then
        exit
    fi
    usleep "$u"
done
exit 1
