#!/bin/dash
#args: [+/-]change layer [~] change to lastlayer [=]change to normal layer
#requires jq

glayer(){
    set -- normal above below
    until bspc query -N -n "focused.${1}" >/dev/null; do
        shift
    done
    printf '%s' "$1"
}

op=$1
case $op in
    +|-)
        current_layer="$(glayer)"
        set -- below above below normal normal
        [ "$op" = '+' ] && shift
        [ "$current_layer" = "$2" ] && shift 3
        new_layer="$1"
        ;;
    ~)
        new_layer="$(bspc query -T -n | jq -r '.client | .lastLayer')"
        ;;
    =|'')
        new_layer="normal"
        ;;
    above|below|normal)
        new_layer="$op"
        ;;
    *)
        exit 1
        ;;
esac
bspc node -l "$new_layer"
