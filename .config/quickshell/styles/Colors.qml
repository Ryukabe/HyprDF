pragma Singleton
import QtQuick

QtObject {
    id: root

    // Flip this to switch the whole shell between palettes.
    property bool darkMode: true

    function toggle() {
        root.darkMode = !root.darkMode
    }

    // ---- Dark palette (your original Ayu Dark) ----
    readonly property color darkBg: "#0f1419"
    readonly property color darkFg: "#e6e1cf"
    readonly property color darkFgMuted: "#5c6773"
    readonly property color darkBgSurface: "#131721"
    readonly property color darkSurface: "#131721"
    readonly property color darkSubtext: "#5c6773"
    readonly property color darkBorder: "#2d3640"
    readonly property color darkAccent: "#73d0ff"

    // ---- Light palette (Ayu Light–inspired — approximate, adjust freely) ----
    readonly property color lightBg: "#fafafa"
    readonly property color lightFg: "#5c6773"
    readonly property color lightFgMuted: "#828c99"
    readonly property color lightBgSurface: "#f3f4f5"
    readonly property color lightSurface: "#f3f4f5"
    readonly property color lightSubtext: "#828c99"
    readonly property color lightBorder: "#e7e8e9"
    readonly property color lightAccent: "#399ee6"

    // ---- Active palette — every file below reads these, unchanged ----
    readonly property color bg: darkMode ? darkBg : lightBg
    readonly property color fg: darkMode ? darkFg : lightFg
    readonly property color fgMuted: darkMode ? darkFgMuted : lightFgMuted
    readonly property color bgSurface: darkMode ? darkBgSurface : lightBgSurface
    readonly property color surface: darkMode ? darkSurface : lightSurface
    readonly property color subtext: darkMode ? darkSubtext : lightSubtext
    readonly property color border: darkMode ? darkBorder : lightBorder
    readonly property color accent: darkMode ? darkAccent : lightAccent

    // ---- ANSI-ish accents (unchanged across modes for now) ----
    readonly property color black: darkMode ? "#131721" : "#e7e8e9"
    readonly property color red: "#f07178"
    readonly property color green: "#bae67e"
    readonly property color yellow: "#ffd580"
    readonly property color blue: "#73d0ff"
    readonly property color purple: "#d4bfff"
    readonly property color cyan: "#95e6cb"
    readonly property color white: darkMode ? "#ffffff" : "#131721"

    readonly property color brightBlack: darkMode ? "#5c6773" : "#abb0b6"
    readonly property color brightRed: "#f07178"
    readonly property color brightGreen: "#bae67e"
    readonly property color brightYellow: "#ffd580"
    readonly property color brightBlue: "#73d0ff"
    readonly property color brightPurple: "#d4bfff"
    readonly property color brightCyan: "#95e6cb"
    readonly property color brightWhite: darkMode ? "#ffffff" : "#131721"

    // ---- Mica effect — see below ----
    readonly property real micaAlpha: 0.7
    readonly property color bgMica: Qt.rgba(bg.r, bg.g, bg.b, micaAlpha)
    readonly property color bgSurfaceMica: Qt.rgba(bgSurface.r, bgSurface.g, bgSurface.b, micaAlpha)
}