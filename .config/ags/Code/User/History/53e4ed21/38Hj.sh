#!/bin/bash

# Define the options
options=" Wallpaper Switcher\n Theme Switcher\n Waybar Switcher\n Font Switcher"

# Show the main menu
chosen="$(echo -e "$options" | rofi -dmenu -i -p "Appearance" -theme '~/.config/rofi/applauncher.rasi')"

case "$chosen" in
    " Wallpaper Switcher")
        ~/.config/rofi/scripts/wallpaper_switch.sh ;;

    " Theme Switcher")
        ~/.config/themes/theme-switcher.sh ;;

    " Waybar Switcher")
        ~/.config/rofi/scripts/waybar_switch.sh ;;

    " Font Switcher")
        ~/.config/rofi/scripts/font_switch.sh ;;
esac