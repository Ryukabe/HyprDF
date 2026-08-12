#!/bin/bash

CURRENT_THEME_FILE="$HOME/.config/HyprDF/themes/.current-theme"
THEME_DIR="$HOME/.config/HyprDF/themes"
WALLPAPER_STATE="$HOME/.config/HyprDF/themes/.wallpaper-state"
THUMB_DIR="$HOME/.cache/wallpaper-thumbs"

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

mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Switcher" "No wallpapers found in $WALLPAPER_DIR" -u critical
    exit 1
fi

# ─── Generate thumbnails ──────────────────────────────────────────────────────
mkdir -p "$THUMB_DIR"

rofi_input=""
for wp in "${WALLPAPERS[@]}"; do
    name=$(basename "$wp")
    thumb="$THUMB_DIR/${name%.*}.png"

    if [ ! -f "$thumb" ] || [ "$wp" -nt "$thumb" ]; then
        convert "$wp" -resize 420x210^ -gravity center -extent 420x210 "$thumb" 2>/dev/null
    fi

    rofi_input+="${name}\x00icon\x1f${thumb}\n"
done

# ─── Show Rofi picker ─────────────────────────────────────────────────────────
selected_name=$(echo -e "$rofi_input" | rofi \
    -dmenu \
    -i \
    -p "  $THEME" \
    -config ~/.config/rofi/wallpaper.rasi)

[ -z "$selected_name" ] && exit 0

# ─── Match back to full path ──────────────────────────────────────────────────
selected_path=""
for wp in "${WALLPAPERS[@]}"; do
    if [ "$(basename "$wp")" = "$selected_name" ]; then
        selected_path="$wp"
        break
    fi
done

[ -z "$selected_path" ] && exit 1

# ─── Apply wallpaper ─────────────────────────────────────────────────────────
awww img "$selected_path" --transition-type center --transition-fps 60 --transition-step 255 > /dev/null 2>&1
ln -sf "$selected_path" ~/.config/hypr/hyprlock/wallpaper
ln -sf "$selected_path" ~/.config/rofi/wallpaper/current_wallpaper

touch "$WALLPAPER_STATE"
sed -i "/^$THEME:/d" "$WALLPAPER_STATE"
echo "$THEME:$selected_path" >> "$WALLPAPER_STATE"

# ── material-you: regenerate colors directly into custom/ folders ─────────────
if [[ "$THEME" == "material-you" ]]; then
    notify-send "Material You" "Generating colors from wallpaper..." -t 2000
    matugen --config "$HOME/.config/matugen/config.toml" --source-color-index 0 image "$selected_path" > /dev/null 2>&1
    sleep 0.5  # wait for matugen to finish writing all files

    # Reload apps to pick up new custom/material-you.* files
    hyprctl reload & disown
    pkill waybar; sleep 0.3; ~/.config/waybar/scripts/relaunch.sh &
    pkill swaync; sleep 0.3; ~/.config/swaync/scripts/reload_nc.sh &
    pgrep kitty | xargs -r kill -SIGUSR1 > /dev/null 2>&1

    notify-send "Material You" "Colors applied from wallpaper" -t 3000
fi
# ─────────────────────────────────────────────────────────────────────────────

notify-send "Wallpaper" "$(basename "$selected_path")" -t 3000