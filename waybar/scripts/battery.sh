#!/usr/bin/env bash

# Get battery status with time estimation
get_battery_status() {
    local capacity=0
    local status="Unknown"
    local energy_now=0
    local power_now=0
    local time_estimate=""
    
    # Try BAT0 first
    if [[ -d /sys/class/power_supply/BAT0 ]]; then
        capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
        status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")
        
        # Try to get energy and power for time estimation
        if [[ -f /sys/class/power_supply/BAT0/energy_now ]]; then
            energy_now=$(cat /sys/class/power_supply/BAT0/energy_now 2>/dev/null || echo 0)
            power_now=$(cat /sys/class/power_supply/BAT0/power_now 2>/dev/null || echo 0)
        elif [[ -f /sys/class/power_supply/BAT0/charge_now ]]; then
            energy_now=$(cat /sys/class/power_supply/BAT0/charge_now 2>/dev/null || echo 0)
            power_now=$(cat /sys/class/power_supply/BAT0/current_now 2>/dev/null || echo 0)
            # Convert from uAh/uA to uWh/uW if needed
            voltage=$(cat /sys/class/power_supply/BAT0/voltage_now 2>/dev/null || echo 10000000) # Default 10V
            energy_now=$((energy_now * voltage / 1000000))  # Convert to uWh
            power_now=$((power_now * voltage / 1000000))    # Convert to uW
        fi
    # Try BAT1
    elif [[ -d /sys/class/power_supply/BAT1 ]]; then
        capacity=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo 0)
        status=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null || echo "Unknown")
        
        if [[ -f /sys/class/power_supply/BAT1/energy_now ]]; then
            energy_now=$(cat /sys/class/power_supply/BAT1/energy_now 2>/dev/null || echo 0)
            power_now=$(cat /sys/class/power_supply/BAT1/power_now 2>/dev/null || echo 0)
        elif [[ -f /sys/class/power_supply/BAT1/charge_now ]]; then
            energy_now=$(cat /sys/class/power_supply/BAT1/charge_now 2>/dev/null || echo 0)
            power_now=$(cat /sys/class/power_supply/BAT1/current_now 2>/dev/null || echo 0)
            voltage=$(cat /sys/class/power_supply/BAT1/voltage_now 2>/dev/null || echo 10000000)
            energy_now=$((energy_now * voltage / 1000000))
            power_now=$((power_now * voltage / 1000000))
        fi
    fi
    
    # Calculate time estimate if we have valid power data
    if [[ $power_now -gt 1000 ]]; then  # More than 1W to avoid division by small numbers
        local seconds_remaining=0
        
        if [[ "$status" == "Discharging" ]]; then
            # Time remaining = energy_now / power_now (in seconds)
            seconds_remaining=$((energy_now * 3600 / power_now))  # Convert to seconds
            
            # Adjust based on capacity for better estimation
            if [[ $capacity -gt 0 ]]; then
                # More accurate: use capacity percentage and average power consumption
                seconds_remaining=$((seconds_remaining * capacity / 100))
            fi
            
            time_estimate=$(format_time $seconds_remaining)
            
        elif [[ "$status" == "Charging" ]]; then
            # Time to full = (energy_full - energy_now) / power_now
            local energy_full=0
            if [[ -f /sys/class/power_supply/BAT0/energy_full ]]; then
                energy_full=$(cat /sys/class/power_supply/BAT0/energy_full 2>/dev/null || echo 0)
            elif [[ -f /sys/class/power_supply/BAT1/energy_full ]]; then
                energy_full=$(cat /sys/class/power_supply/BAT1/energy_full 2>/dev/null || echo 0)
            fi
            
            if [[ $energy_full -gt $energy_now ]] && [[ $energy_full -gt 0 ]]; then
                seconds_remaining=$(((energy_full - energy_now) * 3600 / power_now))
                time_estimate="▲$(format_time $seconds_remaining)"
            else
                # Fallback: estimate based on capacity
                local remaining_percent=$((100 - capacity))
                if [[ $remaining_percent -gt 0 ]]; then
                    # Assume linear charging: 1% per 1.5 minutes at typical rate
                    seconds_remaining=$((remaining_percent * 90))
                    time_estimate="▲$(format_time $seconds_remaining)"
                fi
            fi
        fi
    fi
    
    echo "$capacity $status \"$time_estimate\""
}

