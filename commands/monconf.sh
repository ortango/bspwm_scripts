#!/bin/bash
#run xrandr command to setup monitors
# arg is a mode, or if none try to guess appropriate mode.

fail(){
    echo "$*" >&2
    exit 1
}

[[ -f "${XDG_CONFIG_HOME}/bspwm/monitors.conf" ]] &&
    . "${XDG_CONFIG_HOME}/bspwm/monitors.conf"

mode="$1"
if [[ -z "$mode" ]]; then
    mapfile -t monitors < <(xrandr | awk '/ connected / {print $1}')
    if [[ ${#monitors[@]} == 2 ]]; then
        mode=DOCK
    else
        mode=${monitors[0]}
    fi
fi
if [[ -n "${modes[$mode]}" ]]; then
    xrandr ${modes[$mode]} ||
        fail "xrandr failed, aborting."
else
    fail "invalid mode entered. (valid modes include ${!modes[*]})"
fi
