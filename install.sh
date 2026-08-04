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
    hyprland                    # the Wayland compositor / window manager itself
    xdg-desktop-portal-hyprland # lets apps talk to Hyprland for screen share, file pickers, etc.
    xdg-desktop-portal-gtk      # GTK backend for the same desktop portal system
    qt5-wayland                 # native Wayland support for Qt5 apps
    qt6-wayland                 # native Wayland support for Qt6 apps
    polkit-gnome                # authentication agent — shows the password prompt for privileged actions
)
yay -S --needed --noconfirm "${CORE_PKGS[@]}"

# 5. Apps, Utilities, GTK Switcher, Cursors & Fonts
echo -e "${GREEN}[5/6] Installing Apps, Utilities, Themes, Cursors, and Fonts...${NC}"
DESKTOP_PKGS=(
    # File Managers & GTK Tools
    nautilus             # GNOME's file manager ("Files")
    thunar               # XFCE's lightweight file manager — good alt/companion to Nautilus
    file-roller           # archive manager for zip/tar/etc (integrates with Nautilus)
    gvfs                  # virtual filesystem layer — lets file managers mount trash, network shares, MTP devices, etc.
    gvfs-smb              # adds SMB/Windows network share support to gvfs
    nwg-look              # GTK theme/icon/cursor switcher GUI for wlroots-based compositors like Hyprland
    ristretto              # XFCE's lightweight image/photo viewer

    # Screenshots, Clipboard & Utilities
    hyprshot             # screenshot tool built for Hyprland (region/window/screen capture)
    wl-clipboard          # command-line copy/paste utilities for Wayland
    wl-clip-persist       # keeps clipboard contents available after the source app closes
    cliphist              # clipboard history manager for Wayland
    #snappy-switcher      # Alt-Tab switcher

    # Bar, Wallpaper, Notifications
    waybar                # the status bar (workspaces, clock, tray, etc.)
    awww                  # wallpaper daemon for Wayland (likely meant "swww" — see note below)
    hypridle              # idle daemon — handles screen dimming/locking on inactivity
    swaync                # notification daemon + notification center for Wayland

    # Audio & Media Controls
    pipewire              # modern audio/video server, replaces PulseAudio/JACK
    pipewire-audio        # PipeWire's audio session handling
    pipewire-pulse        # PulseAudio compatibility layer on top of PipeWire
    wireplumber           # session/policy manager for PipeWire
    pavucontrol           # GUI volume mixer (per-app volume control)
    brightnessctl         # command-line screen brightness control

    # System Utilities
    fastfetch             # fast system info fetch tool (like neofetch)
    network-manager-applet # tray icon/GUI for connecting to Wi-Fi and networks
    kitty                 # GPU-accelerated terminal emulator
    kdeconnect            # sync notifications, files, and clipboard between phone and PC

    # Cursors, Icons & Themes
    apple-cursor          # Apple-style cursor theme (your preferred one)
    papirus-icon-theme    # popular flat icon theme
    papirus-folders       # tool to recolor Papirus folder icons

    # Fonts (JetBrains Mono, Geist Mono, Rubik, Roboto, Apple SF Pro)
    ttf-jetbrains-mono-nerd # JetBrains Mono with Nerd Font icon glyphs (good for terminal/coding)
    ttf-geist-mono-nerd    # Geist Mono with Nerd Font icon glyphs
    ttf-rubik              # Rubik sans-serif font family
    ttf-roboto             # Roboto sans-serif font family
    ttf-roboto-mono        # Roboto's monospace variant
    noto-fonts             # broad Unicode/language coverage font family
    noto-fonts-emoji       # emoji glyph support
    apple-fonts-git        # Apple SF Pro from AUR

    # Cloud Storage
    pcloud-drive           # AUR package for the official pCloud desktop sync client

    # Browsers
    zen-browser-bin        # Firefox-based browser focused on a calm, minimal UI
    helium-browser-bin     # ungoogled Chromium fork, stripped-down and privacy-focused

    # Notes & Editors
    obsidian               # your notes app — markdown-based knowledge base
    visual-studio-code-bin # VS Code (the official Microsoft build, not the open-source VSCodium rebuild)
    neovim                 # modern, extensible vim-based text editor — base for your NvChad setup

    # Music
    spotify                # Spotify desktop client
    spicetify-cli           # CLI tool to customize/theme the Spotify client (what you meant by "specify")
)

yay -S --needed --noconfirm "${DESKTOP_PKGS[@]}"

# NvChad is not a package — it's a Neovim config, installed via git clone.
# Uncomment to auto-install it (back up any existing config first):
# git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

# 6. Enable Services
echo -e "${GREEN}[6/6] Enabling NetworkManager service...${NC}"
sudo systemctl enable --now NetworkManager.service 2>/dev/null || true

echo -e "\n${BLUE}===========================================${NC}"
echo -e "${GREEN} Installation Complete! ${NC}"
echo -e "${BLUE}===========================================${NC}"