#!/bin/bash

# Define paths consistent with your current configuration
THEME_DIR="$HOME/.config/themes"
CURRENT_THEME_FILE="$HOME/.config/themes/.current-theme"
WALLPAPER_STATE="$HOME/.config/themes/.wallpaper-state"

# 1. Get the currently active theme
if [ ! -f "$CURRENT_THEME_FILE" ]; then
    notify-send "Wallpaper Error" "No current theme detected." -u critical
    exit 1
fi
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE")
WALL_DIR="$THEME_DIR/$CURRENT_THEME/wallpapers"

# 2. Check if the theme's wallpaper directory exists
if [ ! -d "$WALL_DIR" ]; then
    notify-send "Wallpaper Error" "Directory not found: $WALL_DIR"
    exit 1
fi

# 3. Construct the list strictly (Fixes the white box/extra space)
# We use 'find' to ensure only valid images are passed to Rofi[cite: 5, 8]
wall_list=$(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -printf "%f\0icon\x1f%p\n")

# 4. Call Rofi with your custom wall.rasi config
# Using -no-custom ensures the user can only pick existing files
selected=$(echo -e "$wall_list" | rofi -dmenu -i -no-custom -show-icons -p "Search wallpapers.." -config "~/.config/rofi/wall.rasi")

# 5. Apply selection and save state
if [ -n "$selected" ]; then
    FULL_PATH="$WALL_DIR/$selected"
    
    # Use awww to set the wallpaper[cite: 2, 5, 8]
    awww img "$FULL_PATH" --transition-type center --transition-fps 60 --transition-step 255
    
    # Update the symlink for hyprlock
    ln -sf "$FULL_PATH" ~/.config/hypr/hyprlock/wallpaper

    # Save choice to the state file so apply-theme.sh remembers it
    touch "$WALLPAPER_STATE" # Ensure file exists
    sed -i "/^$CURRENT_THEME:/d" "$WALLPAPER_STATE"
    echo "$CURRENT_THEME:$FULL_PATH" >> "$WALLPAPER_STATE"
    
    notify-send "Wallpaper Updated" "$selected" -t 2000
fi