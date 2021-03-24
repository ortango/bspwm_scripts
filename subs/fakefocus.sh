#!/bin/dash
#set focus status in compton/picom for descendants of a focus internal node
#requires picom/compton in dbus mode

f(){
    "${compton_dbus}.win_set" \
        "uint32:${1}" \
        "string:${2}" \
        "uint32:${3}" >/dev/null 2>&1 &
}

##---- DBUS ----
dpy="$(echo -n "$DISPLAY" | tr -c '[:alnum:]' _)"
[ -n "$dpy" ] || exit 1
interface="com.github.chjj.compton"
service="${interface}.${dpy}"
compton_dbus="dbus-send --print-reply --dest=${service} / ${interface}"
#type_win='uint32' type_enum='uint32'
##---- DBUS ----

wait-bspwm.sh &&
{ pgrep -x compton || pgrep -x picom; } >/dev/null 2>&1 &&
dbus-send --session \
    --dest=org.freedesktop.DBus \
    --type=method_call \
    --print-reply \
    /org/freedesktop/DBus \
    org.freedesktop.DBus.ListNames |
    grep -q "$service" ||
exit 1

while read -r _ _ _ n; do
    if bspc query -N -n "${n}.!leaf" >/dev/null; then
        list="$(bspc query -N "$n" -n .window.descendant_of | sort)"
        if [ "$lastlist" != "$list" ]; then
           { echo "$list" 4<&- |
                { echo "$lastlist" 3<&- |
                    comm --output-delimiter="% " -3 /dev/fd/3 -
                } 3<&0 <&4 4<&-
            } 4<&0 |
            while read -r a b; do
                case "$a" in
                    '%') f "$b" focused_force 2;;
                    *) f "$a" focused_force 1;;
                esac
            done
        fi
        lastlist="$list"
    else
        if [ -n "$list" ]; then
            for a in $lastlist; do
                f "$a" focused_force 2
            done
            unset list
        fi
        #for this to be actually useful i need to set focused_force 0 on inputfocused nodes that are not descendants.
        #that would be a bad idea, because it is useful to know who has actual input.
        lastlist="$n"
    fi
done <"$(bspc subscribe -f node_focus)"
