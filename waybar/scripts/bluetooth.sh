#!/usr/bin/env bash

# Waybar Bluetooth module
# Outputs JSON: {"text": "...", "tooltip": "...", "class": "..."}
# Usage: bluetooth.sh          — show status (JSON for waybar)
#        bluetooth.sh --toggle — toggle bluetooth power

BTCTL="/usr/sbin/bluetoothctl"

if [[ "$1" == "--toggle" ]]; then
    if $BTCTL show 2>/dev/null | grep -q "Powered: yes"; then
        $BTCTL power off >/dev/null 2>&1
    else
        $BTCTL power on >/dev/null 2>&1
    fi
    exit 0
fi

get_bt_status() {
    local powered
    powered=$($BTCTL show 2>/dev/null | grep Powered | awk '{print $2}')

    if [[ "$powered" != "yes" ]]; then
        echo '{"text": "󰂲", "tooltip": "Bluetooth Off", "class": "off"}'
        return
    fi

    local connected_devices
    connected_devices=$(bluetoothctl devices Connected 2>/dev/null)

    if [[ -z "$connected_devices" ]]; then
        echo '{"text": "󰂯", "tooltip": "Bluetooth On\nNo devices connected", "class": "on"}'
        return
    fi

    # Count connected devices
    local count
    count=$(echo "$connected_devices" | wc -l)

    # Build text with icon
    local text="󰂱 $count"

    # Build detailed tooltip
    local tooltip="Connected Devices:\n"
    local first=true
    local class_list=""

    while IFS= read -r line; do
        local mac name
        mac=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | cut -d' ' -f3-)

        # Try to get battery info via bluetoothctl
        local battery=""
        if [[ -x "$BTCTL" ]]; then
            battery=$($BTCTL info "$mac" 2>/dev/null | grep Battery | awk '{print $2}' | tr -d '%')
        fi

        if [[ -n "$battery" ]] && [[ "$battery" != "0" ]]; then
            if [[ "$first" == true ]]; then
                tooltip="$tooltip  $name —  $battery%"
                first=false
            else
                tooltip="$tooltip\n  $name —  $battery%"
            fi
        else
            if [[ "$first" == true ]]; then
                tooltip="$tooltip  $name"
                first=false
            else
                tooltip="$tooltip\n  $name"
            fi
        fi
    done <<< "$connected_devices"

    echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"connected\"}"
}

get_bt_status
