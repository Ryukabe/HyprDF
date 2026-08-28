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

# Prompt User for Shell/Bar Configuration Preference
echo -e "${YELLOW}Select your preferred UI stack:${NC}"
echo "1) Quickshell + Hyprland (Modern Qt/QML shell setup)"
echo "2) Hyprland + Waybar + SwayNC + Rofi + Wlogout (Classic ecosystem setup)"
read -rp "Enter choice [1 or 2]: " UI_CHOICE

echo ""

# 0. Backup Existing Configurations
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.config_backup_$TIMESTAMP"

echo -e "${GREEN}[0/8] Backing up existing configurations to ${BACKUP_DIR}...${NC}"
mkdir -p "$BACKUP_DIR"

CONFIG_TARGETS=(
    "$HOME/.config/hypr"
    "$HOME/.config/waybar"
    "$HOME/.config/swaync"
    "$HOME/.config/rofi"
    "$HOME/.config/wlogout"
    "$HOME/.config/quickshell"
    "$HOME/.config/zsh"
    "$HOME/.config/kitty"
    "$HOME/.zshrc"
    "$HOME/.zshenv"
)

for target in "${CONFIG_TARGETS[@]}"; do
    if [ -e "$target" ]; then
        echo -e "${BLUE}  -> Backing up $target${NC}"
        cp -rf "$target" "$BACKUP_DIR/"
    fi
done

# 1. Update System
echo -e "${GREEN}[1/8] Updating system...${NC}"
sudo pacman -Syu --noconfirm

# 2. Base Development Tools & Shell
echo -e "${GREEN}[2/8] Installing base-devel, git, and zsh...${NC}"
sudo pacman -S --needed --noconfirm base-devel git zsh

# 3. Install AUR Helper (yay)
if ! command -v yay &> /dev/null; then
    echo -e "${GREEN}[3/8] Installing yay...${NC}"
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    echo -e "${YELLOW}[3/8] yay is already installed.${NC}"
fi

# 4. Core Hyprland & GNOME Polkit Setup
echo -e "${GREEN}[4/8] Installing Hyprland core packages & Polkit...${NC}"
CORE_PKGS=(
    hyprland                    # Wayland compositor
    xdg-desktop-portal-hyprland # Desktop portal backend
    xdg-desktop-portal-gtk      # GTK portal backend
    qt5-wayland                 # Native Wayland support for Qt5
    qt6-wayland                 # Native Wayland support for Qt6
    polkit-gnome                # Authentication agent
)
yay -S --needed --noconfirm "${CORE_PKGS[@]}"

# 5. Apps, Utilities, GTK Switcher, Cursors & Fonts
echo -e "${GREEN}[5/8] Installing Selected Desktop UI Stack & Utilities...${NC}"

# Common Application Stack
DESKTOP_PKGS=(
    # File Managers & GTK Tools
    nautilus thunar file-roller gvfs gvfs-smb nwg-look ristretto

    # Screenshots, Clipboard & Utilities
    hyprshot wl-clipboard wl-clip-persist cliphist

    # Wallpapers & Idle
    swww hypridle

    # Audio & Media Controls
    pipewire pipewire-audio pipewire-pulse wireplumber pavucontrol brightnessctl

    # System Utilities
    fastfetch network-manager-applet kitty kdeconnect

    # Cursors, Icons & Themes
    apple-cursor papirus-icon-theme papirus-folders

    # Fonts
    apple-fonts-git
    ttf-material-symbols-variable
    ttf-jetbrains-mono-nerd 
    ttf-geist-mono-nerd 
    ttf-rubik ttf-roboto 
    ttf-roboto-mono noto-fonts noto-fonts-emoji

    # Apps
    pcloud-drive zen-browser-bin helium-browser-bin obsidian visual-studio-code-bin neovim spotify spicetify-cli
)

# Append selective shell packages based on user prompt
if [ "$UI_CHOICE" -eq 1 ]; then
    echo -e "${BLUE}Configuring Quickshell environment...${NC}"
    DESKTOP_PKGS+=(quickshell)
else
    echo -e "${BLUE}Configuring Classic Ecosystem environment...${NC}"
    DESKTOP_PKGS+=(waybar swaync rofi-lbonn-wayland-git wlogout)
fi

yay -S --needed --noconfirm "${DESKTOP_PKGS[@]}"

# 6. Set Zsh as Default Shell & Clean Up Plugin Repos
echo -e "${GREEN}[6/8] Configuring Zsh as default shell & cleaning plugin git trees...${NC}"
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

if [ -d "$HOME/.config/zsh/plugins" ]; then
    find "$HOME/.config/zsh/plugins" -mindepth 2 -maxdepth 2 -type d -name ".git" -exec rm -rf {} +
fi

# 7. Enable Services
echo -e "${GREEN}[7/8] Enabling NetworkManager service...${NC}"
sudo systemctl enable --now NetworkManager.service 2>/dev/null || true

echo -e "\n${BLUE}===========================================${NC}"
echo -e "${GREEN} Installation Complete! ${NC}"
echo -e "${BLUE} Pre-install configurations backed up to: ${YELLOW}${BACKUP_DIR}${NC}"
echo -e "${BLUE}===========================================${NC}"