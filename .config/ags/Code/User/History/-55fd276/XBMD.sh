#!/bin/bash

# ─── Paths ────────────────────────────────────────────────────────────────────
CURRENT_THEME_FILE="$HOME/.config/colorschemes/.current-theme"
THEME_DIR="$HOME/.config/themes"
WALLPAPER_STATE="$HOME/.config/themes/.wallpaper-state"

# ─── Get active theme ─────────────────────────────────────────────────────────
if [ ! -f "$CURRENT_THEME_FILE" ]; then
    notify-send "Wallpaper Switcher" "No active theme found." -u critical
    exit 1
fi

THEME=$(cat "$CURRENT_THEME_FILE")
WALLPAPER_DIR="$THEME_DIR/$THEME/wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Switcher" "No wallpapers folder for theme: $THEME" -u critical
    exit 1
fi

# ─── Collect wallpapers ───────────────────────────────────────────────────────
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Switcher" "No wallpapers found in $WALLPAPER_DIR" -u critical
    exit 1
fi

# ─── Build Rofi input (filename only as display label) ────────────────────────
rofi_input=""
for wp in "${WALLPAPERS[@]}"; do
    rofi_input+="$(basename "$wp")\n"
done

# ─── Show Rofi picker ─────────────────────────────────────────────────────────
selected_name=$(echo -e "$rofi_input" | rofi \
    -dmenu \
    -i \
    -p "  $THEME" \
    -config ~/.config/rofi/minimal.rasi \
    -show-icons false)

[ -z "$selected_name" ] && exit 0

# ─── Match selection back to full path ────────────────────────────────────────
selected_path=""
for wp in "${WALLPAPERS[@]}"; do
    if [ "$(basename "$wp")" = "$selected_name" ]; then
        selected_path="$wp"
        break
    fi
done

[ -z "$selected_path" ] && exit 1

# ─── Apply wallpaper ──────────────────────────────────────────────────────────
awww img "$selected_path" --transition-type center --transition-fps 60 --transition-step 255 > /dev/null 2>&1

# ─── Update hyprlock symlink ──────────────────────────────────────────────────
ln -sf "$selected_path" ~/.config/hypr/hyprlock/wallpaper

# ─── Persist selection in .wallpaper-state ────────────────────────────────────
touch "$WALLPAPER_STATE"
sed -i "/^$THEME:/d" "$WALLPAPER_STATE"
echo "$THEME:$selected_path" >> "$WALLPAPER_STATE"

# ─── Notify ───────────────────────────────────────────────────────────────────
notify-send "Wallpaper" "$(basename "$selected_path")" -t 3000