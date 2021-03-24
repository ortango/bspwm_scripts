#!/bin/bash
#args: [ 'path/' | 'NODE_SEL#@' ]
#requires xtitle

bn(){ bspc query -N -n "$@"; }
gettitle(){
    bn "${1}.window" &>/dev/null &&
    xtitle "$1" ||
    printf 'recepticle'
}
godown(){
    local id
    id="$(bn "$1")" || return 1
    printf '%s%s - 0x%08X' "$2" "$1" "$id"
    if bn "${1}1/" &>/dev/null; then
        printf '\n'
        godown "${1}1/" "${2}  "
        godown "${1}2/" "${2}  "
    else
        printf ' : [%s]\n' "$(gettitle "$id")"
    fi
}
godown "${1:-@/}"
