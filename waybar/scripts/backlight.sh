#!/usr/bin/env bash

STEP=5

get_brightness() {
    brightnessctl get | awk '{printf "%d", $1}'
}

get_icon() {
    local brightness=$1
    if [[ $brightness -lt 25 ]]; then
        echo "󰃚"
    elif [[ $brightness -lt 50 ]]; then
        echo "󰃜"
    elif [[ $brightness -lt 75 ]]; then
        echo "󰃝"
    else
        echo "󰃞"
    fi
}

output_json() {
    local brightness=$(get_brightness)
    local icon=$(get_icon $brightness)
    
    # This is the key part: Waybar expects specific JSON keys
    echo "{\"text\":\"$icon $brightness%\", \"percentage\":$brightness}"
}

case "$1" in
    --increase)
        brightnessctl set +${STEP}%
        output_json
        ;;
    --decrease)
        brightnessctl set ${STEP}%-
        output_json
        ;;
    --get)
        output_json
        ;;
    *)
        output_json
        ;;
esac
