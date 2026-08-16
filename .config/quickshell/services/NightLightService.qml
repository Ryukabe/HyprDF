pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    readonly property string scriptPath: "~/.config/hypr/scripts/nightlight.sh"
    property bool enabled: false

    Process {
        id: pgrepProc
        command: ["pgrep", "-x", "hyprsunset"]
        running: true
        onExited: (exitCode) => {
            root.enabled = (exitCode === 0)
        }
    }

    Process {
        id: toggleProc
        command: ["bash", "-c", root.scriptPath]
    }

    Timer {
        id: pollTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: pgrepProc.running = true
    }

    Timer {
        id: verifyTimer
        interval: 800
        repeat: false
        onTriggered: pgrepProc.running = true
    }

    function toggle() {
        toggleProc.running = true
        // optimistic flip for instant UI feedback, corrected by verifyTimer
        // shortly after in case the script's own detection disagrees
        root.enabled = !root.enabled
        verifyTimer.restart()
    }
}