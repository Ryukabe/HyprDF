pragma Singleton
import QtQuick

QtObject {
    id: root

    property string activePage: "clock"
    property bool focusModeEnabled: false
    

    property Timer flashTimer: Timer {
        interval: 1500
        onTriggered: root.activePage = "clock"
    }

    function showPage(page) {
        flashTimer.stop()
        root.activePage = page
    }

    function flashPage(page) {
        root.activePage = page
        flashTimer.interval = 1500
        flashTimer.restart()
    }

    // like flashPage, but with a caller-specified duration —
    // used by notifications, since toast length varies
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