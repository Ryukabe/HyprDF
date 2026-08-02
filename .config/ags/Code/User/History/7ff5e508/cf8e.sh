#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config.jsonc"
LAYOUT="$WAYBAR_DIR/layout"
CURRENT_FILE="$WAYBAR_DIR/.current-layout"

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null)

menu() {
    while IFS= read -r layout; do
        if [[ "$layout" == "$CURRENT" ]]; then
            echo "● $layout"
        else
            echo "$layout"
        fi
    done < <(ls -d "$LAYOUT"/*/ | xargs -n 1 basename)
}

apply_layout() {
    local layout="$1"
    local layout_dir="$LAYOUT/$layout"

    # Auto-detect config and style files inside the folder
    local config_file=$(find "$layout_dir" -name "config*" | head -n1)
    local style_file=$(find "$layout_dir" -name "style*" | head -n1)

    [ -n "$config_file" ] && ln -sf "$config_file" "config.jsonc"
    [ -n "$style_file" ]  && ln -sf "$style_file" "style.css"

    # Restart Waybar to apply the new symlinked configuration
    pkill waybar && waybar &
    echo "$layout" > "$CURRENT_FILE"
}

main() {
    choice=$(menu | rofi -dmenu -i -p "Select layout" -config ~/.config/rofi/minimal.rasi)

    [ -z "$choice" ] && exit 0

    layout=$(echo "$choice" | sed 's/^[●] //')

    apply_theme "$layout"
}

main