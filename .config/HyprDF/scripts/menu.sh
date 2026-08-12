#!/bin/bash

options="󰸉 Wallpaper Switcher\n󰏘 Theme Switcher\n󱂩 Waybar Switcher\n󰬶 Font Switcher"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Appearance" -config "$HOME/.config/rofi/minimal.rasi")

case "$chosen" in
    "󰸉 Wallpaper Switcher")
        bash "$HOME/.config/HyprDF/scripts/wallpaper-switcher.sh" ;;
    "󰏘 Theme Switcher")
        bash "$HOME/.config/HyprDF/scripts/theme-switcher.sh" ;;
    "󱂩 Waybar Switcher")
        bash "$HOME/.config/HyprDF/scripts/waybar-look-switcher.sh" ;;
    "󰬶 Font Switcher")
        bash "$HOME/.config/HyprDF/scripts/font-switch.sh" ;;
esac