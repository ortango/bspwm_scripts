#!/bin/dash

node="$(printf '%d' $(bspc query -N -n ${1:-focused}))" &&
    bspc query -T -n "${node}#@/" |
    jq -r --arg v "$node" '
    paths(.id?==($v|tonumber)) |
    join("/") |
    "@/\(gsub("firstChild"; "1")|gsub("secondChild"; "2"))"'
