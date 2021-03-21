#!/bin/bash
#requires rofi/bspwm_common.sh
#configure ROFI_SCRIPTS for location to source

. ${ROFI_SCRIPTS}/bspwm_common.sh

### these functions are the settings
_getnodes() {
    case "$1" in
        focus) bq -N -n .window.!focused;;
        pull) bq -N -n .window.!local;;
        focus_all) bq -N -n;;
        *) return 1;;
    esac
}
_act() {
    case "$1" in
        focus) bspc node "$2" -g hidden=off -f;;
        pull)  bspc node "$2" -g hidden=off -d focused -f;;
        focus_all) bspc node "$2" -g hidden=off -f;;
        *) return 1;;
    esac
}
###

# main modi functionality; list/act
action="$1"; shift
if [[ -z "$@" ]]; then
    list $(_getnodes "$action" || printf '%s' 'XXNONEXX')
else
    _act "$action" "$ROFI_INFO"
fi
