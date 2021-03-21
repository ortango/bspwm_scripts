#!/bin/bash
#args: list of nodes
#requires jq

bsjq(){ bspc wm -d | jq -r ' .focusHistory | reverse | .[] | select(.nodeId != 0) | .nodeId'; }
h=( $@ )
while read -r id; do
    if [[ ${#h[@]} -gt 1 ]]; then
        for i in "${!h[@]}"; do
            (( id == h[$i] )) && unset h[$i]
        done
    else
        break
    fi
done < <(bsjq)
printf "${h[@]}"
