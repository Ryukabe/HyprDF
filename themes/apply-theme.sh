#!/bin/bash

# Color codes
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

THEME="$1"
THEME_DIR="$HOME/.config/themes/$THEME"
WALLPAPER_STATE="$HOME/.config/themes/.wallpaper-state"

if [ -z "$THEME" ]; then
    echo -e "${YELLOW}Usage: $0 <theme-name>${NC}"
    exit 1
fi

if [ ! -d "$THEME_DIR" ]; then
    echo -e "${YELLOW}Theme '$THEME' does not exist at $THEME_DIR${NC}"
    notify-send "Theme Error" "Theme '$THEME' not found" -u critical
    exit 1
fi

# Track current theme
CURRENT_THEME_FILE="$HOME/.config/themes/.current-theme"
echo "$THEME" > "$CURRENT_THEME_FILE"

echo -e "${GREEN}Applying theme: $THEME${NC}\n"
notify-send "Theme Switching" "Applying theme: $THEME" -t 3000

# Spotify theme
echo -e "${CYAN}→ Applying Spotify theme...${NC}"
spicetify config color_scheme "$THEME"
spicetify refresh
echo ""

# Hyprland config
echo -e "${CYAN}→ Updating Hyprland configuration...${NC}"
cp "$THEME_DIR/hypr/colors.conf" "$HOME/.config/hypr/colors/colors.conf" > /dev/null 2>&1
hyprctl reload & disown
echo ""

# Waybar style
echo -e "${CYAN}→ Applying Waybar CSS...${NC}"
cp "$THEME_DIR/waybar/colors.css" "$HOME/.config/waybar/colors/colors.css" > /dev/null 2>&1
echo -e "${CYAN}→ Restarting Waybar...${NC}"
pkill waybar > /dev/null 2>&1 && ~/.config/waybar/scripts/launch.sh > /dev/null 2>&1 & disown
echo ""

# Wallpaper
echo -e "${CYAN}→ Setting wallpaper...${NC}"
WALLPAPER_DIR="$THEME_DIR/wallpapers"

# Create state file if it doesn't exist
touch "$WALLPAPER_STATE"

# Get saved wallpaper for this theme
SAVED_WALLPAPER=$(grep "^$THEME:" "$WALLPAPER_STATE" | cut -d':' -f2-)

if [ -n "$SAVED_WALLPAPER" ] && [ -f "$SAVED_WALLPAPER" ]; then
    # Use saved wallpaper
    WALLPAPER="$SAVED_WALLPAPER"
    echo -e "${CYAN}   Using saved wallpaper${NC}"
elif [ -d "$WALLPAPER_DIR" ]; then
    # Get first wallpaper from directory (sorted alphabetically)
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort | head -n1)

    if [ -n "$WALLPAPER" ]; then
        # Save this as the default for this theme
        sed -i "/^$THEME:/d" "$WALLPAPER_STATE"
        echo "$THEME:$WALLPAPER" >> "$WALLPAPER_STATE"
        echo -e "${CYAN}   Using first wallpaper (default)${NC}"
    else
        echo -e "${YELLOW}   No wallpapers found in $WALLPAPER_DIR${NC}"
    fi
else
    echo -e "${YELLOW}   Wallpaper directory not found: $WALLPAPER_DIR${NC}"
fi

if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
    awww img "$WALLPAPER" --transition-type center --transition-fps 60 --transition-step 255 > /dev/null 2>&1
    # Also update hyprlock symlink
    ln -sf "$WALLPAPER" ~/.config/hypr/hyprlock/wallpaper 
else
    echo -e "${YELLOW}   Could not set wallpaper${NC}"
fi
echo ""

# GTK Theme
if [ -f "$THEME_DIR/gtk-theme" ]; then
    GTK_THEME_NAME=$(cat "$THEME_DIR/gtk-theme")
    echo -e "${CYAN}→ Setting GTK theme to '$GTK_THEME_NAME'...${NC}"
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_NAME" > /dev/null 2>&1
else
    echo -e "${YELLOW}→ GTK theme file not found. Skipping.${NC}"
fi
echo ""

# GTK4 configuration
GTK4_SRC="$THEME_DIR/gtk-4.0"
GTK4_DST="$HOME/.config/gtk-4.0"

if [[ -d "$GTK4_SRC" ]]; then
    echo -e "${CYAN}→ Linking GTK4 theme files...${NC}"
    mkdir -p "$GTK4_DST"
    ln -sf "$GTK4_SRC/gtk.css" "$GTK4_DST/gtk.css"
    ln -sf "$GTK4_SRC/gtk-dark.css" "$GTK4_DST/gtk-dark.css"
    ln -sfn "$GTK4_SRC/assets" "$GTK4_DST/assets"
else
    echo -e "${YELLOW}→ No GTK4 theme files found in $GTK4_SRC. Skipping.${NC}"
fi
echo ""

# Terminal theme (Kitty)
echo -e "${CYAN}→ Applying Kitty terminal theme...${NC}"
case "$THEME" in
    everforest|gruvbox|catppuccin|tokyonight|monochrom|kanagawa|nord|noir|nightfox|rose-pine|vira-palenight|horizon|material-you|anime)
        cp "$THEME_DIR/kitty/colors.conf" "$HOME/.config/kitty/colors/colors.conf" > /dev/null 2>&1
        ;;
    *)
        echo -e "${YELLOW}→ No terminal theme defined for $THEME. Skipping.${NC}"
        ;;
esac
pgrep kitty | xargs -r kill -SIGUSR1 > /dev/null 2>&1
echo ""

# Terminal theme (Foot)
#echo -e "${CYAN}→ Applying Foot terminal theme...${NC}"
#case "$THEME" in
#    everforest|gruvbox|catppuccin|tokyonight|kanagawa|nord|noir|e-ink|nightfox|rose-pine|vira-palenight|horizon|material-you|anime)
#        cp "$THEME_DIR/foot/colors" "$HOME/.config/foot/colors" > /dev/null 2>&1
#        ;;
#    *)
#        echo -e "${YELLOW}→ No foot terminal theme defined for $THEME. Skipping.${NC}"
#        ;;
#esac
#echo ""

# SwayNC theme
echo -e "${CYAN}→ Applying SwayNC theme...${NC}"
cp "$THEME_DIR/swaync/colors.css" "$HOME/.config/swaync/colors/colors.css" > /dev/null 2>&1
echo ""

# wlogout theme
echo -e "${CYAN}→ Applying wlogout theme...${NC}"
cp "$THEME_DIR/wlogout/colors.css" "$HOME/.config/wlogout/colors/colors.css" > /dev/null 2>&1
echo ""

# Rofi theme
echo -e "${CYAN}→ Applying Rofi theme...${NC}"
cp "$THEME_DIR/rofi/colors.rasi" "$HOME/.config/rofi/colors/colors.rasi" > /dev/null 2>&1
echo ""

# Switch complited
CURRENT_THEME_FILE="$HOME/.config/colorschemes/.current-theme"
echo "$THEME" > "$CURRENT_THEME_FILE"

echo -e "${GREEN} Theme Applyed: $THEME${NC}\n"
notify-send "Theme apply" "Successfully switched to $THEME" -t 4500
