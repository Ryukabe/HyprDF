#!/bin/bash

options="󰸉 Wallpaper Switcher\n󰏘 Theme Switcher\n󱂩 Waybar Switcher\n󰬶 Font Switcher"

chosen="$(echo -e "$options" | rofi -dmenu -i -p "Appearance" -theme '~/.config/rofi/minimal.rasi')"

case "$chosen" in
    "󰸉 Wallpaper")
        ~/.config/rofi/scripts/wallpaper_switch.sh ;;

    "󰏘 Theme Switcher")
        ~/.config/themes/theme-switcher.sh ;;

    "󱂩 Waybar Layout")
        ~/.config/rofi/scripts/waybar_switch.sh ;;

    "󰬶 Fonts")
        ~/.config/rofi/scripts/font_switch.sh ;;
esac