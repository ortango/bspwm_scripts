#!/bin/dash
#set layer for a node. [+]up/[-]down/[~]lastlayer/[=]normal

current_layer="$(bspc query -T -n | jq -r '.client | "\(.layer) \(.lastLayer)"')"
last_layer="${current_layer##* }" current_layer="${current_layer%% *}"
case $1 in
    +|-)
            new_layer=below l=above
            [ "$1" = '+' ] &&
                new_layer=above l=below
            [ "$current_layer" = "$l" ] &&
                new_layer=normal
            ;;
    ~)      new_layer="last_layer";;
    =|'')   new_layer="normal";;
    *)      exit 1;;
esac
[ "$current_layer" != "$new_layer" ] &&
    bspc node -l "$new_layer"
