#!/bin/dash
#args: a hidden node

bcolor(){ bspc config "${1}_border_color" "$2"; }
target="$(bspc query -N -n "${1:-any}.window.hidden")" &&
    node="$(bspc query -N -n "${2:-focused}.!hidden")" ||
    exit 1
if [ -z "$2" ] || bspc query -N -n "${node}.focused" >/dev/null; then
    focus='-f'
fi
fbc="$(bcolor focused)"
bcolor focused "$(bcolor normal)"
bspc node "$node" -i -g hidden=on &&
    bspc node "$target" -g hidden=off -n "${node}#@brother" $focus
bcolor focused "$fbc"
