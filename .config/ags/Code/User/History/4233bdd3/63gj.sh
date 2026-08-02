#!/bin/bash

# Path to your themes directory
THEME_DIR="$HOME/.config/colorschemes"
# Path to the apply script you just created
APPLY_SCRIPT="$HOME/.config/colorschemes/apply-theme.sh"

# 1. Get list of themes (folder names)
# We exclude hidden files and only look for directories
themes=$(ls -d "$THEME_DIR"/*/ | xargs -n 1 basename)

# 2. Feed the list into Rofi
# -dmenu: tells rofi to act as a selection menu
# -p: sets the prompt text
selected_theme=$(echo "$themes" | rofi -dmenu -i -p "Select Theme" -config ~/.config/rofi/applauncher.rasi)

# 3. If a theme was selected, apply it
if [ -n "$selected_theme" ]; then
    bash "$APPLY_SCRIPT" "$selected_theme"
fi
