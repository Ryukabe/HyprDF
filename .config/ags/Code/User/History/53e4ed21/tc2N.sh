#!/bin/bash

options=$(printf " Wallpaper Switcher\n Theme Switcher\n Waybar Switcher\n Font Switcher" | rofi -dmenu -i -p "Appearance" -theme '~/.config/rofi/applauncher.rasi')"

chosen="$(echo -e "$options" 

case "$options" in
    " Wallpaper Switcher")
        ~/.config/rofi/scripts/wallpaper_switch.sh ;;

    " Theme Switcher")
        ~/.config/themes/theme-switcher.sh ;;

    " Waybar Switcher")
        ~/.config/rofi/scripts/waybar_switch.sh ;;

    " Font Switcher")
        ~/.config/rofi/scripts/font_switch.sh ;;
esac