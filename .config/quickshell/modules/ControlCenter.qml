import QtQuick
import "../styles"
import "../services"
import "../components/control-center"
import "../components/notification-center"
import "../components/bar"

Item {
    id: root
    implicitWidth: 580
    implicitHeight: Math.min(contentColumn.implicitHeight + 32, 640)

    focus: true
    Keys.onPressed: (event) => {
    if (event.key === Qt.Key_Escape)
    {
        ShellState.showPage("clock")
        event.accepted = true
    }
}

Timer {
    id: focusTimer
    interval: 50
    repeat: false
    onTriggered: root.forceActiveFocus()
}

Component.onCompleted: focusTimer.restart()

Column {
    id: contentColumn
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 16
    spacing: 14

    Item {
        id: headerRow
        width: parent.width
        height: 28

        Text {
            id: backArrow
            text: "\uf060"
            font.family: Fonts.mono
            font.pixelSize: 16
            color: Colors.fg
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                anchors.margins: -8
                onClicked: ShellState.showPage("clock")
            }
        }

        Text {
            text: "Control Center"
            font.family: Fonts.text
            font.pixelSize: 15
            font.bold: true
            color: Colors.fg
            anchors.centerIn: parent
        }
    }

    Grid {
        id: toggleGrid
        width: parent.width
        columns: 2
        rowSpacing: 10
        columnSpacing: 10

        ToggleTile {
            id: wifiTile
            width: (toggleGrid.width - toggleGrid.columnSpacing) / 2
            title: "Wi-Fi"
            active: WifiService.enabled
            subtitle: WifiService.enabled ? (WifiService.ssid !== "" ? WifiService.ssid : "On") : "Off"
            iconGlyph: "\uf1eb"
            external: true
            onToggled: WifiService.toggle()
        }

        ToggleTile {
            id: btTile
            width: (toggleGrid.width - toggleGrid.columnSpacing) / 2
            title: "Bluetooth"
            subtitle: active ? "On" : "Off"
            iconGlyph: "\uf294"
            onToggled: console.log("Bluetooth toggled:", active)
        }

        ToggleTile {
            id: focusTile
            width: (toggleGrid.width - toggleGrid.columnSpacing) / 2
            title: "Focus"
            active: ShellState.focusModeEnabled
            subtitle: ShellState.focusModeEnabled ? "On" : "Off"
            iconGlyph: "\uf186"
            external: true
            onToggled: ShellState.toggleFocusMode()
        }

        ToggleTile {
            id: nightLightTile
            width: (toggleGrid.width - toggleGrid.columnSpacing) / 2
            title: "Night Light"
            active: NightLightService.enabled
            subtitle: NightLightService.enabled ? "On" : "Off"
            iconGlyph: "\uf185"
            external: true
            onToggled: NightLightService.toggle()
        }
    }

    Rectangle {
        id: brightnessSlider
        width: parent.width
        height: 36
        radius: 18
        color: Colors.surface
        border.width: 1
        border.color: Colors.border

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            radius: parent.radius
            width: parent.width * (BrightnessService.percent / 100)
            color: Qt.rgba(Colors.accent.r, Colors.accent.g, Colors.accent.b, 0.25)
            Behavior on width { NumberAnimation { duration: 100 } }
        }

        Text {
            text: "\uf185"
            font.family: Fonts.mono
            font.pixelSize: 14
            color: Colors.fg
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: BrightnessService.percent + "%"
            font.pixelSize: 12
            color: Colors.fgMuted
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            function updatePct(x)
            {
                var pct = Math.max(0, Math.min(100, Math.round((x / width) * 100)))
                BrightnessService.setPercent(pct)
            }
            onPressed: (mouse) => updatePct(mouse.x)
            onPositionChanged: (mouse) => { if (pressed) updatePct(mouse.x) }
        }
    }

    // Volume slider — mirrors brightnessSlider, backed by VolumeService
    Rectangle {
        id: volumeSlider
        width: parent.width
        height: 36
        radius: 18
        color: Colors.surface
        border.width: 1
        border.color: Colors.border

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            radius: parent.radius
            width: parent.width * (VolumeService.muted ? 0 : VolumeService.percent / 100)
            color: Qt.rgba(Colors.accent.r, Colors.accent.g, Colors.accent.b, 0.25)
            Behavior on width { NumberAnimation { duration: 100 } }
        }

        Text {
            text: VolumeService.muted ? "\uf026" : "\uf028"
            font.family: Fonts.mono
            font.pixelSize: 14
            color: Colors.fg
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                onClicked: VolumeService.toggleMute()
            }
        }

        Text {
            text: VolumeService.muted ? "Muted" : VolumeService.percent + "%"
            font.pixelSize: 12
            color: Colors.fgMuted
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            function updatePct(x)
            {
                var pct = Math.max(0, Math.min(100, Math.round((x / width) * 100)))
                VolumeService.setPercent(pct)
            }
            onPressed: (mouse) => updatePct(mouse.x)
            onPositionChanged: (mouse) => { if (pressed) updatePct(mouse.x) }
        }
    }

    MediaBackdrop {
        id: mediaCard
        width: parent.width
    }

    // Notification preview — latest 2 only, "See all" opens the full list
    Column {
        id: notificationPreview
        width: parent.width
        spacing: 8

        Item {
            width: parent.width
            height: 20

            Text {
                text: "Notifications"
                font.family: Fonts.text
                font.pixelSize: 12
                font.bold: true
                color: Colors.fgMuted
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "See all"
                font.pixelSize: 11
                color: Colors.accent
                visible: NotificationService.trackedNotifications.values.length > 0
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    onClicked: ShellState.showPage("notificationcenter")
                }
            }
        }

        Repeater {
            // most recent first, capped at 2
            model: {
                const items = NotificationService.trackedNotifications.values
                return items.slice(Math.max(0, items.length - 2)).reverse()
            }

            NotificationRow {
                width: notificationPreview.width
                notification: modelData
            }
        }

        Text {
            text: "No notifications"
            font.pixelSize: 12
            color: Colors.fgMuted
            visible: NotificationService.trackedNotifications.values.length === 0
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 4
            bottomPadding: 4
        }
    }
}
}