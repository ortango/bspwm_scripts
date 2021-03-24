#!/bin/bash
#args: ([-r]: resize [-m]: move [-n]: target node) direction
#requires xdo, wmutils

while getopts 'n:rm' opt; do
    case $opt in
        n) node="$OPTARG";;
        r) op=resize;;
        m) op=move;;
        *) echo "invalid arg $opt" >&2;;
    esac
done; shift "$((OPTIND-1))"
dir=$1
node="$(bspc query -N -n "${node:-focused}.window")" &&
    [[ -n "$dir" ]] || exit 1
monitor="$(xdo id -N Bspwm -n root -a \
    "$(bspc query -M -n "$node" --names)")"

s=( $(wattr xywh "$node") )
m=( $(wattr xywh "$monitor") )

declare -A diraxis=([left]=0 [right]=0 [top]=1 [bottom]=1)
case "$dir" in
    right|bottom|left|top)
        i=${diraxis[$dir]}
        ;;&
    right|bottom)
        bw="$(bspc config border_width)"
        (( m[i] += ( m[i+2] - ( bw * 2 ) ) ))
        (( s[i] += s[i+2] ))
        ;;
    left|top) :;;
    *) exit 1;;
esac

(( m[i] -= s[i], m[1-i] = 0 ))

case "${op:-move}" in
    resize) bspc node "$node" -z "$dir" "${m[@]::2}";;
    move) bspc node "$node" -v "${m[@]::2}";;
esac
