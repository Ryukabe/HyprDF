pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    readonly property string device: "wlan0"
    property bool enabled: false
    property string ssid: ""
    property bool hasInternet: false

    Process {
        id: deviceProc
        command: ["iwctl", "device", root.device, "show"]
        stdout: SplitParser { onRead: data => root._parseDeviceLine(data) }
    }

    Process {
        id: stationProc
        command: ["iwctl", "station", root.device, "show"]
        stdout: SplitParser { onRead: data => root._parseStationLine(data) }
    }

    Process {
        id: pingProc
        command: ["ping", "-c", "1", "-W", "1", "1.1.1.1"]
        onExited: (code, status) => {
            root.hasInternet = (code === 0)
        }
    }

    Process {
        id: toggleProc
    }

    Timer {
        id: pollTimer
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Timer {
        id: verifyTimer
        interval: 800
        repeat: false
        onTriggered: root.refresh()
    }

    Component.onCompleted: {
        root.refresh()
    }

    function refresh() {
        if (!deviceProc.running) deviceProc.running = true
        if (!stationProc.running) stationProc.running = true
        if (root.enabled && !pingProc.running) pingProc.running = true
    }

    function _parseDeviceLine(line) {
        const m = line.match(/Powered\s+(on|off)/i)
        if (m) {
            root.enabled = m[1].toLowerCase() === "on"
        }
    }

    function _parseStationLine(line) {
        const netMatch = line.match(/^\s*Connected network\s+(.+)/i)
        if (netMatch) {
            root.ssid = netMatch[1].trim()
            if (!pingProc.running) pingProc.running = true
            return
        }
        const stateMatch = line.match(/^\s*State\s+(\S+)/i)
        if (stateMatch && stateMatch[1].toLowerCase() !== "connected") {
            root.ssid = ""
            root.hasInternet = false
        }
    }

    function toggle() {
        const newState = root.enabled ? "off" : "on"
        toggleProc.command = ["iwctl", "device", root.device, "set-property", "Powered", newState]
        toggleProc.running = true

        root.enabled = !root.enabled
        if (!root.enabled) {
            root.ssid = ""
            root.hasInternet = false
        }
        verifyTimer.restart()
    }
}