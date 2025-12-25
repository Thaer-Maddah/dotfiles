#!/bin/bash

# Get active network interface
wi=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5}' | awk /./)

# Check if we have a network interface
if [[ -z "$wi" ]]; then
    echo '{"text": "󰌙", "tooltip": "No Network Connection", "class": "network-disconnected"}'
    exit 0
fi

# Get initial bytes
rx1=$(cat /sys/class/net/"$wi"/statistics/rx_bytes 2>/dev/null || echo "0")
tx1=$(cat /sys/class/net/"$wi"/statistics/tx_bytes 2>/dev/null || echo "0")

# Sleep for 1 second
sleep 1

# Get new bytes
rx2=$(cat /sys/class/net/"$wi"/statistics/rx_bytes 2>/dev/null || echo "0")
tx2=$(cat /sys/class/net/"$wi"/statistics/tx_bytes 2>/dev/null || echo "0")

# Calculate rates
rx_rate=$(((rx2 - rx1) / 1024))
tx_rate=$(((tx2 - tx1) / 1024))

# Format rates
rx_formatted="${rx_rate} KB/s ↓"
tx_formatted="${tx_rate} KB/s ↑"

if [[ $wi =~ "wlan" ]] || [[ $wi =~ "wlp" ]] || [[ $wi =~ "wifi" ]]; then
    # WiFi - try iwconfig first, then nmcli as fallback
    essid=""
    signal=""
    
    # Try iwconfig
    if command -v iwconfig &> /dev/null && iwconfig "$wi" 2>/dev/null | grep -q "ESSID"; then
        essid=$(iwconfig "$wi" 2>/dev/null | awk -F '"' '/ESSID/ {print $2}')
        signal_str=$(iwconfig "$wi" 2>/dev/null | awk -F '=' '/Quality/ {print $2}')
        signal=$(echo "$signal_str" | cut -d '/' -f 1 2>/dev/null)
    # Fallback to nmcli
    elif command -v nmcli &> /dev/null; then
        essid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 2>/dev/null | head -1)
        signal=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d: -f2 2>/dev/null | head -1)
    fi
    
    # Default values if empty
    essid=${essid:-"Unknown"}
    signal=${signal:-"0"}
    
    # Calculate bars (0-10 scale)
    if [[ $signal -gt 0 ]]; then
        bars=$((signal / 10))
    else
        bars=0
    fi
    
    case $bars in
        0)  bar='[-----]'; icon='󰤯'; class='network-wifi-weak' ;;
        1|2) bar='[/----]'; icon='󰤟'; class='network-wifi-weak' ;;
        3|4) bar='[//---]'; icon='󰤢'; class='network-wifi-medium' ;;
        5|6) bar='[///--]'; icon='󰤥'; class='network-wifi-good' ;;
        7|8) bar='[////-]'; icon='󰤨'; class='network-wifi-excellent' ;;
        9|10) bar='[/////]'; icon='󰤨'; class='network-wifi-excellent' ;;
        *)  bar='[--!--]'; icon='󰤭'; class='network-wifi-error' ;;
    esac
    
    text="${icon} ${rx_formatted} ${tx_formatted}"
    tooltip="SSID: ${essid}\nSignal: ${signal}%\n${bar}\nDown: ${rx_formatted}\nUp: ${tx_formatted}"
    
else
    # Wired
    icon='󰈀'
    text="${icon} ${rx_formatted} ${tx_formatted}"
    tooltip="Ethernet Connection\nDown: ${rx_formatted}\nUp: ${tx_formatted}"
    class='network-wired'
fi

# Output JSON for Waybar
echo "{\"text\": \"${text}\", \"tooltip\": \"${tooltip}\", \"class\": \"${class}\"}"
