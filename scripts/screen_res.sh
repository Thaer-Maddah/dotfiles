#!/bin/sh
# Get screen wide for xmobar
# width=$(xrandr | grep "*" | awk '{print $1}' | cut  -b -4)
width=$(xrandr | awk '/+$/ {print substr($1, 1, 4)}')
echo $((width-12))
