#!/usr/bin/env bash

# Detect which compositor/window manager is running
detect_compositor() {
    if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] || pgrep -x hyprland >/dev/null 2>&1; then
        echo "hyprland"
    elif [ -n "$NIRI_SOCKET" ] || pgrep -x niri >/dev/null 2>&1; then
        echo "niri"
    elif [ -n "$WAYLAND_DISPLAY" ] || [ -n "$SWAYSOCK" ]; then
        echo "wayland"
    else
        echo "x11"
    fi
}

# Get current keyboard layout based on compositor
get_layout() {
    local compositor=$(detect_compositor)
    local layout
    
    case $compositor in
        "hyprland")
            # Method 1: Try active window first
            layout=$(hyprctl activewindow -j 2>/dev/null | jq -r '.keyboardLayout' 2>/dev/null)
            
            # Method 2: Check main keyboard
            if [ -z "$layout" ] || [ "$layout" = "null" ] || [ "$layout" = "" ]; then
                layout=$(hyprctl devices -j 2>/dev/null | jq -r '.keyboards[] | select(.main==true) | .active_keymap' 2>/dev/null | head -1)
            fi
            ;;
            
        "niri")
            # Niri doesn't have a direct CLI for keyboard layout yet
            # Use systemd's localectl as a fallback
            layout=$(localectl status 2>/dev/null | grep "X11 Layout" | awk '{print $3}' | cut -d, -f1)
            
            # Alternative: check environment variables
            if [ -z "$layout" ]; then
                layout=$(echo "$XKB_DEFAULT_LAYOUT" 2>/dev/null)
            fi
            ;;
            
        "wayland")
            # For generic Wayland, try wlrctl if available
            if command -v wlrctl >/dev/null 2>&1; then
                layout=$(wlrctl keyboard list 2>/dev/null | grep active | head -1 | awk '{print $3}')
            fi
            ;;
    esac
    
    # Final fallbacks for all compositors
    if [ -z "$layout" ] || [ "$layout" = "null" ] || [ "$layout" = "" ]; then
        # Try localectl (systemd)
        layout=$(localectl status 2>/dev/null | grep "X11 Layout" | awk '{print $3}' | cut -d, -f1)
    fi
    
    if [ -z "$layout" ] || [ "$layout" = "null" ] || [ "$layout" = "" ]; then
        # Try environment variables
        layout=$(echo "${XKB_DEFAULT_LAYOUT:-$XKB_LAYOUT}" 2>/dev/null)
    fi
    
    if [ -z "$layout" ] || [ "$layout" = "null" ] || [ "$layout" = "" ]; then
        # Ultimate fallback for X11 or when all else fails
        if command -v setxkbmap >/dev/null 2>&1; then
            layout=$(setxkbmap -query 2>/dev/null | grep layout | awk '{print $2}' | head -1)
        fi
    fi
    
    # Clean up layout string
    layout=$(echo "$layout" | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    echo "${layout:-unknown}"
}

# Main execution
CURRENT_LAYOUT=$(get_layout)

# Determine display text and CSS class
if [[ "$CURRENT_LAYOUT" =~ ^(ara|ar|arabic|Arabic|ara.*)$ ]] || 
   [[ "$CURRENT_LAYOUT" == *"arab"* ]] || 
   [[ "$CURRENT_LAYOUT" == *"ara"* ]] ||
   [[ "$CURRENT_LAYOUT" == "ar" ]]; then
    TEXT=" AR"
    CLASS="arabic"
else
    TEXT=" EN"
    CLASS="english"
fi

# Output JSON for Waybar
echo "{\"text\": \"$TEXT\", \"class\": \"$CLASS\", \"tooltip\": \"Keyboard: ${CURRENT_LAYOUT:-unknown}\"}"
