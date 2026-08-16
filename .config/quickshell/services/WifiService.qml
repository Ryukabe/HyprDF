pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    readonly property string device: "wlan0"
    property bool enabled: false
    property string ssid: ""

    Process {
        id: deviceProc
        command: ["iwctl", "device", "show", root.device]
        running: true
        stdout: SplitParser { onRead: data => root._parseDeviceLine(data) }
    }

    Process {
        id: stationProc
        command: ["iwctl", "station", root.device, "show"]
        running: true
        stdout: SplitParser { onRead: data => root._parseStationLine(data) }
    }

    Process {
        id: toggleProc
    }

    Timer {
        id: pollTimer
        interval: 5000
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

    function refresh() {
        deviceProc.running = true
        stationProc.running = true
    }

    function _parseDeviceLine(line) {
        const m = line.match(/Powered\s+(on|off)/i)
        if (m) root.enabled = m[1].toLowerCase() === "on"
    }

    function _parseStationLine(line) {
        const netMatch = line.match(/^\s*Connected network\s+(.+)/i)
        if (netMatch) {
            root.ssid = netMatch[1].trim()
            return
        }
        const stateMatch = line.match(/^\s*State\s+(\S+)/i)
        if (stateMatch && stateMatch[1].toLowerCase() !== "connected") {
            root.ssid = ""
        }
    }

    function toggle() {
        const newState = root.enabled ? "off" : "on"
        toggleProc.command = ["iwctl", "device", root.device, "set-property", "Powered", newState]
        toggleProc.running = true

        // optimistic flip so the tile feels instant; verifyTimer corrects it
        // shortly after in case the command actually failed
        root.enabled = !root.enabled
        if (!root.enabled) root.ssid = ""
        verifyTimer.restart()
    }
}