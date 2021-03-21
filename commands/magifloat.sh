#!/bin/bash
#args [nodeid]
#requires jq

tmpdir='/tmp/bspwm/'
totile(){
    r="$(cat "$file")"
    rm "$file"
    bspc node "$1" -n "$r" -t tiled
}

n=$(bspc query -N -n ${1:-focused}) || exit 1
file="${tmpdir}/${n}.magicfloat"
if [[ -f "$file" ]]; then
    bspc query -N -n "${n}.floating" &&
    totile "$n"
else
    g=($(bspc query -T -n "$n" | jq -r '.client | .tiledRectangle[], .floatingRectangle[]'))
    [[ "${g[*]}" ]] && mkdir -p "$tmpdir" || exit 1
    for i in {0..3}; do
        (( g[$i] -= g[$((i+4))] ))
    done
    bspc query -N -n "${n}.!floating" &&
    stateargs=(-t floating)
    bspc node "$n" -i \
        "${stateargs[@]}" \
        -v "${g[0]}" "${g[1]}" \
        -z bottom_right "${g[2]}" "${g[3]}"
    bspc query -N -n "${n}#@brother.leaf.!window" > "$file"
fi
