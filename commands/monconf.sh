#!/bin/bash
#run xrandr command to setup monitors
# arg is a mode, or if none try to guess appropriate mode.

declare -A modes=(
    [DOCK]='--output LVDS-1 --mode 1280x800 --output VGA-1 --mode 1280x1024 --rotate left --primary --left-of LVDS-1'
    [DOCK2]='--output LVDS-1 --mode 1280x800 --primary --output VGA-1 --mode 1280x1024 --rotate left --left-of LVDS-1'
    [LVDS-1]='--output LVDS-1 --mode 1280x800 --primary --output VGA-1 --off'
    [VGA-1]='--output VGA-1 --mode 1280x1024 --rotate left --primary --output LVDS-1 --off'
)
fail(){
    echo "$*" >&2
    exit 1
}

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
    xrandr "${modes[$mode]}" ||
        fail "xrandr failed, aborting."
else
    fail "invalid mode entered. (valid modes include ${!modes[*]})"
fi
