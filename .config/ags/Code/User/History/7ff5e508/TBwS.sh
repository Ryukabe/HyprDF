#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config"
THEMES="$WAYBAR_DIR/themes"
CURRENT_FILE="$HOME/.config/waybar/.current-layout"

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null)

menu() {
    while IFS= read -r layout; do
        if [[ "$layout" == "$CURRENT" ]]; then
            echo "● $layout"
        else
            echo "$layout"
        fi
    done < <(ls -d "$THEMES"/*/ | xargs -n 1 basename)
}

apply_theme() {
    local theme="$1"
    local theme_dir="$THEMES/$theme"

    # Auto-detect config and style files inside the folder
    local config_file=$(find "$theme_dir" -name "config*" | head -n1)
    local style_file=$(find "$theme_dir" -name "style*" | head -n1)

    [ -n "$config_file" ] && cat "$config_file" > "$CONFIG"
    [ -n "$style_file" ]  && cat "$style_file"  > "$STYLECSS"

    pkill waybar && waybar &
    echo "$theme" > "$CURRENT_FILE"
}

main() {
    choice=$(menu | rofi -dmenu -i -p "Select layout" -config ~/.config/rofi/minimal.rasi)

    [ -z "$choice" ] && exit 0

    layout=$(echo "$choice" | sed 's/^[●] //')

    apply_theme "$layout"
}

main