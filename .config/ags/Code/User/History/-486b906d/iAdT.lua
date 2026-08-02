--------------------
---- MONITORS ----
--------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "1366x768@60",
    position = "0x0",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "nautilus"
local browser     = "zen-browser"
local editor      = "code"

local applauncher  = "pkill rofi || rofi -show drun -theme ~/.config/rofi/applauncher.rasi"
local menu         = "pkill rofi || ~/.config/rofi/scripts/appearance.sh"
local waybar       = "~/.config/waybar/scripts/relaunch.sh"
local swaync       = "~/.config/swaync/Scripts/reload_nc.sh"
local wlogout      = "~/.config/wlogout/scripts/wlogout.sh"
local hyprlock     = "hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf"
local clipboard    = "~/.config/hypr/scripts/clipboard-toggle.sh"
local themeSwitcher = "~/.config/themes/theme-switcher.sh"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/waybar/scripts/launch.sh")
    hl.exec_cmd("swaync")
    hl.exec_cmd("kdeconnectd")
    hl.exec_cmd("hyprctl setcursor macOS 24")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("hypridle")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE",                    "24")
hl.env("HYPRCURSOR_SIZE",                 "24")

-- Toolkit Backend
hl.env("GDK_BACKEND",                     "wayland,x11,*")
hl.env("QT_QPA_PLATFORM",                 "wayland;xcb")
hl.env("SDL_VIDEODRIVER",                 "wayland")
hl.env("CLUTTER_BACKEND",                 "wayland")

-- XDG Specification
hl.env("XDG_CURRENT_DESKTOP",             "Hyprland")
hl.env("XDG_SESSION_TYPE",                "wayland")
hl.env("XDG_SESSION_DESKTOP",             "Hyprland")

-- Qt
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",     "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME",            "qt5ct")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            -- $blue and $bg4 — replace with your actual color values
            active_border   = "rgba(89b4faee)",  -- $blue
            inactive_border = "rgba(45475aaa)",  -- $bg4
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 4,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 10,
            render_power = 2,
            color        = "rgba(0a0a0add)",
        },

        blur = {
            enabled          = true,
            size             = 5,
            passes           = 3,
            ignore_opacity   = true,
            noise            = 0.08,
            contrast         = 1,
            brightness       = 0.8,
            xray             = false,
            new_optimizations = true,
        },
    },

    animations = {
        enabled = true,
    },
})


-- Animations (Apple-style — source was apple.conf)
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "easy",        style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",      style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


--------------------
---- LAYOUT ----
--------------------

