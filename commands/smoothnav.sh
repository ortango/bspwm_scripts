#!/bin/dash
#args: direction
#requires edgewin.sh

getoccd(){
    local fdid did
    fdid=$(bspc query -D -d "${1}.occupied") || return 1
    did=$fdid
    until bspc query -N -d "$did" -n .!hidden >/dev/null; do
        did=$(bspc query -D "$did" -d "${1}.occupied")
        [ "$did" != "$fdid" ] || return 1
    done
    printf '0x%08X' "$did"
}

dir=$1
case "$dir" in
    east)  desk=next.local flip=west;;
    south) desk=next.local flip=north;;
    west)  desk=prev.local flip=east;;
    north) desk=prev.local flip=south;;
    *) exit 1;;
esac
bspc node "${dir}.local.window" -f || {
    desk="$(getoccd "${desk}")" && {
        bspc desktop "${desk}.monocle" -f ||
        bspc node "@${desk}:.fullscreen" -f || {
            closest="$(edgewin.sh "$desk" "$flip")"
            [ -n "$closest" ] && bspc node "$closest" -f
        }
    }
}
