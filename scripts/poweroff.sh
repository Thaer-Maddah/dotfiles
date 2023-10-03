#!/bin/bash
#
# Control power options using systemd
choice=$(printf "Poweroff\nReboot\nSuspend\nLogout" | dmenu -i -sb "#a61a02")
[[ $choice = "Poweroff" ]] && poweroff
[[ $choice = "Reboot" ]] && reboot
[[ $choice = "Logout" ]] && loginctl kill-session "$(loginctl list-sessions | awk 'NR == 2 { print $1 }')" # get session ID by loginctl 
[[ $choice = "Suspend" ]] && systemctl suspend
