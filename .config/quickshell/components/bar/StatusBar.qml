import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "../../styles"
import "../../services"

Rectangle {
    id: root
    implicitWidth: 360
    implicitHeight: 56
    color: "transparent"

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Dimens.paddingSm
        spacing: 12

        // --- Album art ---
        Rectangle {
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignVCenter
            radius: Dimens.radiusSmall
            color: Colors.surface
            clip: true

            Image {
                anchors.fill: parent
                source: AudioService.artUrl
                fillMode: Image.PreserveAspectCrop
                visible: AudioService.artUrl !== ""
            }
            Text {
                anchors.centerIn: parent
                text: "󰎈"
                font.family: "JetBrains Mono Nerd Font Propo"
                font.pixelSize: 16
                color: Colors.subtext
                visible: AudioService.artUrl === ""
            }
        }

        // --- Track info + transport controls ---
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Text {
                text: AudioService.trackTitle
                color: Colors.fg
                font.pixelSize: Dimens.fontSizeSm
                font.bold: true
                elide: Text.ElideRight
                Layout.maximumWidth: 120
            }
            Text {
                text: AudioService.trackArtist
                color: Colors.fgMuted
                font.pixelSize: 10
                elide: Text.ElideRight
                Layout.maximumWidth: 120
            }

            RowLayout {
                spacing: 10
                Layout.topMargin: 2

                Text {
                    text: "󰒮"
                    color: Colors.fg
                    font.family: "JetBrains Mono Nerd Font Propo"
                    font.pixelSize: 13
                    TapHandler { onTapped: AudioService.previousTrack() }
                }
                Text {
                    text: AudioService.isPlaying ? "󰏤" : "󰐊"
                    color: Colors.accent
                    font.family: "JetBrains Mono Nerd Font Propo"
                    font.pixelSize: 14
                    TapHandler { onTapped: AudioService.togglePlayPause() }
                }
                Text {
                    text: "󰒭"
                    color: Colors.fg
                    font.family: "JetBrains Mono Nerd Font Propo"
                    font.pixelSize: 13
                    TapHandler { onTapped: AudioService.nextTrack() }
                }
            }
        }

        Item { Layout.fillWidth: true }

        // --- Time ---
        Text {
            text: Qt.formatDateTime(clock.date, "hh:mm")
            color: Colors.fg
            font.pixelSize: 22
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignVCenter
        }

        // --- Mini week strip: S M T W T F S with dates, today highlighted ---
        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 4

            Repeater {
                model: 7

                ColumnLayout {
                    // Center this column on "today" — offsets -3..+3 from now
                    readonly property date dayDate: {
                        var d = new Date(clock.date)
                        d.setDate(d.getDate() + (index - 3))
                        return d
                    }
                    readonly property bool isToday: index === 3
                    spacing: 2

                    Text {
                        text: Qt.formatDateTime(dayDate, "ddd")[0]
                        color: isToday ? Colors.accent : Colors.fgMuted
                        font.pixelSize: 9
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Rectangle {
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 18
                        radius: 9
                        color: isToday ? Colors.accent : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: Qt.formatDateTime(dayDate, "d")
                            color: isToday ? Colors.bg : Colors.fg
                            font.pixelSize: 10
                            font.bold: isToday
                        }
                    }
                }
            }
        }

        // --- Wifi / battery (unchanged behavior, opens control center) ---
        Text {
            text: "󰤨"
            color: Colors.fg
            font.family: "JetBrains Mono Nerd Font Propo"
            font.pixelSize: 14
            Layout.alignment: Qt.AlignVCenter
            TapHandler { onTapped: ShellState.showPage("control") }
        }
        Text {
            text: {
                const pct = Math.round((UPower.displayDevice?.percentage ?? 0) * 100)
                return "󰁹 " + pct + "%"
            }
            color: Colors.fg
            font.family: "JetBrains Mono Nerd Font Propo"
            font.pixelSize: 14
            Layout.alignment: Qt.AlignVCenter
            TapHandler { onTapped: ShellState.showPage("control") }
        }
    }
}