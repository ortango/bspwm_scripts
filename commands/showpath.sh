#!/bin/dash
#print node [arg]'s path

goup(){
    local path parent
    if parent="$(bspc query -N "$1" -n @parent)"; then
        [ "$1" = "$(bspc query -N "$parent" -n @1)" ]
        path="$(( $? + 1 ))"
        goup "$parent"
        printf '%s/' "$path"
    fi
}
node="$(bspc query -N -n "${1:-focused}")" &&
    printf '@/%s\n' "$(goup "$node")"
