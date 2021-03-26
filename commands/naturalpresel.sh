#!/bin/dash

dtol(){
    if [ "$1" = "north" ] || [ "$1" = "west" ]; then
        printf %s norm
    else
        printf %s inv
    fi
}

igi(){
    echo "$i" | cut -d':' -f"${1}"
}

d="$1"; cmd="bspc node -p ~${d}"
i="$(bspc query -T -n | jq -j '.presel | join(":")?')"
if [ -n "$i" ]; then
    od="$(igi 1)" or="$(igi 2)"
    if [ "$d" != "$od" ]; then
        [ "$(dtol "$od")" != "$(dtol "$d")" ] &&
            or="$(echo "scale=3; 1 - ${or}" | bc)"
        cmd="${cmd} -o ${or}"
    fi
fi
$cmd
