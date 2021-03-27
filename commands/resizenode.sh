#!/bin/dash

inc="${3:-16}"
case "$2" in
	left)   args="-${inc} 0";;
	right)  args="+${inc} 0";;
	top)    args="0 -${inc}";;
	bottom) args="0 +${inc}";;
	*)      exit 1;;
esac
bspc node -z "$1" $args
