// styles/Colors.qml
pragma Singleton
import QtQuick
import Quickshell.Io
import "../services"

Item {
    id: root

    readonly property bool fallbackIsLight: false
    readonly property color fallbackBg: "#0f1419"
    readonly property color fallbackFg: "#e6e1cf"
    readonly property color fallbackFgMuted: "#5c6773"
    readonly property color fallbackSurface: "#131721"
    readonly property color fallbackBorder: "#2d3640"
    readonly property color fallbackAccent: "#73d0ff"
    readonly property color fallbackRed: "#f07178"
    readonly property color fallbackGreen: "#bae67e"
    readonly property color fallbackYellow: "#ffd580"
    readonly property color fallbackBlue: "#73d0ff"
    readonly property color fallbackPurple: "#d4bfff"
    readonly property color fallbackCyan: "#95e6cb"

    property var palette: ({})
    property bool loaded: false

    // User's light/dark preference — only meaningful for themes that
    // actually ship both variants (see themeHasBothVariants below).
    property bool lightModeEnabled: false

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

    // True only if this theme's JSON has the new { "dark": {...}, "light": {...} }
    // wrapper shape. Old flat-format themes (still most of them) report false here,
    // and the toggle has no effect for those — there's nothing to switch to yet.
    readonly property bool themeHasBothVariants: root.loaded
        && root.palette.dark !== undefined
        && root.palette.light !== undefined

    readonly property var activePalette: {
        if (!root.loaded) return ({});
        if (root.themeHasBothVariants) {
            return root.lightModeEnabled ? root.palette.light : root.palette.dark;
        }
        return root.palette; // old flat single-variant format
    }

    function pick(key, fallback) {
        return (root.loaded && root.activePalette[key] !== undefined) ? root.activePalette[key] : fallback;
    }

    function toggleLightMode() {
        if (root.themeHasBothVariants) {
            root.lightModeEnabled = !root.lightModeEnabled;
        }
        // else: no-op — this theme has no light variant to switch to yet
    }

    readonly property bool darkMode: !pick("isLight", root.fallbackIsLight)

    readonly property color bg: pick("background", fallbackBg)
    readonly property color fg: pick("foreground", fallbackFg)
    readonly property color fgMuted: pick("fgMuted", fallbackFgMuted)
    readonly property color bgSurface: pick("surface", fallbackSurface)
    readonly property color surface: pick("surface", fallbackSurface)
    readonly property color subtext: pick("fgMuted", fallbackFgMuted)
    readonly property color border: pick("border", fallbackBorder)
    readonly property color accent: pick("accent", fallbackAccent)

    readonly property color red: pick("red", fallbackRed)
    readonly property color green: pick("green", fallbackGreen)
    readonly property color yellow: pick("yellow", fallbackYellow)
    readonly property color blue: pick("blue", fallbackBlue)
    readonly property color purple: pick("purple", fallbackPurple)
    readonly property color cyan: pick("cyan", fallbackCyan)

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
}