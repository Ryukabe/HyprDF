local M = {}

-- Apps
M.terminal      = "kitty"
M.fileManager   = "nautilus"
M.browser       = "zen-browser"
M.editor        = "code"
M.noteapp       = "obsidian"
M.music         = "spotify"

-- Rofi
M.applauncher   = "pkill rofi || rofi -show drun -theme ~/.config/rofi/applauncher.rasi"
M.menu          = "pkill rofi || ~/.config/rofi/scripts/appearance.sh"

-- System
M.waybar        = "~/.config/waybar/scripts/relaunch.sh"
M.swaync        = "~/.config/swaync/Scripts/reload_nc.sh"
M.wlogout       = "~/.config/wlogout/scripts/wlogout.sh"
M.hyprlock      = "hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf"
M.clipboard     = "~/.config/hypr/scripts/clipboard-toggle.sh"
M.themeSwitcher = "~/.config/themes/theme-switcher.sh"

return M