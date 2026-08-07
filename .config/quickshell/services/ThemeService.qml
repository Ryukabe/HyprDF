pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string colorsPath: Quickshell.env("HOME") + "/.config/quickshell/colors/colors.json"

    property color bg: "#0f1419"
    property color fg: "#e6e1cf"
    property color fgMuted: "#5c6773"
    property color bgSurface: "#131721"
    property color bgSurfaceMica: "#131721"
    property color surface: "#131721"
    property color subtext: "#5c6773"
    property color border: "#2d3640"
    property color accent: "#73d0ff"

    // Watches the colors file on disk and reloads whenever apply-theme.sh
    // writes a new one — this is what makes switching "live"
    FileView {
        id: colorsFile
        path: root.colorsPath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.applyJson(JSON.parse(colorsFile.text()))
    }

    function applyJson(json) {
        root.bg = json.bg ?? root.bg
        root.fg = json.fg ?? root.fg
        root.fgMuted = json.fgMuted ?? root.fgMuted
        root.bgSurface = json.bgSurface ?? root.bgSurface
        root.surface = json.surface ?? root.surface
        root.subtext = json.subtext ?? root.subtext
        root.border = json.border ?? root.border
        root.accent = json.accent ?? root.accent
    }

    // Called by the theme switcher page when the user taps a swatch
    function applyTheme(themeName) {
        applyThemeProcess.command = ["bash", Quickshell.env("HOME") + "/apply-theme.sh", themeName]
        applyThemeProcess.running = true
    }

    Process {
        id: applyThemeProcess
    }
}