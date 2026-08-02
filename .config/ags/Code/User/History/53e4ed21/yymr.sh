#!/bin/bash

# Define the options
options=" Wallpaper Switcher\n Theme Switcher\n Waybar Switcher\n Font Switcher"

# Show the main menu
chosen="$(echo -e "$options" | rofi -dmenu -i -p "Appearance Settings" -theme-str 'window {width: 300px;}')"

case "$chosen" in
    " Theme Switcher")
        # Link to your theme script
        ~/.config/rofi/scripts/theme_switch.sh ;;
    " Waybar Switcher")
        # Link to your waybar script
        ~/.config/rofi/scripts/waybar_switch.sh ;;
    " Font Switcher")
        # Link to your font script
        ~/.config/rofi/scripts/font_switch.sh ;;
    " Wallpaper Switcher")
        # Link to your wallpaper script
        ~/.config/rofi/scripts/wallpaper_switch.sh ;;
esac