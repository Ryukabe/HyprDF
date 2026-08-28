import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../styles"
import "../../services"

Item {
    id: root

    // Compact resting size — grows automatically when the music bar or
    // recording indicator appear, via layout.implicitWidth below.
    // No Behavior here — Island.qml's outer wrapper already animates
    // width/height changes; adding one here would double-animate.
    implicitWidth: Math.max(120, layout.implicitWidth + 24)
    implicitHeight: Math.max(36, layout.implicitHeight + 8)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 10

        // 1. Music Visualizer (Left)
        RowLayout {
            spacing: 3
            visible: AudioService.isPlaying
            Layout.alignment: Qt.AlignVCenter

            Repeater {
                model: 4
                Item {
                    implicitWidth: 3
                    implicitHeight: 16

                    Rectangle {
                        width: parent.implicitWidth
                        color: Colors.accent
                        radius: 1.5
                        anchors.bottom: parent.bottom

                        SequentialAnimation on height {
                            running: AudioService.isPlaying
                            loops: Animation.Infinite

                            NumberAnimation {
                                to: 4 + ((index % 3) * 4)
                                duration: 240 + (index * 90)
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                to: 16 - ((index % 2) * 5)
                                duration: 290 + (index * 70)
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }
        }

        // 2. Clock Display (Middle)
        Text {
            text: Qt.formatDateTime(clock.date, "hh:mm AP")
            color: Colors.fg
            font {
                family: Fonts.display
                pixelSize: 13
                weight: 600
            }
        }

        // 3. Recording Indicator (Right)
        RecordingIndicator {
            active: RecordingService.enabled
            dotSize: 6
            dotColor: Colors.red
            Layout.alignment: Qt.AlignVCenter
        }
    }
}