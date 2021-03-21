#!/bin/bash
# args: node to be moved, [ desktop to move to ]

sessionprefix='/tmp/bspwm'

sendback(){
    if [ -f "${sessiondir}/${1}" ]; then
        bspc node "$1" -n "$2"
        rm "${sessiondir}/${1}"
    fi
    exit
}
_nodedesk(){ bspc query -D -n "$1"; }

while getopts "s:" opt; do
    case "$opt" in
        s) session="$OPTARG";;
    esac
done; shift $((OPTIND-1))

sessiondir="${sessionprefix}/${session:-node_cp}"
[ -n "$1" ] && mkdir -p "$sessiondir" || exit 1
node="$1" nodefile="${sessiondir}/${1}"; : "${dest:=$2}"

[[ -f "$nodefile" ]] && read -r recept <"$nodefile"
[[ -n "$dest" && "$dest" == "$(_nodedesk "$recept")" ]] && unset dest

if [[ -n "$dest" ]]; then
    ndesk="$(_nodedesk "$node")"
    [[ "$dest" == "$ndesk" ]] && exit
    [[ ! -n "$recept" ]] &&
        { bspc node "$node" -i 2>/dev/null &&
            bspc query -N -n "${node}#@brother.leaf.!window" ||
            printf '@%s:/' "$ndesk"; } >"$nodefile"
    bspc node "$node" -d "$dest"
elif [[ -n "$recept" ]] && [[ ! -n "$dest" ]]; then
    sendback "$node" "$recept"
fi
