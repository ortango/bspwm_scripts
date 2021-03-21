#!/bin/bash
#args: [-s]: swap if possible [-b]: uniform on brother [direction]
#requires cardinaldir.sh, promote.sh, uniform.sh

defaultdir=west
while [[ "${1:0:1}" == '-' ]]; do
    case "$1" in
        '-s') swap=true; shift;;
        '-b') balance=true; shift;;
    esac
done
dir="${1:-$defaultdir}"
case "$dir" in
    west|east|north|south)
        node=$(bspc query -N -n ${2:-focused})
        ;;
    *)
        node=$(bspc query -N -n ${dir:-focused})
        dir=$defaultdir
        ;;
esac
[[ -n "$node" ]] || exit 1
declare -A sd=([vertical]=horizontal [horizontal]=vertical)
psd=($(cardinaldir.sh -i $dir -h $))
{
    {
        [[ "$swap" ]] &&
        bspc node "$node" -s "@/${psd[0]}.leaf"
    } ||
    promote.sh -n "$node" "$dir"
} && [[ "$balance" ]] && uniform.sh "${sd[${psd[1]}]}" "${node}#@brother"
