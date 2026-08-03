-- Autostart services hook
hl.on("hyprland.start", function()
    -- Polkit Authentication Agent
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    
    -- System tools
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hyprctl setcursor macOS 24")
    hl.exec_cmd("$HOME/.config/waybar/scripts/reload.sh")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    
    -- Applications
    -- hl.exec_cmd("kdeconnect")
    hl.exec_cmd("pcloud")
    
    -- Alt + Tab Menu Daemon
    --hl.exec_cmd("snappy-switcher --daemon")
    
    -- Clipboard Management
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
end)