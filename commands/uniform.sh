#!/bin/dash
#args: (h|v) [internalnode]
#requires xargs

p="$(bspc query -N -n "${2:-focused}.!leaf")" ||
    p="$(bspc query -N -n @parent)" ||
    exit
case "$1" in
    v|vert|vertical)    d=horizontal r=90;;
    h|horz|horizontal)  d=vertical r=-90;;
    ''|*) exit 1;;
esac
bspc query -N "$p" -n .descendant_of.!leaf |
    xargs -I{} bspc node "{}.${d}" -R "$r"
bspc node "$p" -B
