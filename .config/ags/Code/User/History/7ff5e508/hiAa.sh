#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config"
LAYOUTS="$WAYBAR_DIR/layout"
CURRENT_FILE="$WAYBAR_DIR/.current-layout"

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null)

menu() {
    while IFS= read -r layout; do
        if [[ "$layout" == "$CURRENT" ]]; then
            echo "● $layout"
        else
            echo "$layout"
        fi
    done < <(ls -d "$LAYOUTS"/*/ | xargs -n 1 basename)
}

apply_layout() {
    local layout="$1"
    local layout_dir="$LAYOUTS/$layout"

    # Auto-detect config and style files inside the folder
    local config_file=$(find "$layout_dir" -name "config*" | head -n1)
    local style_file=$(find "$layout_dir" -name "style*" | head -n1)

    if [ -z "$config_file" ] || [ -z "$style_file" ]; then
        echo "Error: missing config or style in $layout_dir"
        exit 1
    fi

    # Remove existing symlinks or files before creating new ones
    rm -f "$CONFIG" "$STYLECSS"

    ln -sf "$config_file" "$CONFIG"
    ln -sf "$style_file"  "$STYLECSS"

    pkill waybar; waybar &disown
    echo "$layout" > "$CURRENT_FILE"
}

main() {
    choice=$(menu | rofi -dmenu -i -p "Select layout" -config ~/.config/rofi/minimal.rasi)

    [ -z "$choice" ] && exit 0

    layout=$(echo "$choice" | sed 's/^● //')

    apply_layout "$layout"
}

main