#!/bin/bash

declare -A flipsign hv
flipsign=([+]='-' [-]='+')
hv=([left]=h [right]=h [top]=v [bottom]=v)
pol=([left]='-' [top]='-' [right]='+' [bottom]='+')

inc=8
while getopts 'n:i:s' opt; do
    case "$opt" in
        n) node="$OPTARGS";;
        i) inc="$OPTARG";;
        s) shink=true;;
    esac
done
dir="${!OPTIND}"
shift "$OPTIND"
sign="${pol[$dir]}"
[[ "$shink" ]] &&
    sign="${flipsign[$sign]}"
case "${hv[$dir]}" in
    h) arg=("$dir" "${sign}${inc}" 0);;
    v) arg=("$dir" 0 "${sign}${inc}");;
esac
bspc node "${node:-focused}" -z "${arg[@]}"
