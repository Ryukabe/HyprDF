// modules/PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../components/power-menu"
import "../services"
import "../styles"

Item {
    id: root
    implicitWidth: row.implicitWidth + 48
    implicitHeight: 76
    focus: true
    clip: true

    readonly property var actions: [
        {
            icon: "../../assets/icons/lock.png",
            iconHover: "../../assets/icons/lock-hover.png",
            cmd: "hyprlock -c $HOME/.config/hypr/hyprlock/hyprlock.conf "
        },
        {
            icon: "../../assets/icons/sleep.png",
            iconHover: "../../assets/icons/sleep-hover.png",
            cmd: "systemctl suspend"
        },
        {
            icon: "../../assets/icons/restart.png",
            iconHover: "../../assets/icons/restart-hover.png",
            cmd: "systemctl reboot"
        },
        {
            icon: "../../assets/icons/logout.png",
            iconHover: "../../assets/icons/logout-hover.png",
            cmd: "hyprctl dispatch exit"
        },
        {
            icon: "../../assets/icons/power.png",
            iconHover: "../../assets/icons/power-hover.png",
            cmd: "systemctl poweroff"
        }
    ]

    property int selectedIndex: 0

    Process {
        id: proc
        running: false

        onExited: {
            running = false
        }
    }

    function runCmd(cmd) {
        if (!cmd || proc.running)
            return

        proc.command = ["sh", "-c", cmd]
        proc.running = true

        // Close the power menu only after the command has been handed
        // to the process, so a click is not lost during page switching.
        ShellState.showPage("clock")
    }

    function triggerSelected() {
        if (actions[selectedIndex]) {
            runCmd(actions[selectedIndex].cmd)
        }
    }

    Timer {
        id: focusTimer
        interval: 50
        repeat: false
        onTriggered: root.forceActiveFocus()
    }

    Connections {
        target: ShellState
        function onActivePageChanged() {
            if (ShellState.activePage === "power") {
                root.selectedIndex = 0
                focusTimer.restart()
            }
        }
    }

    Component.onCompleted: {
        if (ShellState.activePage === "power") focusTimer.restart()
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Left) {
            root.selectedIndex = Math.max(root.selectedIndex - 1, 0)
            event.accepted = true
        } else if (event.key === Qt.Key_Right) {
            root.selectedIndex = Math.min(root.selectedIndex + 1, root.actions.length - 1)
            event.accepted = true
        } else if (event.key === Qt.Key_Escape) {
            ShellState.showPage("clock")
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.triggerSelected()
            event.accepted = true
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 16

        Repeater {
            model: root.actions

            IconButton {
                iconSource: modelData.icon
                iconHoverSource: modelData.iconHover
                selected: index === root.selectedIndex
                onClicked: {
                    root.selectedIndex = index
                    root.runCmd(modelData.cmd)
                }
            }
        }
    }
}