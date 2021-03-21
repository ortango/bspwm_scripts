#!/bin/dash
#set temporary rule to ignore all new windows
#requires notification daemon

i=$(bspc rule -l | sed -n '/\*:\* => focus=off/=')
if [ -n "$i" ]; then
    bspc rule -r "^${i}" &&
    notify-send "bspwm" "no longer ignoring new windows"
else
    bspc rule -a \* focus=off &&
    notify-send "bspwm" "ignoring new windows"
fi
