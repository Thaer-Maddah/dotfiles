#!/bin/bash
#vol=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "MM" } else { print $2 }}' | head -n 1)

#echo "Vol:$vol"
Vol=$(pamixer --get-volume)
# [[ $Vol -gt 80 ]] && echo -e "high" || $Vol
[[ "$(pamixer --get-mute)" == "true" ]] && echo "Mute" || echo  "Vol:$Vol%"

exit 0
