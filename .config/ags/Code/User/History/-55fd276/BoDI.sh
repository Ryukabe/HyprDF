#!/bin/bash

# Define paths consistent with your current configuration
THEME_DIR="$HOME/.config/themes"
CURRENT_THEME_FILE="$HOME/.config/themes/.current-theme"
WALLPAPER_STATE="$HOME/.config/themes/.wallpaper-state"

# 1. Get the currently active theme
if [ ! -f "$CURRENT_THEME_FILE" ]; then
    notify-send "Wallpaper Error" "No current theme detected." -u critical[cite: 3]
    exit 1
fi
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE")
WALL_DIR="$THEME_DIR/$CURRENT_THEME/wallpapers"

# 2. Check if the theme's wallpaper directory exists
if [ ! -d "$WALL_DIR" ]; then
    notify-send "Wallpaper Error" "Directory not found: $WALL_DIR"[cite: 3]
    exit 1
fi

# 3. Construct the list with icons for wall.rasi[cite: 3, 5]
wall_list=""
for wall in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$wall" ] && wall_list+="$(basename "$wall")\0icon\x1f${wall}\n"
done

# 4. Call Rofi with your custom wall.rasi config[cite: 5]
selected=$(echo -e "$wall_list" | rofi -dmenu -i -show-icons -p "Search wallpapers.." -config "~/.config/rofi/wall.rasi")

# 5. Apply selection and save state
if [ -n "$selected" ]; then
    FULL_PATH="$WALL_DIR/$selected"
    
    # Use awww to set the wallpaper[cite: 2]
    awww img "$FULL_PATH" --transition-type center --transition-fps 60 --transition-step 255[cite: 2, 5]
    
    # Update the symlink for hyprlock[cite: 2, 5]
    ln -sf "$FULL_PATH" ~/.config/hypr/hyprlock/wallpaper[cite: 2, 5]

    # Save choice to the state file so apply-theme.sh remembers it[cite: 2, 5]
    sed -i "/^$CURRENT_THEME:/d" "$WALLPAPER_STATE"[cite: 2, 5]
    echo "$CURRENT_THEME:$FULL_PATH" >> "$WALLPAPER_STATE"[cite: 2, 5]
    
    notify-send "Wallpaper Updated" "$selected" -t 2000[cite: 3]
fi