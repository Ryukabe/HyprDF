pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool enabled: false
    property string statusText: "Off"
    property var connectedDevices: []
    property var availableDevices: []

    // Process to query overall adapter state (Powered on/off)
    Process {
        id: powerProc
        command: ["bluetoothctl", "show"]
        running: true
        stdout: SplitParser { onRead: data => root._parsePowerLine(data) }
    }

    // Process to list devices (scans or lists paired/discovered devices)
    Process {
        id: devicesProc
        command: ["bluetoothctl", "devices"]
        running: true
        stdout: SplitParser { onRead: data => root._parseDeviceLine(data) }
    }

    Process {
        id: toggleProc
    }

    Process {
        id: actionProc
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
        powerProc.running = true
        if (enabled) {
            devicesProc.running = true
        }
    }

    function _parsePowerLine(line) {
        if (line.match(/Powered:\s+yes/i)) {
            root.enabled = true
            root.statusText = "On"
        } else if (line.match(/Powered:\s+no/i)) {
            root.enabled = false
            root.statusText = "Off"
            root.availableDevices = []
            root.connectedDevices = []
        }
    }

    function _parseDeviceLine(line) {
        // Format: Device XX:XX:XX:XX:XX:XX Device Name
        const match = line.match(/^Device\s+([0-9A-Fa-f_:]+)\s+(.+)$/)
        if (match) {
            const mac = match[1]
            const name = match[2]
            
            // Avoid duplicates in available list
            let existing = root.availableDevices.find(d => d.mac === mac)
            if (!existing) {
                root.availableDevices.push({ mac: mac, name: name, connected: false })
                root.availableDevicesChanged()
            }
        }
    }

    function toggle() {
        const newState = root.enabled ? "off" : "on"
        toggleProc.command = ["bluetoothctl", "power", newState]
        toggleProc.running = true

        // Optimistic UI flip
        root.enabled = !root.enabled
        root.statusText = root.enabled ? "On" : "Off"
        if (!root.enabled) {
            root.availableDevices = []
            root.connectedDevices = []
        }
        verifyTimer.restart()
    }

    function connectDevice(mac) {
        actionProc.command = ["bluetoothctl", "connect", mac]
        actionProc.running = true
        verifyTimer.restart()
    }

    function disconnectDevice(mac) {
        actionProc.command = ["bluetoothctl", "disconnect", mac]
        actionProc.running = true
        verifyTimer.restart()
    }
}