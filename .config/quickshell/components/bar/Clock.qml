import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../styles"
import "../../services"

Item {
    id: root

    // Compact resting size for standard clock, expands when timer view is active
    implicitWidth: Math.max(140, (showTimerView ? timerLayout.implicitWidth + 40 : layout.implicitWidth + 24))
    implicitHeight: Math.max(36, (showTimerView ? timerLayout.implicitHeight + 10 : layout.implicitHeight + 8))

    property bool showTimerView: false

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // Standard Clock Layout
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 10
        visible: !root.showTimerView

        // 1. Music Visualizer (Left) - Lowered Height & Smoother Sensitivity
        RowLayout {
            spacing: 3
            visible: AudioService.isPlaying
            Layout.alignment: Qt.AlignVCenter

            Repeater {
                model: 4
                Item {
                    implicitWidth: 3
                    implicitHeight: 10 // Lowered maximum height container from 16 to 10

                    Rectangle {
                        width: parent.implicitWidth
                        color: Colors.accent
                        radius: 1.5
                        anchors.bottom: parent.bottom

                        SequentialAnimation on height {
                            running: AudioService.isPlaying
                            loops: Animation.Infinite

                            // Smoother, lower peak height with longer duration
                            NumberAnimation {
                                to: 3 + ((index % 3) * 2) // Lowered peak range (3px - 7px)
                                duration: 420 + (index * 110) // Slower speed
                                easing.type: Easing.InOutSine
                            }
                            // Smoother return height with longer duration
                            NumberAnimation {
                                to: 10 - ((index % 2) * 3) // Soft bounce floor
                                duration: 480 + (index * 90) // Slower speed
                                easing.type: Easing.InOutSine
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

        // 3. Timer Quick Icon (Right Side - Only visible when timer is active/running)
        Text {
            text: "󱎫"
            font.family: Fonts.icon || "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            color: TimerService.running ? Colors.accent : Colors.fgMuted
            Layout.alignment: Qt.AlignVCenter
            visible: TimerService.secondsRemaining > 0 || TimerService.running

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (TimerService.secondsRemaining > 0 || TimerService.running) {
                        root.showTimerView = true
                    }
                }
            }
        }

        // 4. Recording Indicator (Right)
        RecordingIndicator {
            active: RecordingService.enabled
            dotSize: 6
            dotColor: Colors.red
            Layout.alignment: Qt.AlignVCenter
        }
    }

    // Transformed Timer Layout (Expanded Sizing & Padding)
    RowLayout {
        id: timerLayout
        anchors.centerIn: parent
        spacing: 18
        visible: root.showTimerView

        // Left Icon: Timer icon (Tap to return to Clock)
        Text {
            text: "󱎫"
            font.family: Fonts.icon || "JetBrainsMono Nerd Font"
            font.pixelSize: 18
            color: Colors.accent
            Layout.alignment: Qt.AlignVCenter

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onClicked: root.showTimerView = false
            }
        }

        // Middle: Countdown Timer text
        Text {
            text: TimerService.formatTime(TimerService.secondsRemaining)
            color: Colors.fg
            font {
                family: Fonts.display
                pixelSize: 15
                weight: 700
            }
        }

        // Right side: Scaled-up Controls
        RowLayout {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            // Play / Pause Icon
            Text {
                text: TimerService.running ? "pause" : "play_arrow"
                font.family: Fonts.icon
                font.pixelSize: 17
                color: Colors.fg

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    cursorShape: Qt.PointingHandCursor
                    onClicked: TimerService.togglePause()
                }
            }

            // Reset & Return Icon
            Text {
                text: "restart_alt"
                font.family: Fonts.icon
                font.pixelSize: 17
                color: Colors.fgMuted

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        TimerService.reset()
                        root.showTimerView = false
                    }
                }
            }
        }
    }
}