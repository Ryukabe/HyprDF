hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/waybar/scripts/launch.sh")
    hl.exec_cmd("swaync")
    hl.exec_cmd("kdeconnectd")
    hl.exec_cmd("hyprctl setcursor macOS 24")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hypridle")
-- Alt + Tab menu
    hl.exec_cmd("snappy-switcher --daemon")
-- Clipboard 
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
end)