# Format time in HH:MM or MM:SS
format_time() {
    local total_seconds=$1
    
    if [[ $total_seconds -le 0 ]]; then
        echo ""
        return
    fi
    
    if [[ $total_seconds -ge 3600 ]]; then
        # More than 1 hour: show HH:MM
        local hours=$((total_seconds / 3600))
        local minutes=$(((total_seconds % 3600) / 60))
        printf "%02d:%02d" $hours $minutes
    else
        # Less than 1 hour: show MM:SS
        local minutes=$((total_seconds / 60))
        local seconds=$((total_seconds % 60))
        printf "%02d:%02d" $minutes $seconds
    fi
}

# Get battery capacity icon based on percentage
get_battery_icon() {
    local capacity=$1
    
    if [[ $capacity -ge 95 ]]; then
        echo "󰁹"  # 100%
    elif [[ $capacity -ge 90 ]]; then
        echo "󰂂"  # 90%
    elif [[ $capacity -ge 80 ]]; then
        echo "󰂂"  # 80%
    elif [[ $capacity -ge 70 ]]; then
        echo "󰂁"  # 70%
    elif [[ $capacity -ge 60 ]]; then
        echo "󰂀"  # 60%
    elif [[ $capacity -ge 50 ]]; then
        echo "󰁿"  # 50%
    elif [[ $capacity -ge 40 ]]; then
        echo "󰁾"  # 40%
    elif [[ $capacity -ge 30 ]]; then
        echo "󰁽"  # 30%
    elif [[ $capacity -ge 20 ]]; then
        echo "󰁼"  # 20%
    elif [[ $capacity -ge 10 ]]; then
        echo "󰁺"  # 10%
    else
        echo "󰂎"  # 0-9%
    fi
}

# Get charging overlay icon based on capacity
get_charging_overlay_icon() {
    local capacity=$1
    local base_icon=$2
    
    # Use battery capacity icon with a charging overlay
    # Nerd Fonts has specific charging icons for each battery level
    if [[ $capacity -ge 95 ]]; then
        echo "󰂅"  # 100% charging
    elif [[ $capacity -ge 90 ]]; then
        echo "󰂋"  # 90% charging
    elif [[ $capacity -ge 80 ]]; then
        echo "󰂊"  # 80% charging
    elif [[ $capacity -ge 70 ]]; then
        echo "󰢞"  # 70% charging
    elif [[ $capacity -ge 60 ]]; then
        echo "󰂉"  # 60% charging
    elif [[ $capacity -ge 50 ]]; then
        echo "󰢝"  # 50% charging
    elif [[ $capacity -ge 40 ]]; then
        echo "󰂈"  # 40% charging
    elif [[ $capacity -ge 30 ]]; then
        echo "󰂇"  # 30% charging
    elif [[ $capacity -ge 20 ]]; then
        echo "󰂆"  # 20% charging
    elif [[ $capacity -ge 10 ]]; then
        echo "󰢜"  # 10% charging
    else
        echo "󰢟"  # 0-9% charging
    fi
}

