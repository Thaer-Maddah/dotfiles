#!/bin/bash
# animated wallpaper with video for Wayland

PIDFILE="/var/run/user/$UID/bg.pid"
declare -a PIDs

# Function to get outputs based on compositor
_get_outputs() {
    # Try Hyprland first (popular compositor)
    if command -v hyprctl &> /dev/null && [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
        hyprctl monitors -j | jq -r '.[].name' 2>/dev/null && return
    fi
    
    # Try Sway
    if command -v swaymsg &> /dev/null && [[ -n "$SWAYSOCK" || -n "$I3SOCK" ]]; then
        swaymsg -t get_outputs 2>/dev/null | grep '"name"' | cut -d'"' -f4 && return
    fi
    
    # Try wlr-randr (works with many wlroots compositors)
    if command -v wlr-randr &> /dev/null; then
        wlr-randr 2>/dev/null | grep -E '^[^ ]' | awk '{print $1}' && return
    fi
    
    # Try using gnome/kde wayland
    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        # Common monitor names in Wayland
        echo "eDP-1"
        echo "HDMI-A-1"
        echo "DP-1"
        echo "DP-2"
    else
        echo "No outputs detected" >&2
        exit 1
    fi
}

# Kill existing instances
_kill_existing() {
    if [[ -f "$PIDFILE" ]]; then
        while read p; do
            if [[ -n "$p" ]] && ps -p "$p" > /dev/null 2>&1; then
                # Check if it's mpvpaper or mpv process
                comm=$(ps -p "$p" -o comm= 2>/dev/null)
                if [[ "$comm" =~ ^(mpvpaper|mpv|mpvpaper.sh)$ ]]; then
                    kill -9 "$p" 2>/dev/null
                    sleep 0.1
                fi
            fi
        done < "$PIDFILE"
    fi
    # Also kill any stray mpvpaper processes
    pkill -9 mpvpaper 2>/dev/null
}

# Function to set wallpaper
_set_wallpaper() {
    local output="$1"
    local video_file="$2"
    
    echo "Setting wallpaper on output: $output"
    
    # mpvpaper with common options
    mpvpaper "$output" "$video_file" \
        --mpv-options="--loop=inf --no-audio --no-osc --no-osd-bar \
        --no-input-default-bindings --no-window-dragging \
        --hwdec=auto --vo=gpu" &
    
    PIDs+=($!)
    sleep 0.2  # Prevent overwhelming the system
}

# Main execution
main() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <video_file>"
        exit 1
    fi
    
    video_file="$1"
    
    if [[ ! -f "$video_file" ]]; then
        echo "Error: File '$video_file' not found"
        exit 1
    fi
    
    # Kill existing instances
    _kill_existing
    
    sleep 0.5
    
    # Get outputs
    outputs=$(_get_outputs)
    
    if [[ -z "$outputs" ]]; then
        echo "Error: Could not detect any outputs"
        exit 1
    fi
    
    echo "Detected outputs:"
    echo "$outputs"
    
    # Set wallpaper on all outputs
    for output in $outputs; do
        _set_wallpaper "$output" "$video_file"
    done
    
    # Save PIDs to file
    printf "%s\n" "${PIDs[@]}" > "$PIDFILE"
    
    echo "Wallpaper set with PIDs: ${PIDs[@]}"
}

# Run main function
main "$@"
