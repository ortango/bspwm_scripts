#!/bin/bash
#reorder desktops based on a list.
#primary or first monitor gets all desktop except one per additional monitor.
#the additional monitors take desktops from the back of the list

[[ -f "${XDG_CONFIG_HOME}/bspwm/desktops.conf" ]] &&
. "${XDG_CONFIG_HOME}/bspwm/desktops.conf"

[[ "${#BSPWM_DESKTOPS[@]}" != 0 ]] ||
    BSPWM_DESKTOPS=(I II III IV V VI VII VIII IX X)

reordermon(){
    bspc monitor "$1" -o "${@:2}" 2>/dev/null
    bspc monitor "$1" -d "${@:2}"
}
mvdesktops(){
    local dm tm
    dm=$1; shift
    while [[ -n "$1" ]]; do
        tm="$(bspc query -M -d "$1")"
        [[ "$(bspc query -D -m "$tm" | wc -l)" -le 1 ]] &&
            bspc monitor "$tm" -a "$placeholder"
        bspc desktop "$1" -m "$dm"
        shift
    done
}
placeholder=tempdesktop
mon=($(bspc query -M))
fdesk=$(bspc query -D -d)
if [[ "${#mon[@]}" -gt 1 ]]; then
    if pmon=$(bspc query -M -m primary); then
        mon=(${mon[@]/"$pmon"})
    else
        pmon="${mon[0]}"
        unset "mon[0]"
    fi
    di=$(( ${#BSPWM_DESKTOPS[@]} - ${#mon[@]} ))
    [[ "$di" -gt 0 ]] || exit 1
    pdname=( "${BSPWM_DESKTOPS[@]::$di}" )
    dname=( "${BSPWM_DESKTOPS[@]:$di}" )
    mvdesktops "$pmon" "${pdname[@]}"
    i=0; for mi in "${!mon[@]}"; do
        mvdesktops "${mon[$mi]}" "${dname[$((i++))]}"
    done
    reordermon "$pmon" "${pdname[@]}"
    i=0; for mi in "${!mon[@]}"; do
        reordermon "${mon[$mi]}" "${dname[$((i++))]}"
    done
else
    reordermon "${mon[0]}" "${BSPWM_DESKTOPS[@]}"
fi
bspc desktop "$fdesk" -f
