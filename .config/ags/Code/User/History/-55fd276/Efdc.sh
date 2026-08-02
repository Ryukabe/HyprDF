#!/bin/bash

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

# 3. Build the list in the correct Rofi icon format: "filename\0icon\x1ffull/path"
wall_list=$(find "$WALL_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    | sort \
    | while read -r full_path; do
        fname=$(basename "$full_path")
        printf "%s\0icon\x1f%s\n" "$fname" "$full_path"
    done)

# 4. Call Rofi — selected will be just the filename
selected=$(echo -e "$wall_list" \
    | rofi -dmenu -i -no-custom -show-icons \
           -p "Select Wallpaper" \
           -config "$HOME/.config/rofi/wall.rasi")

# 5. Apply selection and save state
if [ -n "$selected" ]; then
    FULL_PATH="$WALL_DIR/$selected"

    if [ ! -f "$FULL_PATH" ]; then
        notify-send "Wallpaper Error" "File not found: $FULL_PATH" -u critical
        exit 1
    fi

    # Set wallpaper with swww (note: it's swww not awww)
    swww img "$FULL_PATH" \
        --transition-type center \
        --transition-fps 60 \
        --transition-step 255

    # Update the symlink for hyprlock
    ln -sf "$FULL_PATH" "$HOME/.config/hypr/hyprlock/wallpaper"

    # Save choice to state file so apply-theme.sh remembers it
    touch "$WALLPAPER_STATE"
    sed -i "/^$CURRENT_THEME:/d" "$WALLPAPER_STATE"
    echo "$CURRENT_THEME:$FULL_PATH" >> "$WALLPAPER_STATE"

    notify-send "Wallpaper Updated" "$selected" -t 2000
fi