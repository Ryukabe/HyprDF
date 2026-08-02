#!/bin/bash

# Configuration
THEME_DIR="$HOME/.config/colorschemes"
APPLY_SCRIPT="$HOME/.config/hypr/scripts/apply-theme.sh" # Ensure this path is correct!

# 1. Get the list of folders, excluding hidden ones (like .wallpaper-state)
themes=$(ls -1 "$THEME_DIR" | grep -v '^\.')

# 2. Open Rofi and capture the choice
selected=$(echo "$themes" | rofi -dmenu -i -p "󱥊 Theme Launcher")

# 3. Apply the theme if one was picked
if [ -n "$selected" ]; then
    bash "$APPLY_SCRIPT" "$selected"
fi