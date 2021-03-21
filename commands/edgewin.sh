#!/bin/bash
#take a desktop and a dir and return the window closest to that edge relative to the focused node
#args: desktop direction
#requires sort, awk, wmutils

wintypes='.window.!hidden.!floating'

getclosest(){
    sort -${1}nk1 |
    awk 'NR == 1{xmin=$1; ymin=$2; wid=$3} NR > 1 && \
    $1 == xmin && $2 < ymin {ymin=$2; wid=$3} END{print wid}'
}
getinfo(){
    local win offset
    declare -a attr
    offset="$(wattr ${2: -1:1} $(bspc query -N -n))"
    for win in $(bspc query -N -d "$1" -n "$wintypes"); do
        attr=( $(wattr $2 $win) )
        (( attr[2] -= offset ))
        [ "$3" ] && (( attr[0] += attr[1] ))
        printf '%s %s %s\n' "${attr[0]}" "${attr[2]/#-/}" "$win"
    done
}

desk=$1 dir=$2
case $dir in
    west|east) info=xwy;;
    north|south) info=yhx;;
    *) exit 1;;
esac
case $dir in
    east|south) r='r';;
esac

getinfo $desk $info $r | getclosest $r
