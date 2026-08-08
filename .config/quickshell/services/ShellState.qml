pragma Singleton
import QtQuick

QtObject {
    id: root

    property string activePage: "clock"

    property Timer flashTimer: Timer {
        interval: 1500
        onTriggered: root.activePage = "clock"
    }

    // permanent open (status, media, power, control, launcher) — stays until dismissed
    function showPage(page) {
        flashTimer.stop()
        root.activePage = page
    }

    // temporary open (volume, brightness) — auto-reverts to clock after interval
    function flashPage(page) {
        root.activePage = page
        flashTimer.restart()
    }
}