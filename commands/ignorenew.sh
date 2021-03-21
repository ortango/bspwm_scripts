#!/bin/dash
#set temporary rule to ignore all new windows
#requires notification daemon

i=$(bspc rule -l | grep -n '\*:\*:\* => focus=off' | cut -d: -f1)
if [ -n "$i" ]; then
    bspc rule -r "^${i}" &&
    notify-send "bspwm" "no longer ignoring new windows"
else
    bspc rule -a \* focus=off &&
    notify-send "bspwm" "ignoring new windows"
fi
