#!/bin/bash
#requires showpath.sh

bq() { 2>/dev/null bspc query $@; }
gettitle(){
    local temp
    temp="$(xtitle $1)"
    : "${temp:="no title - ${1}"}"
    if bq -N -n "${1}.focused" >/dev/null; then
        temp="<b>${temp}</b>"
    elif bq -N -n "${1}.hidden" >/dev/null; then
        temp="<i>${temp}</i>"
    fi
    printf '%s' "$temp"
}
getpath(){
    local temp
    temp="$(showpath.sh $1)"
    bq -N -n "${1}.leaf" >/dev/null &&
        temp="<i>${temp}</i>"
    printf '%s: %s' \
        "$(bspc query -D -n $1 --names)" \
        "$temp"
}
    
list() {
    local n t
    _rset "markup-rows" "true"
    if [[ "$1" != "$NONODES" ]]; then
        for ((n=1; n<=$#; n++)); do
            echo "${!n}" >&2
            if bq -N -n "${!n}.window" >/dev/null; then
                t="$(gettitle "${!n}")"
            else
                t="$(getpath "${!n}")"
            fi
            printf '%d %s' "$(( n - 1 ))" "$t"
            _rset "info" "${!n}"
        done | sed 's/\&/\&amp\;/g'
    else
        printf '%s' "No Nodes Available."
        _rset "nonselectable" "true"
    fi
}
_rset() { printf '\0%s\x1f%s\n' "$1" "$2"; }
NONODES='XXNONEXX'
