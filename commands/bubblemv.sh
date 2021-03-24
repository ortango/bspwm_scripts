#!/bin/bash
# args: [-r] cardinal_dir

[[ "$1" == '-r' ]] && rotate=yes && shift
[[ -n "$1" ]] || exit 1
declare -A \
    toggledir=([north]=south [south]=north [east]=west [west]=east) \
    splitdir=([north]=horizontal [south]=horizontal [east]=vertical [west]=vertical)

dest=$(bspc query -N -n "${1}.window.local")
if bro="$(bspc query -N -n @brother)" && [[ "$rotate" ]]; then
    bspc query -N -n "@parent.${splitdir[$1]}" &>/dev/null ||
        dest="$bro"
fi
[[ -n "$dest" ]] || exit
[[ "$dest" != "$bro" ]] &&
    set -- "${toggledir[$1]}"

bspc node "$dest" -p "$1" &&
    bspc node -n "$dest"
