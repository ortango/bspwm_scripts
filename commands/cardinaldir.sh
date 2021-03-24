#!/bin/bash
#args: a bunch, needs to be doc'd

cdir=(west east north south)
pdir=(0    1    0     1)
sdir=(0    0    1     1)
odir=(3    1    0     2)
pol=(first second)
spltd=(vertical horizontal)
declare -A didx=([west]=0 [east]=1 [north]=2 [south]=3)

fail(){ printf '%s\n' "$@" >&2; exit 1; }
getarg(){
    if [[ "$1" == '$' ]]; then
        [[ "$2" ]] && printf '%s' "$2"
    else
        printf '%s' "$1"
    fi
}

while getopts 'd:r:w:i:h:' opt; do
    case "$opt" in
        #return direction from PS_D
        d)
            arg="$(getarg "$OPTARG" "$ret")" ||
                fail "bad arg: missing return"
            case "$arg" in
                [01][01])
                    ret="$((${arg:0:1} + (${arg:1:1} * 2)))"
                    ret="${cdir[$ret]}"
                    ;;
                *)
                    fail "bad arg: $arg"
                    ;;
            esac
            unset arg
            ;;
        #return PS_D from dir
        i)
            arg="$(getarg "$OPTARG" "$ret")" ||
                fail "bad arg: missing return"
            case "$arg" in
                north|south|east|west)
                    i="${didx[$arg]}"
                    ret="${pdir[$i]}${sdir[$i]}"
                    ;;
                *)
                    fail "bad arg: $arg"
                    ;;
            esac
            unset i arg
            ;;
        #return PD_D from window
        w)
            {
                n="$(bspc query -N -n "$OPTARG")" &&
                pn="$(bspc query -N -n "${n}#@parent")"
            } || fail "bad window: $OPTARG"
            [[ "$(bspc query -N -n "${pn}#@1")" == "$n" ]]; ret=$?
            bspc query -N -n "${pn}.vertical" >/dev/null; ret="${ret}${?}"
            unset n pn
            ;;
        #return degree rotation from two different directions (requires two -r)
        r)
            case "$ret" in
                west|north|east|south)
                    ret=$(( ( odir[${didx[$ret]}] - odir[${didx[$OPTARG]}] ) * -90 ))
                    ;;
                '')
                    ret="$OPTARG"
                    ;;
                *)
                    fail "bad direction arg: $ret"
                    ;;
            esac
            ;;
        #return human readable PS_D from PS_D
        h)
            arg="$(getarg "$OPTARG" "$ret")" ||
                fail "bad arg: missing return"
            case "$arg" in
                [01][01])
                    ret="${pol["${arg:0:1}"]} ${spltd["${arg:1:1}"]}"
                    ;;
                *)
                    fail "bad arg: $arg"
                    ;;
            esac
            ;;
        *) fail "bad arg: ${opt:-none}";;
    esac
done
[[ -n "$ret" ]] && printf '%s' "$ret"