# Format output with icons and time estimate
format_output() {
    local capacity=$1
    local status=$2
    local time_estimate=$3
    
    # Get base battery icon based on capacity
    local base_icon=$(get_battery_icon $capacity)
    local icon=$base_icon
    
    # If charging, use charging overlay icon that matches the capacity level
    if [[ "$status" == "Charging" ]]; then
        icon=$(get_charging_overlay_icon $capacity $base_icon)
    elif [[ "$status" == "Full" ]]; then
        icon="󰁹"  # Full battery
    fi
    
    # Set color based on battery level (only when discharging)
    local class=""
    if [[ "$status" == "Discharging" ]]; then
        if [[ $capacity -le 10 ]]; then
            class="critical"
        elif [[ $capacity -le 20 ]]; then
            class="warning"
        fi
    fi
    
    # Prepare text output
    local text="$icon $capacity%"
    if [[ -n "$time_estimate" ]]; then
        text="$text $time_estimate"
    fi
    
    # Prepare tooltip
    local tooltip="Battery: $capacity%"
    if [[ "$status" != "Unknown" ]]; then
        tooltip="$tooltip ($status)"
    fi
    if [[ -n "$time_estimate" ]]; then
        if [[ "$status" == "Charging" ]]; then
            tooltip="$tooltip\nTime to full: ${time_estimate#▲}"
        elif [[ "$status" == "Discharging" ]]; then
            tooltip="$tooltip\nTime remaining: $time_estimate"
        fi
    fi
    
    # Add power info if available
    if [[ $power_now -gt 0 ]]; then
        local power_watts=$((power_now / 1000000))
        tooltip="$tooltip\nPower: ${power_watts}W"
    fi
    
    # Output JSON for Waybar
    local json="{\"text\": \"$text\", \"tooltip\": \"$tooltip\""
    if [[ -n "$class" ]]; then
        json="$json, \"class\": \"$class\""
    fi
    echo "$json}"
}

# Alternative: Get battery info using upower (more accurate time estimates)
get_battery_status_upower() {
    if command -v upower >/dev/null 2>&1; then
        local battery=$(upower -e | grep battery | head -1)
        
        if [[ -n "$battery" ]]; then
            local capacity=$(upower -i "$battery" | grep percentage | awk '{print $2}' | tr -d '%')
            local status=$(upower -i "$battery" | grep state | awk '{print $2}')
            local time_to=""
            
            # Get time estimate
            if [[ "$status" == "discharging" ]]; then
                time_to=$(upower -i "$battery" | grep "time to empty" | awk -F: '{print $2}' | xargs)
                if [[ -n "$time_to" ]]; then
                    time_to=$(echo "$time_to" | sed 's/^[ \t]*//;s/[ \t]*$//')
                fi
            elif [[ "$status" == "charging" ]]; then
                time_to=$(upower -i "$battery" | grep "time to full" | awk -F: '{print $2}' | xargs)
                if [[ -n "$time_to" ]]; then
                    time_to="▲$(echo "$time_to" | sed 's/^[ \t]*//;s/[ \t]*$//')"
                fi
            fi
            
            # Get power information
            local power_watts=$(upower -i "$battery" | grep energy-rate | awk '{print $2}' | head -1)
            if [[ -n "$power_watts" ]]; then
                # Convert to microwatts for consistency
                power_now=$(echo "$power_watts * 1000000" | bc | cut -d. -f1)
            fi
            
            # Convert status to match sysfs format
            case "$status" in
                "discharging") status="Discharging" ;;
                "charging") status="Charging" ;;
                "fully-charged") status="Full" ;;
                *) status="Unknown" ;;
            esac
            
            echo "$capacity $status \"$time_to\""
            return
        fi
    fi
    
    # Fall back to sysfs if upower fails
    get_battery_status
}

# Main execution
main() {
    local battery_info
    # Use upower if available, otherwise use sysfs
    if command -v upower >/dev/null 2>&1; then
        battery_info=$(get_battery_status_upower)
    else
        battery_info=$(get_battery_status)
    fi
    
    # Parse the output (capacity status "time_estimate")
    eval "local parts=($battery_info)"
    local capacity="${parts[0]}"
    local status="${parts[1]}"
    local time_estimate="${parts[2]//\"/}"  # Remove quotes
    
    format_output "$capacity" "$status" "$time_estimate"
}

# Update battery info every 10 seconds for more responsive time estimates
if [[ "$1" == "--watch" ]]; then
    while true; do
        main
        sleep 10
    done
else
    main
fi
