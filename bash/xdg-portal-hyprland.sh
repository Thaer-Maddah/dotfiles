#!/bin/sh
# Run script at startup to apply QT and GTK themes for hyprland
sleep 1

# Pick the best available portal implementation
if command -v xdg-desktop-portal-hyprland >/dev/null 2>&1; then
    PORTAL_BIN="/usr/lib/xdg-desktop-portal-hyprland"
else
    PORTAL_BIN="xdg-desktop-portal"
fi

# Restart the portal
killall "$PORTAL_BIN" 2>/dev/null
killall xdg-desktop-portal 2>/dev/null
"$PORTAL_BIN" &
