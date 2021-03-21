#!/bin/bash
#args: x y w h [monitorid]
#requires xdo, wmutils

b(){
    local v minpos maxpos
    v=$1 minpos="$2" maxpos=$(( minpos + $3 ))
    (( v=$1 > maxpos ? maxpos : v ))
    (( v=v < minpos ? minpos : v ))
    printf '%d' "$v"
}
[[ -n "$4" ]] || exit 1
bw="$(( $(bspc config border_width) * 2 ))"
mid="$(bspc query -M -m "${5:-focused}" --names)"
mid="$(xdo id -N Bspwm -n root -a "$mid")"
m=( $(wattr xywh "$mid") )
printf '%d %d %d %d' \
    "$(b $1 "${m[0]}" "$(( m[2] - $3 - bw ))")" \
    "$(b $2 "${m[1]}" "$(( m[3] - $4 - bw ))")" \
    "$3" "$4"
