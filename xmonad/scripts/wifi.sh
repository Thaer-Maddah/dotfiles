#!/bin/bash

# Wifi interface
wi=wlp0s20f0u3
[[  $(ip link show | grep $wi) == "" ]] &&  echo "Wired" && exit 0;
#iwconfig $wi 2>&1 | grep -q "no wireless extensions." && {
#  echo wired
#  exit 0
#}

essid=$(iwconfig $wi | awk -F '"' '/ESSID/ {print $2}')
signal=$(iwconfig $wi | awk -F '=' '/Quality/ {print $2}' | cut -d '/' -f 1)
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

