#!/bin/dash

f=$(bspc query -N -n)
a=$(commancestor.sh "$f" "$1") || exit
sign=$2
case "$sign" in
	+) flip='-';;
	-) flip='+';;
	*) exit 1;;
esac
[ "$(bspc query -N -n "${a}#@2#${f}.descendant_of")" = "$f" ] &&
    sign="$flip"
bspc node "$a" -r "${sign}${3:-0.05}"
