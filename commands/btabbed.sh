#!/bin/bash
#bspwm [incomplete] interface with tabbed via xdotool's windowreparent
#requires xdotool, xdo, lsw, xprop, xwininfo and tabbed

gettabbed() { xdo id -N tabbed "$@"; }
getclients(){ lsw $1 2>/dev/null; }
getcurrent(){ xwininfo -children -id "$1" | awk '$1 ~ /^0x??????/{print $1;exit}'; }
getrootid() { lsw -r 2>/dev/null; }
reparent()  { xdotool windowreparent "$1" "$2"; }
mktabbed()  { tabbed -ckd -n "$session"; }
bw()        { bspc config ${2:+-n $2} border_width $1; }
iswindow()  { bspc query -N -n "${1}.window" &>/dev/null; }
istab()     { inlist "$1" $(getclients "${tabbed[0]}"); }
istabbed()  { inlist "$1" $(gettabbed); }
inlist(){
    local i v
    v="$1"; shift
    for i in "$@"; do
        [[ "$v" -eq "$i" ]] && return
    done
    return 1
}
session="bspwm_tabbed"
while getopts "s:" opt; do
    case "$opt" in
        s) session="$OPTARG";;
    esac
done
action="${!OPTIND}"
shift $OPTIND || exit 1
case "$action" in
    add|remove|istab)
        id="$1"
        shift || exit 1
        ;;
    list|listsessions|current) : ;;
    ''|*) exit 1;;
esac
tabbed=( $(gettabbed -n "$session") )
[[ "$action" =~ add|listsessions || "${#tabbed[@]}" -gt 0 ]] || exit 1
case "$action" in
    add)
        if [[ -z "${tabbed[0]}" ]] || { ! istabbed "$id" && iswindow "$id"; }; then
            bw 0 "$id"
            reparent "$id" "${tabbed[0]:-$(mktabbed)}"
        fi
        ;;
    remove)         istab "$id" && reparent "$id" "$(getrootid)";;
    list)           getclients "${tabbed[0]}";;
    listsessions)   gettabbed | xargs -I{} xprop -id '{}' WM_CLASS;;
    istab)          istab "$id";;
    current)        getcurrent "${tabbed[0]}";;
esac
