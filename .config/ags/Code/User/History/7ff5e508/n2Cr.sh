#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config"
THEMES="$WAYBAR_DIR/themes"

menu() {
    echo -e "Mica\n\Glass\nRoundeSubtle"
}

apply_theme() {
    local theme="$1"
    cat "$THEMES/$theme/style-$theme.css" > "$STYLECSS"
    cat "$THEMES/$theme/config-$theme" > "$CONFIG"
    pkill waybar && waybar &
}

main() {
    choice=$(menu | rofi -dmenu -i -p "Select layout" -config ~/.config/rofi/minimal.rasi)

    case "$choice" in
        "Zen")          apply_theme "zen" ;;
        "Experimental") apply_theme "experimental" ;;
        "Default")      apply_theme "default" ;;
        "Line")         apply_theme "line" ;;
    esac
}

main