#!/bin/bash
#args [-s | -r] action=activate|reset|toggle
#requires mmutils, orderdesks.sh

printgeom(){ printf '%dx%d+%d+%d' "$@"; }
resizemon(){ bspc monitor "$1" -g "$2"; }
mkvirtmon(){ bspc wm -a "$@"; }
bm(){ bspc query -M -m "$@" 2>/dev/null; }

declare -A splitind=([vertical]=0 [horizontal]=1)

while getopts 's:r:' opt; do
    case "$opt" in
        s) splittype="$OPTARG";;
        r) splitratio="$OPTARG";;
        *) echo "invalid arg: ${opt:-none}";;
    esac
done
action="${!OPTIND}"; shift "$OPTIND"
: "${splittype:=vertical}" "${splitratio:=5}"
index="${splitind[$splittype]}"
mid="$(bm primary)" || exit 1
mname="$(bm "$mid" --names)"
mrect=($(mattr whxy "$mname"))
vname="${mname}_virt"
vactive="$(bm "$vname")"

if [[ "$action" == toggle ]]; then
    [[ -n "$vactive" ]] &&
    action=reset || action=activate
fi
case "$action" in
    activate)
        (( oldsize = mrect[index],
           mrect[index] = mrect[index] * ( 10 - splitratio ) / 10 ))
        bspc monitor "$mid" -g "$(printgeom "${mrect[@]}")"
        (( mrect[index + 2] += mrect[index],
           mrect[index] = oldsize - mrect[index] ))
        if [[ -n "$vactive" ]]; then
            bspc monitor "$vname" -g "$(printgeom "${mrect[@]}")"
        else
            bspc wm -a "$vname" "$(printgeom "${mrect[@]}")"
            orderdesks.sh
        fi
        ;;
    reset)
        if [[ -n "$vactive" ]]; then
            bspc monitor "$vactive" -a placeholder
            for tempid in $(bspc query -D -m "$vactive"); do
                bspc desktop "$tempid" -m "$mid" &>/dev/null
            done
            bspc monitor "$vactive" -r
            bspc monitor "$mid" -g "$(printgeom "${mrect[@]}")"
            orderdesks.sh
        fi
        ;;
    *) echo "invalid action: $action" >&2;;
esac
