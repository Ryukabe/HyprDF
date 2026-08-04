#!/usr/bin/env bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}   Arch Linux Hyprland Setup Installer    ${NC}"
echo -e "${BLUE}===========================================${NC}\n"

if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Error: Do not run this script as root/sudo directly.${NC}"
  exit 1
fi

# 1. Update System
echo -e "${GREEN}[1/6] Updating system...${NC}"
sudo pacman -Syu --noconfirm

# 2. Base Development Tools
echo -e "${GREEN}[2/6] Installing base-devel & git...${NC}"
sudo pacman -S --needed --noconfirm base-devel git

# 3. Install AUR Helper (yay)
if ! command -v yay &> /dev/null; then
    echo -e "${GREEN}[3/6] Installing yay...${NC}"
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    echo -e "${YELLOW}[3/6] yay is already installed.${NC}"
fi

# 4. Core Hyprland & GNOME Polkit Setup
echo -e "${GREEN}[4/6] Installing Hyprland core packages & Polkit...${NC}"
CORE_PKGS=(
    hyprland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    qt5-wayland
    qt6-wayland
    polkit-gnome
)
yay -S --needed --noconfirm "${CORE_PKGS[@]}"

# 5. Apps, Utilities, GTK Switcher, Cursors & Fonts
echo -e "${GREEN}[5/6] Installing Apps, Utilities, Themes, Cursors, and Fonts...${NC}"
DESKTOP_PKGS=(
    # File Manager & GTK Tools
    nautilus
    file-roller
    gvfs
    gvfs-smb
    nwg-look            

    # Screenshots, Clipboard & Utilities
    hyprshot
    wl-clipboard
    wl-clip-persist
    cliphist
    #snappy-switcher    # Alt-Tab switcher

    # Bar, Wallpaper, Notifications
    waybar
    awww                
    hypridle
    swaync              

    # Audio & Media Controls
    pipewire
    pipewire-audio
    pipewire-pulse
    wireplumber
    pavucontrol
    brightnessctl

    # System Utilities
    fastfetch
    network-manager-applet
    kitty

    # Cursors ,Iocn & Themes 
    apple-cursor        
    papirus-icon-theme
    papirus-folders

    # Fonts (JetBrains Mono, Geist Mono, Rubik, Roboto, Apple SF Pro)
    ttf-jetbrains-mono-nerd
    ttf-geist-mono-nerd
    ttf-rubik
    ttf-roboto
    ttf-roboto-mono
    noto-fonts
    noto-fonts-emoji
    apple-fonts-git     # Apple SF Pro from AUR
)

yay -S --needed --noconfirm "${DESKTOP_PKGS[@]}"

# 6. Enable Services
echo -e "${GREEN}[6/6] Enabling NetworkManager service...${NC}"
sudo systemctl enable --now NetworkManager.service 2>/dev/null || true

echo -e "\n${BLUE}===========================================${NC}"
echo -e "${GREEN} Installation Complete! ${NC}"
echo -e "${BLUE}===========================================${NC}"