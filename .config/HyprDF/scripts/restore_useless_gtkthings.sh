#!/usr/bin/env bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}     Restoring GTK & Nautilus Defaults    ${NC}"
echo -e "${BLUE}===========================================${NC}\n"

echo -e "${GREEN}[1/2] Restoring window buttons (Close button on right)...${NC}"
# Restores default GTK headerbar buttons (use 'close,minimize,maximize:' for macOS style on left)
gsettings set org.gnome.desktop.wm.preferences button-layout ':close'

echo -e "${GREEN}[2/2] Restoring Nautilus sidebar items (Recent & Starred)...${NC}"
# Re-enable Recent files
gsettings set org.gnome.desktop.privacy remember-recent-files true

# Restart Nautilus to apply changes immediately
if pgrep -x "nautilus" > /dev/null; then
    nautilus -q
fi

echo -e "\n${BLUE}===========================================${NC}"
echo -e "${GREEN} GTK and Nautilus UI restored to default! ${NC}"
echo -e "${BLUE}===========================================${NC}"