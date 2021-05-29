#!/bin/bash

getattb(){
    local v
    for v in "${@:2}"; do
        if bspc query -N -n "${1}.${v}" >/dev/null; then
            printf '%s' "$v"
            return
        fi
    done
}
getlayer(){
    local l s
    l="$(getattb "$1" normal above below)"
    s="$(getattb "$1" tiled pseudo_tiled floating fullscreen)"
    printf '%d' $(( _l[$l] + _s[$s] ))
}
getrect(){
    declare -a r
    read -ra r < <(wattr xywh "$1")
    (( r[2]+=r[0], r[3]+=r[1] ))
    echo "${r[@]}"
}
ckoccud(){ (( r[0] < $3 && r[2] > $1 && r[1] < $4 && r[3] > $2 )); }

declare -A _s _l
_s=([fullscreen]=2 [floating]=1 [tiled]=0 [pseudo_tiled]=0)
_l=([above]=20 [normal]=10 [below]=0)

t="$(bspc query -N -n "${1:-focused}.window")" || exit 1
l="$(getlayer "$t")"
r=( $(getrect "$t") )

while read -r i; do {
    (( i != t && $(getlayer "$i") > l )) &&
    ckoccud $(getrect "$i") &&
    printf '0x%08X\n' "$i"
}& done < <(bspc query -N "$t" -n .window.!hidden.local)
wait
