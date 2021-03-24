#!/bin/bash
#args: [-f] follow [-s] cycle on smallest internal node [-p path] [-n node] target window
#requires showpath.sh, commonancestor.sh

bcolor(){ bspc config "${1}_border_color" "$2"; }
togglebc(){
    bcolor focused "$1"
    [[ -n "$1" ]] ||
        bcolor focused "$(bcolor normal)"
    return 0
}
bq(){ bspc query -N -n "$1"; }
vwin="local.leaf.!floating.!hidden"

while getopts 'fsp:n:' opt; do
    case "$opt" in
        f) follow=true;;
        s) smallest=true;;
        p)
            path="$OPTARG"
            pn="$(bspc query -N -n "$path")"
            ;;
        n)
            pn="$OPTARG"
            path="$(showpath.sh "$pn")"
            ;;
        *) echo "invalid arg: ${opt:-none}" >&2;;
    esac
done; shift $((OPTIND-1))
node=$(bq "${1:-focused}.${vwin}")

[[ -n "$node" && -n "$pn" && -n "$path" ]] || exit 1

[[ "$smallest" ]] &&
    smallest="$(commonancestor.sh "$node" "$pn")"

fn="$(bq focused)" fbc="$(togglebc)"

until [[ "$(bq "$path")" == "$node" ]]; do
    bspc node "${smallest:-@/}" -C forward
done

togglebc "$fbc"
[[ "$follow" ]] &&
    bspc node "$fn" -f
