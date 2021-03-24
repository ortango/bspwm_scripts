#!/bin/bash
#reorder desktops based on a list.
#primary or first monitor gets all desktop except one per additional monitor.
#the additional monitors take desktops from the back of the list

dname=(WORK WEB MEDIA STEAM AUX)

reordermon(){
    bspc monitor "$1" -o "${@:2}" &&
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
    di=$(( ${#dname[@]} - ${#mon[@]} ))
    [[ "$di" -gt 0 ]] || exit 1
    pdname=( "${dname[@]::$di}" )
    dname=( "${dname[@]:$di}" )
    mvdesktops "$pmon" "${pdname[@]}"
    i=0; for mi in "${!mon[@]}"; do
        mvdesktops "${mon[$mi]}" "${dname[$((i++))]}"
    done
    reordermon "$pmon" "${pdname[@]}"
    i=0; for mi in "${!mon[@]}"; do
        bspc monitor "${mon[$mi]}" -d "${dname[$((i++))]}"
    done
else
    reordermon "${mon[0]}" "${dname[@]}"
fi
bspc desktop "$fdesk" -f
