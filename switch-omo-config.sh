#!/bin/bash
# Switch oh-my-opencode configuration profiles
# Usage: ./switch-omo-config.sh

CONFIG_DIR="$HOME/.config/opencode"
TARGET_FILE="$CONFIG_DIR/oh-my-opencode.json"

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get list of config files (excluding the main one)
get_configs() {
    find "$CONFIG_DIR" -maxdepth 1 -name "oh-my-opencode-*.json" -type f | sort
}

# Get current active config by comparing content
get_current() {
    if [[ ! -f "$TARGET_FILE" ]]; then
        echo ""
        return
    fi
    
    local target_hash=$(md5 -q "$TARGET_FILE" 2>/dev/null)
    while IFS= read -r file; do
        local file_hash=$(md5 -q "$file" 2>/dev/null)
        if [[ "$target_hash" == "$file_hash" ]]; then
            basename "$file"
            return
        fi
    done < <(get_configs)
    echo ""
}

# Interactive menu with arrow keys
show_menu() {
    local configs=()
    local names=()
    
    while IFS= read -r file; do
        configs+=("$file")
        names+=("$(basename "$file")")
    done < <(get_configs)
    
    if [[ ${#configs[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No oh-my-opencode-*.json config files found in $CONFIG_DIR${NC}"
        exit 1
    fi
    
    local current=$(get_current)
    local selected=0
    local total=${#configs[@]}
    
    # Hide cursor
    tput civis
    
    # Cleanup on exit
    trap 'tput cnorm; echo' EXIT INT TERM
    
    echo -e "${BOLD}Switch oh-my-opencode Configuration${NC}"
    echo -e "${DIM}Use arrow keys to navigate, Enter to select, q to quit${NC}"
    echo ""
    
    while true; do
        # Move cursor up to redraw menu
        if [[ $REPLY ]]; then
            tput cuu $total
        fi
        
        # Draw menu
        for i in "${!names[@]}"; do
            local name="${names[$i]}"
            local marker="  "
            local color=""
            local suffix=""
            
            # Check if this is the currently active config
            if [[ "$name" == "$current" ]]; then
                suffix=" ${GREEN}(active)${NC}"
            fi
            
            if [[ $i -eq $selected ]]; then
                marker="${YELLOW}>${NC} "
                color="${CYAN}"
                echo -e "${marker}${color}${name}${NC}${suffix}"
            else
                echo -e "  ${DIM}${name}${NC}${suffix}"
            fi
        done
        
        # Read single keypress
        read -rsn1 key
        
        # Handle arrow keys (escape sequences)
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key
            case $key in
                '[A') # Up arrow
                    ((selected--))
                    [[ $selected -lt 0 ]] && selected=$((total - 1))
                    ;;
                '[B') # Down arrow
                    ((selected++))
                    [[ $selected -ge $total ]] && selected=0
                    ;;
            esac
        elif [[ $key == "" ]]; then # Enter
            break
        elif [[ $key == "q" || $key == "Q" ]]; then
            tput cnorm
            echo ""
            echo -e "${DIM}Cancelled.${NC}"
            exit 0
        elif [[ $key == "j" ]]; then # vim down
            ((selected++))
            [[ $selected -ge $total ]] && selected=0
        elif [[ $key == "k" ]]; then # vim up
            ((selected--))
            [[ $selected -lt 0 ]] && selected=$((total - 1))
        fi
        
        REPLY=1
    done
    
    # Show cursor
    tput cnorm
    
    # Copy selected config
    local selected_file="${configs[$selected]}"
    local selected_name="${names[$selected]}"
    
    echo ""
    
    if [[ "$selected_name" == "$current" ]]; then
        echo -e "${YELLOW}$selected_name is already active.${NC}"
        exit 0
    fi
    
    cp "$selected_file" "$TARGET_FILE"
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Switched to: ${BOLD}$selected_name${NC}"
        echo -e "${DIM}Copied to: $TARGET_FILE${NC}"
    else
        echo -e "${YELLOW}Error: Failed to copy config file${NC}"
        exit 1
    fi
}

# Run
show_menu
