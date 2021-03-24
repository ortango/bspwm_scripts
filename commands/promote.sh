#!/bin/dash
#args: ([-n] node [-d] destination) [direction]
#requires cardinaldir.sh

bq(){ bspc query -N -n "$@"; }
swpsd(){
    case "$2" in
        vertical) set -- horizontal;;
        horizontal) set -- vertical;;
    esac
    printf '%s' "$1"
}
while getopts "n:d:" opt; do
    case "$opt" in
        n) node="$OPTARG";;
        d) dest="$OPTARG";;
        *) echo "invalid arg: ${opt:-none}" >&2;;
    esac
done; shift "$(( OPTIND - 1 ))"
dir="${1:-west}"
node="$(bq "${node:-focused}")" &&
dest="$(bq "${dest:-@/}")" || exit 1
if [ "$dest" != "$(bq "${node}#@parent")" ]; then
    bspc node "$dest" -p "$dir" &&
    bspc node "$node" -n "$dest"
else
    r="$(cardinaldir.sh -w "$node" -d $ -r "$dir")"
    if [ -n "$r" ] && [ "$r" != 0 ]; then
        flip="$(swpsd "$(cardinaldir.sh -i "$dir" -h $)")"
        bspc node "$dest" -R "$r" -F "$flip"
    fi
fi
