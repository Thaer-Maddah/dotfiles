#!/bin/bash
#vol=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "MM" } else { print $2 }}' | head -n 1)

#echo "Vol:$vol"

[[ "$(pamixer --get-mute)" == "true" ]] && echo "Mute" || echo  "Vol:$(pamixer --get-volume)%"

exit 0
