#!/bin/dash

getn(){
    bspc query -N -n ".${@}" >/dev/null &&
    for t in focused last any; do
        n=$(bspc query -N -n "${t}.${@}") && {
            printf '0x%08X' "$n"; return
        }
    done
    return 1
}
if t="$(getn !automatic)"; then
    n="$(getn marked)"
    bspc node "${n:-focused}" -n "$t" -f
else
    bspc node focused -g marked
fi
