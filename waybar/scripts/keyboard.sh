#!/usr/bin/env bash

# Get current keyboard layout
get_layout() {
    # Try multiple methods to get current layout
    local layout
    
    # Method 1: Check active window's keyboard
    layout=$(hyprctl activewindow -j | jq -r '.keyboardLayout' 2>/dev/null)
    
    # Method 2: Check all keyboards
    if [ -z "$layout" ] || [ "$layout" = "null" ]; then
        layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main==true) | .active_keymap' 2>/dev/null | head -1)
    fi
    
    # Method 3: Use setxkbmap as fallback
    if [ -z "$layout" ] || [ "$layout" = "null" ]; then
        layout=$(setxkbmap -query | grep layout | awk '{print $2}')
    fi
    
    echo "$layout"
}

CURRENT_LAYOUT=$(get_layout)

# Determine display text and CSS class
if [[ "$CURRENT_LAYOUT" == *"Arabic"* ]] || [[ "$CURRENT_LAYOUT" == *"ara"* ]] || [[ "$CURRENT_LAYOUT" == "ar" ]]; then
    TEXT=" AR"
    CLASS="arabic"
else
    TEXT=" EN"
    CLASS="english"
fi

# Output JSON for Waybar
echo "{\"text\": \"$TEXT\", \"class\": \"$CLASS\", \"tooltip\": \"Keyboard: $CURRENT_LAYOUT\"}"
