#!/bin/bash
#args (rule: apply as oneshot rule | cmd: apply on target now) targetnode
#requires jq

fail(){ printf 'failure: %s\n' "$@">&2; exit 1; }
node="$(bspc query -N -n "${2:-focused}")" || fail "no node available"
dir=(west east north south) rot=([0]=90 [2]=-90)
cutoff=0.90 mode=${1:-cmd} adj=0

case $mode in
    rule)
        target=$node
        [[ "$(bspc config initial_polarity)" == "first_child" ]]
        ip=$?
        cmd=(bspc rule -a "*" -o "node=${target}")
        ;;
    cmd)
        target="$(bspc query -N "$node" -n @parent)" || fail "no parent to adjust"
        [[ "$(bspc query -N $target -n @1)" == "$node" ]]
        ip=$?
        st=0
        cmd=(bspc node $target)
        ;;
esac

g=($(bspc query -T -n "$target" | jq -r '.rectangle.height, .rectangle.width, .splitType'))
(( g[0] > g[1] )) && adj=2 t=${g[0]} g[0]=${g[1]} g[1]=$t
ratio="$(bc <<<"scale=6;r=${g[0]} / ${g[1]};if(r >= $cutoff){r=1};if(r != 1 && $ip == 1){r=1 - r};r")"
[[ "$ratio" != 1 ]] || fail "cannot create a square here"
case $mode in
    rule)
        ((adj+=ip))
        cmd+=("split_dir=${dir[$adj]}" "split_ratio=${ratio}")
        ;;
    cmd)
        [[ "${g[2]}" == "horizontal" ]] && st=2
        cmd+=(-r $ratio)
        ((adj != st)) && cmd+=(-R ${rot[$st]})
        ;;
esac
"${cmd[@]}"
