// components/power-menu/PowerExpanded.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../components/power-menu"
import "../services"
import "../styles"

Item {
    id: root
    implicitWidth: row.implicitWidth + 32
    implicitHeight: 64
    focus: true

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

    Process { id: proc }

    function runCmd(cmd)
    {
        if (!cmd) return
        proc.command = ["sh", "-c", cmd]
        proc.running = true
    }

    function triggerSelected()
    {
        if (selectedIndex >= 0 && selectedIndex < actions.length)
        {
            runCmd(actions[selectedIndex].cmd)
        }
    }

    Timer {
        id: focusTimer
        interval: 50
        onTriggered: root.forceActiveFocus()
    }

    Connections {
        target: ShellState
        function onActivePageChanged()
        {
            if (ShellState.activePage === "power")
            {
                root.selectedIndex = 0
                focusTimer.restart()
            }
        }
    }

    Component.onCompleted: {
        if (ShellState.activePage === "power") focusTimer.restart()
            }

        // Key Navigation
        Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Left)
        {
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
    spacing: 18

    Repeater {
        model: root.actions

        IconButton {
            iconSource: modelData.icon
            iconHoverSource: modelData.iconHover
            selected: index === root.selectedIndex
            onClicked: {
                root.selectedIndex = index
                root.runCmd(model.modelData.cmd)
            }
        }
    }
}
}