#!/bin/bash

# Analog Clock in AWK
awk '
BEGIN {
    # Constants
    R = 2.0
    c_r = 0.6
    r = 1.5
    PI = 3.14159265359
    
    # Colors
    RED = "\033[0;31m"
    GREEN = "\033[0;32m" 
    YELLOW = "\033[0;33m"
    CYAN = "\033[0;36m"
    WHITE = "\033[0;37m"
    RESET = "\033[0m"
    
    while (1) {
        # Get current time
        "date +\"%H:%M:%S\"" | getline current_time
        close("date +\"%H:%M:%S\"")
        
        split(current_time, time_parts, ":")
        hours = int(time_parts[1]) % 12
        minutes = int(time_parts[2])
        seconds = int(time_parts[3])
        
        # Calculate angles (0° = 12 oclock, clockwise)
        sec_angle = seconds * 6 * PI / 180     # 6 degrees per second
        min_angle = minutes * 6 * PI / 180     # 6 degrees per minute
        hou_angle = (hours * 30 + minutes * 0.5) * PI / 180  # 30 degrees per hour
        
        # Calculate hand end points
        sec_x = R + c_r * sin(sec_angle)
        sec_y = R - c_r * cos(sec_angle)
        
        min_x = R + c_r * sin(min_angle)
        min_y = R - c_r * cos(min_angle)
        
        hou_x = R + 0.4 * sin(hou_angle)
        hou_y = R - 0.4 * cos(hou_angle)
        
        # Clear screen
        printf "\033[H\033[2J"
        
        # Build display
        step = 0.08
        
        for (y = 0; y < 2 * R; y += step) {
            line = ""
            for (x = 0; x < 2 * R; x += step) {
                char = "  "
                
                # Check if point is inside clock face
                if (distance(x, y, R, R) <= r) {
                    
                    # Check for clock hands (in priority order)
                    if (point_on_line(x, y, R, R, hou_x, hou_y, 0.08)) {
                        char = RED "██" RESET
                    }
                    else if (point_on_line(x, y, R, R, min_x, min_y, 0.08)) {
                        char = YELLOW "██" RESET
                    }
                    else if (point_on_line(x, y, R, R, sec_x, sec_y, 0.06)) {
                        char = GREEN "██" RESET
                    }
                    # Hour markers on rim
                    else if (distance(x, y, R, R) <= r && distance(x, y, R, R) > r - 0.15) {
                        angle_deg = atan2(y - R, x - R) * 180 / PI
                        # Normalize to 0-360
                        angle_deg = (angle_deg + 360) % 360
                        
                        # Check if close to hour marker (every 30 degrees)
                        remainder = angle_deg % 30
                        if (remainder <= 3 || remainder >= 27) {
                            char = WHITE "██" RESET
                        }
                    }
                    # Center dot
                    else if (distance(x, y, R, R) <= 0.1) {
                        char = WHITE "██" RESET
                    }
                }
                
                line = line char
            }
            print line
        }
        
        # Display time
        printf "\n" CYAN "Time: %02d:%02d:%02d" RESET "\n", hours, minutes, seconds
        
        # Sleep for 1 second
        system("sleep 1")
    }
}

# Calculate distance between two points
function distance(x1, y1, x2, y2) {
    return sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))
}

# Check if point is on line segment
function point_on_line(px, py, x1, y1, x2, y2, tolerance) {
    # Calculate distance from point to line
    line_length = distance(x1, y1, x2, y2)
    
    if (line_length == 0) return 0
    
    # Distance from point to line endpoints
    dist_to_start = distance(px, py, x1, y1)
    dist_to_end = distance(px, py, x2, y2)
    
    # Check if point is on line segment
    return (abs(dist_to_start + dist_to_end - line_length) <= tolerance)
}

# Absolute value function
function abs(x) {
    return (x < 0) ? -x : x
}
'

