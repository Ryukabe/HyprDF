#!/bin/bash

THEME_DIR="$HOME/.config/themes"
CURRENT_THEME_FILE="$HOME/.config/themes/.current-theme"
WALLPAPER_STATE="$HOME/.config/themes/.wallpaper-state"

# 1. Get current theme[cite: 2, 3]
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE")
WALL_DIR="$THEME_DIR/$CURRENT_THEME/wallpapers"

# 2. Construct the list with icons[cite: 1, 3]
wall_list=""
for wall in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$wall" ] && wall_list+="$(basename "$wall")\0icon\x1f${wall}\n"
done

# 3. Call Rofi with a custom grid config[cite: 1]
selected=$(echo -e "$wall_list" | rofi -dmenu -i -show-icons -p "Search wallpapers.." -config "~/.config/rofi/wall.rasi")

# 4. Apply selection[cite: 2, 3]
if [ -n "$selected" ]; then
    FULL_PATH="$WALL_DIR/$selected"
    awww img "$FULL_PATH" --transition-type center --transition-fps 60 --transition-step 255
    ln -sf "$FULL_PATH" ~/.config/hypr/hyprlock/wallpaper[cite: 2]
    sed -i "/^$CURRENT_THEME:/d" "$WALLPAPER_STATE"[cite: 2]
    echo "$CURRENT_THEME:$FULL_PATH" >> "$WALLPAPER_STATE"[cite: 2]
fi