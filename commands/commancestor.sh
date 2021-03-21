#!/bin/dash
#args: two nodes to compare

a(){ bspc query -N $1 -n .ancestor_of.!leaf | tac; }
for a1 in $(a $1); do for a2 in $(a $2); do
    [ "$a1" = "$a2" ] && { echo "$a1"; exit; }
done; done
exit 1
