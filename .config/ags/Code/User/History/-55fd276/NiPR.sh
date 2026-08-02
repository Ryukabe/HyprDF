#!/bin/bash

# Define paths consistent with your current scripts
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

# 3. List wallpapers and send to Rofi
# We use 'basename' to show just the filenames in the menu
selected_wall_name=$(ls "$WALL_DIR" | grep -E "\.(jpg|jpeg|png|webp)$" | rofi -dmenu -i -p "Select Wallpaper ($CURRENT_THEME)" -config ~/.config/rofi/minimal.rasi)

# 4. If a wallpaper was selected, apply and save it
if [ -n "$selected_wall_name" ]; then
    FULL_PATH="$WALL_DIR/$selected_wall_name"
    
    # Apply using swww (matching your apply-theme logic)[cite: 2]
    swww img "$FULL_PATH" --transition-type center --transition-fps 60 --transition-step 255
    
    # Update the symlink for hyprlock[cite: 2]
    ln -sf "$FULL_PATH" ~/.config/hypr/hyprlock/wallpaper 

    # Update the .wallpaper-state file so apply-theme.sh remembers this choice[cite: 2]
    sed -i "/^$CURRENT_THEME:/d" "$WALLPAPER_STATE"
    echo "$CURRENT_THEME:$FULL_PATH" >> "$WALLPAPER_STATE"
    
    notify-send "Wallpaper Updated" "$selected_wall_name" -t 2000
fi