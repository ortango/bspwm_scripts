#!/bin/bash
#args: x y w h [nodeid]

c(){ printf -- '%d' "$(( ( ( $2 - $3 ) / 2 ) + $1 ))"; }
[[ -n "$4" ]] || exit 1
n="$(bspc query -N -n "${5:-focused}")"
s=( $(wattr wh "$n") )
printf '%d %d %d %d' \
    "$(c "$1" "$3" "${s[0]}")" \
    "$(c "$2" "$4" "${s[1]}")" \
    "${s[0]}" "${s[1]}"
