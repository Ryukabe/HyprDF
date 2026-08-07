import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../styles"

PanelWindow {
    id: osdWindow

    anchors.top: true
    margins.top: 10
    implicitWidth: 200
    implicitHeight: 36
    color: "transparent"
    visible: hideTimer.running

    // Keeps Quickshell's Pipewire bindings actively synced for this node
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    onVolumeChanged: hideTimer.restart()
    onMutedChanged: hideTimer.restart()

    Timer {
        id: hideTimer
        interval: 1500
    }

    Rectangle {
        anchors.fill: parent
        radius: Dimens.radiusFull
        color: Colors.bgSurface

        Row {
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: osdWindow.muted ? "󰝟" : "󰕾"
                color: Colors.accent
                font.family: "JetBrains Mono Nerd Font Propo"
                font.pixelSize: 16
            }

            Rectangle {
                width: 100
                height: 4
                radius: 2
                color: Colors.border
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: parent.width * osdWindow.volume
                    height: parent.height
                    radius: parent.radius
                    color: Colors.accent

                    Behavior on width {
                        NumberAnimation { duration: 150 }
                    }
                }
            }
        }
    }
}