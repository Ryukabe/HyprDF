-- Autostart services hook
hl.on("hyprland.start", function()
    -- Polkit Authentication Agent
    hl.exec_once("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    
    -- System tools
    hl.exec_once("awww-daemon")
    hl.exec_once("hyprctl setcursor macOS 24")
    
    -- Launch Quickshell once cleanly with OpenGL backend
    hl.exec_once("quickshell")

    hl.exec_once("swaync")
    hl.exec_once("hypridle")
    
    -- Applications
    hl.exec_once("pcloud")
    
    -- Clipboard Management
    hl.exec_once("wl-paste --type text --watch cliphist store")
    hl.exec_once("wl-paste --type image --watch cliphist store")
    hl.exec_once("wl-clip-persist --clipboard regular")
end)