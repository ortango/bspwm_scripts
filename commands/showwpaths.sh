#!/bin/dash
#prints "@relative_path/ wid class:instance" of all descendant windows of a internal node path.

if node="$(bspc query -N -n "${1:-@/}.!leaf")"; then
    bspc query -T -n "$node" | jq -r --arg r "${1:-@/}" '
        paths(.client?!=null) as $path |
        getpath($path) as $v |
        "\($v.id) \([$v.client.className,$v.client.instanceName] | join(":") ) \($r)#@\($path | join("/") | gsub("firstChild"; "1")|gsub("secondChild"; "2"))"'
fi
