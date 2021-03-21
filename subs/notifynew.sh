#!/bin/dash

_dunstify(){
    dunstify \
        -a "new-window" \
        -A focus,focus \
        -h 'string:x-dunst-stack-tag:bspwmlatestw' \
        "new window" \
        "$(xtitle "$1") on $(bspc query -D -d "$2" --names)"
}
notifywindow(){
    [ "$(_dunstify "$1" "$2")" = 'focus' ] &&
        bspc node "$1" -f
}
wait-bspwm.sh || exit 1
while read -r _ _ d _ n; do
    if ! bspc query -D -d .active | grep -q "$d"; then
        notifywindow "$n" "$d"&
    fi
done <"$(bspc subscribe -f node_add)"
