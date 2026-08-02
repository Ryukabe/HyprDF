#!/bin/bash

THEME_DIR="$HOME/.config/themes"
APPLY_SCRIPT="$HOME/.config/themes/apply-theme.sh"
CURRENT_THEME_FILE="$HOME/.config/themes/.current-theme"

# Read current theme
CURRENT=$(cat "$CURRENT_THEME_FILE" 2>/dev/null)

# Build list with indicator
theme_list=""
while IFS= read -r theme; do
    if [[ "$theme" == "$CURRENT" ]]; then
        theme_list+="● $theme\n"
    else
        theme_list+="$theme\n"
    fi
done < <(ls -d "$THEME_DIR"/*/ | xargs -n 1 basename)

# Show rofi
selected=$(echo -e "$theme_list" | rofi -dmenu -i -p "Select Theme" -config ~/.config/rofi/minimal.rasi)

[ -z "$selected" ] && exit 0

# Strip the indicator before applying
theme_name=$(echo "$selected" | sed 's/^[●○] //')

bash "$APPLY_SCRIPT" "$theme_name"