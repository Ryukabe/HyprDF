#!/bin/bash

options="󰸉 Wallpaper Switcher\n󰏘 Theme Switcher\n󱂩 Waybar Switcher\n󰬶 Font Switcher"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Appearance" -config "$HOME/.config/rofi/minimal.rasi")

case "$chosen" in
    "󰸉 Wallpaper Switcher")
        bash "$HOME/.config/themes/wallpaper-switcher.sh" ;;
    "󰏘 Theme Switcher")
        bash "$HOME/.config/themes/theme-switcher.sh" ;;
    "󱂩 Waybar Switcher")
        bash "$HOME/.config/rofi/scripts/waybar_switch.sh" ;;
    "󰬶 Font Switcher")
        bash "$HOME/.config/rofi/scripts/font_switch.sh" ;;
esac