#!/bin/bash
#args: list of nodes
#requires jq

_jq(){
    jq -r --slurpfile sel <(printf '%d\n' "${nodes[@]}") '
        .focusHistory|reverse|to_entries|unique_by(.value.nodeId)|sort_by(.key)[].value|
        select(.nodeId as $nodes | any( $sel[]; . == $nodes ) ).nodeId' < <(bspc wm -d)
}

if [[ ! -t 0 ]]; then
    mapfile -t nodes
    [[ "${nodes[@]}" ]] &&
    nodes=( $(_jq) ) &&
    printf '0x%08x\n' "${nodes[@]}"
fi
