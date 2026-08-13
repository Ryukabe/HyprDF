#!/bin/bash
# apply-wallpaper.sh <full-path-to-wallpaper>

CURRENT_THEME_FILE="$HOME/.config/HyprDF/themes/.current-theme"
WALLPAPER_STATE="$HOME/.config/HyprDF/themes/.wallpaper-state"

selected_path="$1"

if [ -z "$selected_path" ] || [ ! -f "$selected_path" ]; then
    notify-send "Wallpaper" "No valid wallpaper path given." -u critical
    exit 1
fi

if [ ! -f "$CURRENT_THEME_FILE" ]; then
    notify-send "Wallpaper" "No active theme found." -u critical
    exit 1
fi

THEME=$(cat "$CURRENT_THEME_FILE")

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
    sleep 0.5

    hyprctl reload & disown
    pkill waybar; sleep 0.3; ~/.config/waybar/scripts/relaunch.sh &
    pkill swaync; sleep 0.3; ~/.config/swaync/scripts/reload_nc.sh &
    pgrep kitty | xargs -r kill -SIGUSR1 > /dev/null 2>&1

    notify-send "Material You" "Colors applied from wallpaper" -t 3000
fi
# ─────────────────────────────────────────────────────────────────────────────

notify-send "Wallpaper" "$(basename "$selected_path")" -t 3000