#!/bin/bash

# Simple analog clock without complex math
# Constants
SIZE=20
CENTER=10

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

# Simple math functions using integer arithmetic
# Convert degrees to approximate positions using lookup table
get_hand_pos() {
    local angle=$1
    local length=$2
    
    # Normalize angle to 0-359
    angle=$((angle % 360))
    
    # Simple trigonometry approximation using integer math
    # Using lookup table for common angles
    case $angle in
        0|360) x_offset=0; y_offset=-$length ;;
        30) x_offset=$((length/2)); y_offset=$((-length*9/10)) ;;
        60) x_offset=$((length*9/10)); y_offset=$((-length/2)) ;;
        90) x_offset=$length; y_offset=0 ;;
        120) x_offset=$((length*9/10)); y_offset=$((length/2)) ;;
        150) x_offset=$((length/2)); y_offset=$((length*9/10)) ;;
        180) x_offset=0; y_offset=$length ;;
        210) x_offset=$((-length/2)); y_offset=$((length*9/10)) ;;
        240) x_offset=$((-length*9/10)); y_offset=$((length/2)) ;;
        270) x_offset=$((-length)); y_offset=0 ;;
        300) x_offset=$((-length*9/10)); y_offset=$((-length/2)) ;;
        330) x_offset=$((-length/2)); y_offset=$((-length*9/10)) ;;
        *) 
            # Rough approximation for other angles
            if [ $angle -lt 90 ]; then
                x_offset=$((length * angle / 90))
                y_offset=$((-length + length * angle / 90))
            elif [ $angle -lt 180 ]; then
                x_offset=$((length - length * (angle - 90) / 90))
                y_offset=$((length * (angle - 90) / 90))
            elif [ $angle -lt 270 ]; then
                x_offset=$((-length * (angle - 180) / 90))
                y_offset=$((length - length * (angle - 180) / 90))
            else
                x_offset=$((-length + length * (angle - 270) / 90))
                y_offset=$((-length * (angle - 270) / 90))
            fi
            ;;
    esac
    
    echo "$((CENTER + x_offset)) $((CENTER + y_offset))"
}

# Check if point is on line (simple integer version)
is_on_line() {
    local px=$1 py=$2 x1=$3 y1=$4 x2=$5 y2=$6
    
    # Calculate distances using integer math
    local dx1=$((px - x1))
    local dy1=$((py - y1))
    local dx2=$((px - x2))
    local dy2=$((py - y2))
    local dx=$((x2 - x1))
    local dy=$((y2 - y1))
    
    # Cross product should be close to zero for collinear points
    local cross=$((dx1 * dy - dy1 * dx))
    local abs_cross=$((cross < 0 ? -cross : cross))
    
    # Check if point is between the line endpoints and close to line
    if [ $abs_cross -le 2 ]; then
        local dot=$((dx1 * dx + dy1 * dy))
        local len_sq=$((dx * dx + dy * dy))
        if [ $len_sq -eq 0 ]; then
            return 0  # Same point
        elif [ $dot -ge 0 ] && [ $dot -le $len_sq ]; then
            return 0  # On line segment
        fi
    fi
    return 1
}

# Check if point is in circle
is_in_circle() {
    local px=$1 py=$2 cx=$3 cy=$4 radius=$5
    local dx=$((px - cx))
    local dy=$((py - cy))
    local dist_sq=$((dx * dx + dy * dy))
    local radius_sq=$((radius * radius))
    
    [ $dist_sq -le $radius_sq ]
}

# Main clock function
run_clock() {
    while true; do
        # Clear screen
        clear
        
        # Get current time
        local current_time=$(date +"%H:%M:%S")
        local hours=$(date +"%I")  # 12-hour format
        local minutes=$(date +"%M")
        local seconds=$(date +"%S")
        
        # Remove leading zeros
        hours=$((10#$hours))
        minutes=$((10#$minutes))
        seconds=$((10#$seconds))
        
        # Calculate angles (12 o'clock = 0°, clockwise)
        local sec_angle=$((seconds * 6))      # 360°/60 = 6° per second
        local min_angle=$((minutes * 6))      # 360°/60 = 6° per minute  
        local hou_angle=$((hours * 30 + minutes / 2))  # 360°/12 = 30° per hour
        
        # Get hand positions
        local sec_pos=($(get_hand_pos $sec_angle 8))
        local min_pos=($(get_hand_pos $min_angle 6))
        local hou_pos=($(get_hand_pos $hou_angle 4))
        
        # Create display grid
        local display=""
        
        for ((y=0; y<SIZE; y++)); do
            for ((x=0; x<SIZE; x++)); do
                local char="  "
                
                # Check if point is in clock face
                if is_in_circle $x $y $CENTER $CENTER 9; then
                    
                    # Check for center dot
                    if is_in_circle $x $y $CENTER $CENTER 1; then
                        char="${WHITE}●${RESET} "
                    
                    # Check for hour hand
                    elif is_on_line $x $y $CENTER $CENTER ${hou_pos[0]} ${hou_pos[1]}; then
                        char="${RED}█${RESET} "
                    
                    # Check for minute hand  
                    elif is_on_line $x $y $CENTER $CENTER ${min_pos[0]} ${min_pos[1]}; then
                        char="${YELLOW}█${RESET} "
                    
                    # Check for second hand
                    elif is_on_line $x $y $CENTER $CENTER ${sec_pos[0]} ${sec_pos[1]}; then
                        char="${GREEN}█${RESET} "
                    
                    # Check for hour markers
                    elif is_in_circle $x $y $CENTER $CENTER 9 && ! is_in_circle $x $y $CENTER $CENTER 7; then
                        # Simple hour marker positions
                        if (is_in_circle $x $y $CENTER 1 1) || \
                           (is_in_circle $x $y $((CENTER+8)) $CENTER 1) || \
                           (is_in_circle $x $y $CENTER $((CENTER+8)) 1) || \
                           (is_in_circle $x $y $((CENTER-8)) $CENTER 1) || \
                           (is_in_circle $x $y $CENTER $((CENTER-8)) 1); then
                            char="${WHITE}▪${RESET} "
                        fi
                    
                    # Clock face background
                    else
                        char="· "
                    fi
                fi
                
                display+="$char"
            done
            display+="\n"
        done
        
        # Display the clock
        echo -e "$display"
        echo -e "${CYAN}Time: $(printf "%02d:%02d:%02d" $hours $minutes $seconds)${RESET}"
        echo -e "${CYAN}Angles: H:${hou_angle}° M:${min_angle}° S:${sec_angle}°${RESET}"
        
        # Wait 1 second
        sleep 1
    done
}

# Start the clock
echo "Starting simple analog clock..."
echo "Press Ctrl+C to exit"
echo ""
run_clock

