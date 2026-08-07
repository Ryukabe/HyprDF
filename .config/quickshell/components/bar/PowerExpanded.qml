import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../services"
import "../../styles"

RowLayout {
    id: root
    spacing: 12

    // Helper process launcher
    Process {
        id: proc
    }

    function runCmd(cmd) {
        PowerServices.hide() // Slide island back up and hide
        proc.command = ["sh", "-c", cmd]
        proc.running = true
    }

    // Power Buttons
    IconButton {
        icon: "󰌾" // Lock
        onClicked: root.runCmd("hyprlock || loginctl lock-session")
    }

    IconButton {
        icon: "󰤄" // Sleep
        onClicked: root.runCmd("systemctl suspend")
    }

    IconButton {
        icon: "󰑐" // Reboot
        onClicked: root.runCmd("systemctl reboot")
    }

    IconButton {
        icon: "󰐥" // Power Off
        onClicked: root.runCmd("systemctl poweroff")
    }
}