#!/bin/bash

# Define the options as they will appear in Rofi
# Note: The text here must match the text in the 'case' patterns exactly.
options="󰸉 Wallpaper Switcher\n󰏘 Theme Switcher\n󱂩 Waybar Switcher\n󰬶 Font Switcher"

# Launch Rofi and capture the selection[cite: 3]
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Appearance" -config ~/.config/rofi/minimal.rasi)

case "$chosen" in
    "󰸉 Wallpaper Switcher")
        # Directs to your new wallpaper logic[cite: 3]
        bash ~/.config/themes/wallpaper-switcher.sh ;;

    "󰏘 Theme Switcher")
        # References your existing theme switcher file[cite: 1, 3]
        bash ~/.config/themes/theme-switcher.sh ;;

    "󱂩 Waybar Switcher")
        # Placeholder for your Waybar script[cite: 3]
        bash ~/.config/rofi/scripts/waybar_switch.sh ;;

    "󰬶 Font Switcher")
        # Placeholder for your Font script[cite: 3]
        bash ~/.config/rofi/scripts/font_switch.sh ;;
esac