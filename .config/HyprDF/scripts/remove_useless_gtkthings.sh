#!/usr/bin/env bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}   GTK & Nautilus Customization Script     ${NC}"
echo -e "${BLUE}===========================================${NC}\n"

echo -e "${GREEN}[1/2] Hiding window controls (Close, Minimize, Maximize)...${NC}"
# Remove close, minimize, maximize buttons from headerbars
gsettings set org.gnome.desktop.wm.preferences button-layout ''

echo -e "${GREEN}[2/2] Cleaning Nautilus sidebar (Recent & Starred)...${NC}"
# Hide Recent files from Nautilus and GTK file pickers
gsettings set org.gnome.desktop.privacy remember-recent-files false


# Restart Nautilus to apply changes immediately
if pgrep -x "nautilus" > /dev/null; then
    nautilus -q
fi

echo -e "\n${BLUE}===========================================${NC}"
echo -e "${GREEN} GTK and Nautilus UI cleaned successfully! ${NC}"
echo -e "${BLUE}===========================================${NC}"