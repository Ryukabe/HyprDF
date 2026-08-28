pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property string activePage: "clock"
    property bool focusModeEnabled: false
    property bool ignoreHover: false

    // ---- Focus mode ----
    property string activeFocusMode: "Do Not Disturb"
    readonly property bool isWorkMode: focusModeEnabled && activeFocusMode === "Work"

    property Timer hoverResetTimer: Timer {
        interval: 300
        repeat: false
        onTriggered: root.ignoreHover = false
    }

    property Timer flashTimer: Timer {
        interval: 1500
        onTriggered: root.activePage = "clock"
    }

    function showPage(page) {
        flashTimer.stop()
        if (page === "clock") {
            root.ignoreHover = true
            hoverResetTimer.restart()
        }
        root.activePage = page
    }

    function flashPage(page) {
        root.activePage = page
        flashTimer.interval = 1500
        flashTimer.restart()
    }

    function flashPageFor(page, durationMs) {
        root.activePage = page
        flashTimer.interval = durationMs
        flashTimer.restart()
    }

    function togglePage(page) {
        if (root.activePage === page) {
            showPage("clock")
        } else {
            showPage(page)
        }
    }

    // Only Do Not Disturb has a confirmed real backend (mako) right now.
    // Work/Personal/Sleep/Gaming intentionally do nothing here until their
    // actual backends (animation toggles, bar style, etc.) are built and confirmed.
    function _applyBackendForMode(mode, enabled) {
        if (mode === "Do Not Disturb") {
            dndProcess.command = enabled
                ? ["makoctl", "mode", "-a", "do-not-disturb"]
                : ["makoctl", "mode", "-r", "do-not-disturb"]
            dndProcess.running = true
        }
    }

    // Quick on/off — flips whatever mode is currently selected.
    function toggleFocusMode() {
        focusModeEnabled = !focusModeEnabled
        _applyBackendForMode(activeFocusMode, focusModeEnabled)
    }

    // Selects a specific preset by name. Tapping the already-active preset
    // again turns Focus off (same preset stays remembered for next time).
    function setFocusMode(name) {
        if (root.focusModeEnabled && root.activeFocusMode === name) {
            toggleFocusMode()
            return
        }
        if (root.focusModeEnabled) {
            _applyBackendForMode(root.activeFocusMode, false)
        }
        root.activeFocusMode = name
        root.focusModeEnabled = true
        _applyBackendForMode(name, true)
    }

    property Process dndProcess: Process {
        id: dndProcess
    }

    // Add to services/ShellState.qml inside the togglePage/showPage handling
    function toggleClipboard() {
        togglePage("clipboard")
    }
}