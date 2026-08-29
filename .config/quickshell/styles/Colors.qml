// styles/Colors.qml
pragma Singleton
import QtQuick
import Quickshell.Io
import "../services"

Item {
    id: root

    property var palette: ({})
    property bool loaded: false
    property bool lightModeEnabled: false

    // Default fallbacks used only when keys are missing from theme JSON
    readonly property var _safetyPalette: ({
        isLight: false,
        background: "#0f1419",
        foreground: "#e6e1cf",
        fgMuted: "#5c6773",
        surface: "#131721",
        border: "#2d3640",
        accent: "#73d0ff",
        red: "#f07178",
        green: "#bae67e",
        yellow: "#ffd580",
        blue: "#73d0ff",
        purple: "#d4bfff",
        cyan: "#95e6cb"
    })

    FileView {
        id: themeFile
        path: ThemeService.currentThemeJsonPath
        watchChanges: true

        onLoaded: {
            try {
                root.palette = JSON.parse(text());
                root.loaded = true;
            } catch (e) {
                console.log("[Colors] failed to parse quickshell.json:", e);
                root.palette = ({});
                root.loaded = false;
            }
        }
        onLoadFailed: error => {
            console.log("[Colors] failed to load theme file:", error);
            root.palette = ({});
            root.loaded = false;
        }
        onFileChanged: reload()
    }

    readonly property bool themeHasBothVariants: root.loaded
        && root.palette.dark !== undefined
        && root.palette.light !== undefined

    readonly property var activePalette: {
        if (!root.loaded) return ({});
        if (root.themeHasBothVariants) {
            return root.lightModeEnabled ? root.palette.light : root.palette.dark;
        }
        return root.palette;
    }

    // Quietly fetches values without console error logs
    function pick(key) {
        var val = root.activePalette[key];
        if (val === undefined) {
            return root._safetyPalette[key] !== undefined ? root._safetyPalette[key] : "#000000";
        }
        return val;
    }

    function toggleLightMode() {
        if (root.themeHasBothVariants) {
            root.lightModeEnabled = !root.lightModeEnabled;
        }
    }

    readonly property bool darkMode: !pick("isLight")

    readonly property color bg: pick("background")
    readonly property color fg: pick("foreground")
    readonly property color fgMuted: pick("fgMuted")
    readonly property color bgSurface: pick("surface")
    readonly property color surface: pick("surface")
    readonly property color subtext: pick("fgMuted")
    readonly property color border: pick("border")
    readonly property color accent: pick("accent")

    readonly property color red: pick("red")
    readonly property color green: pick("green")
    readonly property color yellow: pick("yellow")
    readonly property color blue: pick("blue")
    readonly property color purple: pick("purple")
    readonly property color cyan: pick("cyan")

    readonly property color black: darkMode ? bgSurface : border
    readonly property color white: darkMode ? "#ffffff" : bgSurface

    readonly property color brightBlack: darkMode ? fgMuted : border
    readonly property color brightRed: red
    readonly property color brightGreen: green
    readonly property color brightYellow: yellow
    readonly property color brightBlue: blue
    readonly property color brightPurple: purple
    readonly property color brightCyan: cyan
    readonly property color brightWhite: white

    readonly property real micaAlpha: 1.0
    readonly property color bgMica: Qt.rgba(bg.r, bg.g, bg.b, micaAlpha)
    readonly property color bgSurfaceMica: Qt.rgba(bgSurface.r, bgSurface.g, bgSurface.b, micaAlpha)

    // ================= Live System Sync =================
    function _toHex(c) {
        function h(v) { var s = Math.round(v * 255).toString(16); return s.length < 2 ? "0" + s : s; }
        return "#" + h(c.r) + h(c.g) + h(c.b);
    }

    onActivePaletteChanged: {
        if (!root.loaded) return;
        root._pushHyprland();
        root._pushKitty();
        root._pushVSCode();
    }

    // ---- Hyprland Borders ----
    Process { id: hyprActiveBorderProc }
    Process { id: hyprInactiveBorderProc }

    function _pushHyprland() {
        hyprActiveBorderProc.command = ["hyprctl", "keyword", "general:col.active_border", "rgba(" + root._toHex(root.accent).substring(1) + "ff)"]
        hyprActiveBorderProc.running = true

        hyprInactiveBorderProc.command = ["hyprctl", "keyword", "general:col.inactive_border", "rgba(" + root._toHex(root.border).substring(1) + "ff)"]
        hyprInactiveBorderProc.running = true
    }

    // ---- Kitty Terminal ----
    Process { id: kittyProc }

    function _pushKitty() {
        kittyProc.command = [
            "kitty", "@", "--to", "unix:/tmp/kitty-theme-socket", "set-colors", "-a",
            "background=" + root._toHex(root.bg),
            "foreground=" + root._toHex(root.fg),
            "cursor=" + root._toHex(root.accent),
            "selection_background=" + root._toHex(root.accent),
            "selection_foreground=" + root._toHex(root.bg),
            "color0=" + root._toHex(root.black),
            "color1=" + root._toHex(root.red),
            "color2=" + root._toHex(root.green),
            "color3=" + root._toHex(root.yellow),
            "color4=" + root._toHex(root.blue),
            "color5=" + root._toHex(root.purple),
            "color6=" + root._toHex(root.cyan),
            "color7=" + root._toHex(root.fgMuted),
            "color8=" + root._toHex(root.brightBlack),
            "color9=" + root._toHex(root.brightRed),
            "color10=" + root._toHex(root.brightGreen),
            "color11=" + root._toHex(root.brightYellow),
            "color12=" + root._toHex(root.brightBlue),
            "color13=" + root._toHex(root.brightPurple),
            "color14=" + root._toHex(root.brightCyan),
            "color15=" + root._toHex(root.brightWhite)
        ]
        kittyProc.running = true
    }

// ---- VS Code Integration ----
    Process { id: vscodeProc }

    function _pushVSCode() {
        var settingsPath = "$HOME/.config/Code/User/settings.json"
        
        // Pick native theme name from active palette variant (dark or light)
        var nativeVsCodeTheme = root.activePalette ? root.activePalette.vscodeTheme : undefined
        var bashCommand = ""

        if (nativeVsCodeTheme !== undefined && nativeVsCodeTheme !== "") {
            // Native Extension Theme: Sets workbench.colorTheme and clears custom overrides
            bashCommand = 'jq \'.["workbench.colorTheme"] = "' + nativeVsCodeTheme + '" | .["workbench.colorCustomizations"] = {}\' "' 
                        + settingsPath + '" > /tmp/vscode-settings.tmp && mv /tmp/vscode-settings.tmp "' + settingsPath + '"'
        } else {
            // Fallback: Generates dynamic colorCustomizations using active palette hex tokens
            var patch = {
                "editor.background": root._toHex(root.bg),
                "sideBar.background": root._toHex(root.bgSurface),
                "activityBar.background": root._toHex(root.bgSurface),
                "statusBar.background": root._toHex(root.bgSurface),
                "titleBar.activeBackground": root._toHex(root.bgSurface),
                "focusBorder": root._toHex(root.accent),
                "textLink.foreground": root._toHex(root.accent)
            }
            var patchJson = JSON.stringify(patch)

            bashCommand = 'printf "%s" \'' + patchJson + '\' | jq --slurpfile patch /dev/stdin \'.["workbench.colorCustomizations"] = ((.["workbench.colorCustomizations"] // {}) + $patch[0])\' "' 
                        + settingsPath + '" > /tmp/vscode-settings.tmp && mv /tmp/vscode-settings.tmp "' + settingsPath + '"'
        }

        vscodeProc.command = ["bash", "-c", bashCommand]
        vscodeProc.running = true
    }
}