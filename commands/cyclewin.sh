#!/bin/dash
#args [-s state] switch to a window type
#args [-c next|prev] cycle through local windows of current type

getstate(){
    for s in tiled pseudo_tiled !leaf floating fullscreen; do
        if bspc query -N -n "${1}.${s}" >/dev/null; then
	        case "$s" in
		        *tiled|!leaf) s=tiled;;
		        floating|fullscreen) :;;
	        esac
            printf '%s' "$s"
            return
        fi
    done
    return 1
}
cyc(){
    local isabove hasfullscreen ret
    isabove="$(bspc query -N -n "focused.above")"
    if hasfullscreen="$(bspc query -N -n "any.fullscreen.local")"; then
	    if [ -n "$isabove" ]; then
		    { bspc node "${1}.above.local.window" -f ||
		      bspc node "$hasfullscreen" -f; }
		    ret=$?
        else
	        bspc node "${1}.above.local.window" -f ||
		    { [ -n "$hasfullscreen" ] && [ "$2" = "fullscreen" ]; }
		    ret=$?
	    fi
	    return $ret
    else
	    bspc node "${1}.${2}.local.window" -f
	    ret=$?
    fi
    return ${ret:-1}
}

while getopts 's:c:' opt; do
    case $opt in
        s)
            case $OPTARG in
                tiled|floating|fullscreen)
                    bspc node "last.${OPTARG}.local.window" -f
                    ;;
                next)
	                state="$(getstate focused)"
	                case "$state" in
		                tiled) bspc node "last.floating.local.window" -f;;
		                floating|fullscreen) bspc node "last.tiled.local.window" -f;;
	                esac
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
            cyc "$oper" "$state"
            ;;
        *) echo "invalid arg: ${opt:-none}" >&2;;
    esac
done
