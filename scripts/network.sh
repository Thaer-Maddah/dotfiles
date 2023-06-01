#!/bin/bash

# Wifi interface
#wi=wlp0s20f0u3
wi=$(ip route get 8.8.8.8 | awk '{print $5}' | awk /./)

if [[ $wi =~ "wlp" ]]; then 
    essid=$(iwconfig "$wi" | awk -F '"' '/ESSID/ {print $2}')
    signal=$(iwconfig "$wi" | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1)
    bars=$((signal / 10))
    
    case $bars in
      0)     bar='[-----]' ;;
      1|2)   bar='[/----]' ;;
      3|4)   bar='[//---]' ;;
      5|6)   bar='[///--]' ;;
      7|8)   bar='[////-]' ;;
      9|10)  bar='[/////]' ;;
      *)     bar='[--!--]' ;;
    esac
    
    echo "$essid $bar"
    exit 0
else
    # Wired Interface
    rx1=$(cat /sys/class/net/"$wi"/statistics/rx_bytes)   # Download rate
    tx1=$(cat /sys/class/net/"$wi"/statistics/tx_bytes)   # Upload rate
    while sleep 1; do
        rx2=$(cat /sys/class/net/"$wi"/statistics/rx_bytes)
        tx2=$(cat /sys/class/net/"$wi"/statistics/tx_bytes)
        printf 'Wired: %s KB/s %s KB/s\n' "$(((rx2-rx1)/1024))" "$(((tx2-tx1)/1024))"
        rx1=$rx2
        tx1=$tx2
    done
    echo "Wired"
    exit 0
fi

