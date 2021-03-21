#!/bin/bash
#subscribe node replacement to watch actions at a path.

intree(){ bspc query -N -n "${1}#${path}.ancestor_of" &>/dev/null; }
wasintree(){ grep -qx "$1" <<<"$cct"; }
updcct() { cct="$(bspc query -N "$path" -n .descendant_of)"; }
if [[ -n "$1" ]]; then
    path="$1"
    shift
else
    exit 1
fi
if [[ -n "$1" ]]; then
    set -- $(printf 'node_%s ' "$@")
else
    set -- node
fi
updcct
while read -ra e; do
    unset res
    action="${e[0]#node_}"
    case "$action" in
        add)
            intree ${e[4]} &&
                res="${e[@]:3}"
            ;;
        remove)
            wasintree ${e[3]} &&
                res="${e[3]}"
            ;;
        swap)
            { intree ${e[3]} || intree ${e[6]}; } &&
                res="${e[3]} ${e[6]}"
            ;;
        transfer)
            { intree ${e[3]} || wasintree ${e[3]} || intree ${e[6]}; } &&
                res="${e[3]} ${e[6]}"
            ;;
        activate|focus)
            intree ${e[3]} &&
                res="${e[3]}"
            ;;
        stack)
            { intree ${e[1]} || intree ${e[3]}; } &&
                res="${e[@]:1}"
            ;;
        flag|geometry|layer|presel|state)
            intree ${e[3]} &&
                res="${e[@]:3}"
            ;;
    esac
    if [[ -n "$res" ]]; then
        printf '%s %s\n' "$action" "$res"
        updcct
    fi
done < <(bspc subscribe $@)
