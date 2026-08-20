pragma Singleton
import QtQuick

QtObject {
    id: root

    property string activePage: "clock"
    property bool focusModeEnabled: false
    property bool ignoreHover: false

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

    function toggleFocusMode() {
        root.focusModeEnabled = !root.focusModeEnabled
    }
}