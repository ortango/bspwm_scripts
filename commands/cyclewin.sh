#!/bin/dash
#args [-s state] switch to a window type
#args [-c next|prev] cycle through local windows of current type

getstate(){
    for s in tiled floating fullscreen; do
        if bspc query -N -n "${1}.${s}" >/dev/null; then
            printf '%s' "$s"
            return
        fi
    done
    return 1
}
while getopts 's:c:' opt; do
    case $opt in
        s)
            case $OPTARG in
                tiled|floating|fullscreen)
                    bspc node "last.${OPTARG}" -f
                    ;;
                *) exit 1;;
            esac
            ;;
        c)
            case $OPTARG in
                next|prev) oper=$OPTARG;;
                *) exit 1;;
            esac
            state="$(getstate focused)"
            if bspc query -N -d -n .fullscreen.local >/dev/null; then
                bspc node "${oper}.floating.above" -f || {
                    [ "$state" != fullscreen ] &&
                    bspc node "${oper}.fullscreen" -f
                }
            else
                bspc node "${oper}.${state}" -f
            fi
            ;;
        *) echo "invalid arg: ${opt:-none}" >&2;;
    esac
done
