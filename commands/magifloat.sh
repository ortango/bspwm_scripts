#!/bin/bash
#args [nodeid]
#requires wmutils, jq

atom_name="BSPWM_RECP"
bnq(){ bspc query -N -n "$1" >/dev/null; }

n="$(bspc query -N -n "${1:-focused}")" || exit 1
r="$(atomx "$atom_name" "$n")"
if [[ -n "$r" ]]; then
    if bnq "$n"; then
        if bnq "$r"; then
            bspc node "$n" -n "$r" -t tiled
        else
            bspc node "$n" -t tiled
        fi
        atomx -d "$atom_name" "$n"
    fi
else
    if bnq "${n}.!floating"; then
        bnq "${n}.fullscreen" && bspc node "$n" -t ~fullscreen
        mapfile -t g < <(bspc query -T -n "$n" | jq -r \
            '.client | .tiledRectangle[], .floatingRectangle[]')
        [[ -n "${g[*]}" ]] || exit 1
        for i in {0..3}; do
            (( g[i] -= g[i+4] ))
        done
        bspc node "$n" -i -t floating \
            -v "${g[0]}" "${g[1]}" \
            -z bottom_right "${g[2]}" "${g[3]}"
        r="$(bspc query -N -n "${n}#@brother.leaf.!window")" &&
            atomx "${atom_name}=${r}" "$n" >/dev/null
     fi
fi
