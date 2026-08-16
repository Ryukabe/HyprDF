import QtQuick
import "../services"
import "../styles"
import "../components/control-center"
import "../components/bar"

Item {
    id: root
    implicitWidth: 380
    implicitHeight: contentColumn.implicitHeight + 32


    focus: true
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
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

        // Header
        Item {
            id: headerRow
            width: parent.width
            height: 28

            Text {
                id: backArrow
                text: "\uf060"
                font.family: Fonts.mono
                font.pixelSize: 16
                color: Colors.foreground
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
                font.family: Fonts.textFont
                font.pixelSize: 15
                font.bold: true
                color: Colors.foreground
                anchors.centerIn: parent
            }
        }

        // 2x2 toggle grid — all stubbed, no backend calls yet
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
                subtitle: active ? "Connected" : "Off"
                iconGlyph: "\uf1eb"
                onToggled: console.log("Wi-Fi toggled:", active) // TODO: nmcli
            }

            ToggleTile {
                id: btTile
                width: (toggleGrid.width - toggleGrid.columnSpacing) / 2
                title: "Bluetooth"
                subtitle: active ? "On" : "Off"
                iconGlyph: "\uf294"
                onToggled: console.log("Bluetooth toggled:", active) // TODO: bluetoothctl
            }

            ToggleTile {
                id: peaceTile
                width: (toggleGrid.width - toggleGrid.columnSpacing) / 2
                title: "Peace"
                subtitle: active ? "On" : "Off"
                iconGlyph: "\uf186"
                onToggled: console.log("Peace toggled:", active) // TODO: DND script
            }

            ToggleTile {
                id: nightLightTile
                width: (toggleGrid.width - toggleGrid.columnSpacing) / 2
                title: "Night Light"
                subtitle: active ? "On" : "Off"
                iconGlyph: "\uf185"
                onToggled: console.log("Night Light toggled:", active) // TODO: gammastep/wlsunset
            }
        }

        // Brightness slider — reuses BrightnessService, needs setPercent() (see below)
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
                color: Colors.foreground
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
                function updatePct(x) {
                    var pct = Math.max(0, Math.min(100, Math.round((x / width) * 100)))
                    BrightnessService.setPercent(pct)
                }
                onPressed: (mouse) => updatePct(mouse.x)
                onPositionChanged: (mouse) => { if (pressed) updatePct(mouse.x) }
            }
        }

        // Embedded media card — check MediaExpanded's actual root props/size expectations
        MediaExpanded {
            id: mediaCard
            width: parent.width
        }
    }
}