hl.config({
    dwindle = {
        pseudotile     = true,
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })

-- Per-device config
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.3,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Apps
hl.bind(mainMod .. " + RETURN",       hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F",            hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B",            hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E",            hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + O",            hl.dsp.exec_cmd('obsidian --vault "My Vault"'))
hl.bind(mainMod .. " + S",            hl.dsp.exec_cmd("spotify"))

-- System
hl.bind("ALT + SPACE",                hl.dsp.exec_cmd(applauncher))
hl.bind(mainMod .. " + ALT + SPACE",  hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F4",           hl.dsp.exec_cmd(wlogout))
hl.bind(mainMod .. " + L",            hl.dsp.exec_cmd(hyprlock))
hl.bind(mainMod .. " + SHIFT + R",    hl.dsp.exec_cmd(waybar))
hl.bind(mainMod .. " + SHIFT + A",    hl.dsp.exec_cmd(swaync))
hl.bind(mainMod .. " + A",            hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + F5",           hl.dsp.exec_cmd("~/.config/hypr/scripts/nightlight.sh"))
hl.bind(mainMod .. " + V",            hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + SHIFT + V",    hl.dsp.exec_cmd("cliphist wipe"))
hl.bind(mainMod .. " + SHIFT + T",    hl.dsp.exec_cmd(themeSwitcher))

-- Screenshots
hl.bind(mainMod .. " + Print",        hl.dsp.exec_cmd("hyprshot -m output -m eDP-1"))
hl.bind(mainMod .. " + SHIFT + Print",hl.dsp.exec_cmd("hyprshot -m region"))

-- Window management
hl.bind(mainMod .. " + SHIFT + F",    hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + P",    hl.dsp.window.pseudo())
hl.bind("ALT + F4",                   hl.dsp.window.close())

-- Focus
hl.bind(mainMod .. " + left",         hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",        hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",           hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",         hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mouse
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Brightness & Volume
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Media
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOW RULES ----
--------------------------------

-- Suppress maximize for all windows
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland drag issues
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- hyprland-run popup
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Open apps on specific workspaces
hl.window_rule({
    match     = { class = "^(zen|firefox|brave|chromium|chromium%-browser|chrome%-browser|microsoft%-edge)$" },
    workspace = 1,
    silent    = true,
})
hl.window_rule({
    match     = { class = "^(cursor|code|codium)$" },
    workspace = 2,
    silent    = true,
})
hl.window_rule({
    match     = { class = "^(org%.gnome%.Nautilus|dolphin|thunar)$" },
    workspace = 3,
    silent    = true,
})
hl.window_rule({
    match     = { class = "^(notion|notion%-calendar|obsidian)$" },
    workspace = 4,
    silent    = true,
})
hl.window_rule({
    match     = { class = "^(spotify)$" },
    workspace = 5,
    silent    = true,
})

-- File picker
hl.window_rule({
    name   = "file-picker",
    match  = { title = "^(Open File|Open Folder|Open|Save|Save As|Export|Choose File|Rename|script%-fu)$" },
    float  = true,
    center = true,
    size   = "600 300",
})

-- xdg-desktop-portal-gtk
hl.window_rule({
    name   = "xdg-desktop-portal-gtk",
    match  = { class = "xdg-desktop-portal-gtk" },
    float  = true,
    center = true,
    size   = "800 500",
})

-- xdg-desktop-portal-hyprland
hl.window_rule({
    name   = "xdg-desktop-portal-hyprland",
    match  = { class = "xdg-desktop-portal-hyprland" },
    float  = true,
    center = true,
    size   = "900 600",
})

-- Float all modal/dialog windows
hl.window_rule({
    match  = { modal = true },
    float  = true,
    center = true,
})

-- Font switcher
hl.window_rule({
    name   = "font-switcher",
    match  = { title = "font-switcher" },
    float  = true,
    center = true,
    size   = "200 300",
})

-- Picture-in-Picture
hl.window_rule({
    name             = "Picture-in-Picture",
    match            = { title = "^(Picture%-in%-Picture)$" },
    float            = true,
    pin              = true,
    no_initial_focus = true,
    size             = "540 300",
    move             = "850 450",
    opacity          = 1.0,
})

-- File managers
hl.window_rule({
    name        = "file-explorer",
    match       = { class = "^(org%.gnome%.Nautilus|thunar|dolphin)$" },
    float       = true,
    center      = true,
    size        = "1100 600",
    border_size = 0,
})

-- Code editors
hl.window_rule({
    name        = "code-editors",
    match       = { class = "^(code|codium)$" },
    float       = true,
    center      = true,
    size        = "1200 650",
    border_size = 0,
})

-- Terminal emulators
hl.window_rule({
    name   = "terminal-emulators",
    match  = { class = "^(kitty|ghoty|arlacity)$" },
    float  = true,
    center = true,
    size   = "1100 600",
})


--------------------------------
---- LAYER RULES ----
--------------------------------

hl.layer_rule({
    match   = { namespace = "waybar" },
    no_anim = true,
})

hl.layer_rule({
    match         = { namespace = "swaync-control-center" },
    blur          = true,
    ignore_alpha  = 0.5,
})
hl.layer_rule({
    match         = { namespace = "swaync-notification-window" },
    blur          = true,
    ignore_alpha  = 0.5,
})

hl.layer_rule({
    match     = { namespace = "notification-popups" },
    animation = "fade",
})

hl.layer_rule({
    match     = { namespace = "logout_dialog" },
    animation = "fade",
    blur      = true,
})

hl.layer_rule({
    match     = { namespace = "rofi" },
    animation = "popin 80%",
})