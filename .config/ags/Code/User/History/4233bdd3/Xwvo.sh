#!/bin/bash


THEME_DIR="$HOME/.config/colorschemes"
APPLY_SCRIPT="$HOME/.config/colorschemes/apply-theme.sh"

# Get list of themes (folder names)
themes=$(ls -d "$THEME_DIR"/*/ | xargs -n 1 basename)

# Feed the list into Rofi
# -dmenu: tells rofi to act as a selection menu
# -p: sets the prompt text
selected_theme=$(echo "$themes" | rofi -dmenu -i -p "Select Theme" -config ~/.config/rofi/applauncher.rasi)

# If a theme was selected, apply it
if [ -n "$selected_theme" ]; then
    bash "$APPLY_SCRIPT" "$selected_theme"
fi
