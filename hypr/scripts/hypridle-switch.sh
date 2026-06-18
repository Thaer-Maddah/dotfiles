#!/bin/bash
# hypridle-switch.sh — Select hypridle config based on power state.
#
# Detects AC vs battery (via TLP's tlp-stat, fallback to sysfs) and copies
# the appropriate config to hypridle.conf, then (re)starts hypridle.
#
# Called from:
#   - hyprland.lua on startup
#   - systemd user timer (every 60s) for auto-switching on plug/unplug

set -euo pipefail

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
BATTERY_CONF="$CONF_DIR/hypridle-battery.conf"
AC_CONF="$CONF_DIR/hypridle-ac.conf"
TARGET_CONF="$CONF_DIR/hypridle.conf"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypridle-power-state"

# Determine power state
# Try tlp-stat first (TLP-integrated), fall back to sysfs direct check
if POWER=$(tlp-stat --psup 2>/dev/null); then
    if echo "$POWER" | grep -q "AC adapters.*online"; then
        SOURCE_CONF="$AC_CONF"
        STATE="AC"
    else
        SOURCE_CONF="$BATTERY_CONF"
        STATE="BATTERY"
    fi
elif grep -q "1" /sys/class/power_supply/ACAD/online 2>/dev/null; then
    SOURCE_CONF="$AC_CONF"
    STATE="AC"
else
    SOURCE_CONF="$BATTERY_CONF"
    STATE="BATTERY"
fi

# Skip if already on the correct config (avoids unnecessary restarts from timer)
CURRENT_STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "unknown")
if [ "$CURRENT_STATE" = "$STATE" ]; then
    exit 0
fi

echo "$STATE" > "$STATE_FILE"

# Apply config
if [ ! -f "$SOURCE_CONF" ]; then
    echo "hypridle-switch: ERROR — $SOURCE_CONF not found" >&2
    exit 1
fi

cp "$SOURCE_CONF" "$TARGET_CONF"
echo "hypridle-switch: applied $STATE config ($SOURCE_CONF)"

# Refresh hypridle
killall hypridle 2>/dev/null || true
sleep 0.5
hypridle &
echo "hypridle-switch: hypridle restarted ($STATE mode)"
