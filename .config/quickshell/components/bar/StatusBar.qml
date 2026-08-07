import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "../../styles"
import "../../services"

Rectangle {
    id: root
    implicitWidth: 480
    implicitHeight: 64
    color: "transparent"

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Dimens.paddingMd
        spacing: 16

        // --- Album art ---
        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignVCenter
            radius: Dimens.radiusSmall
            color: Colors.surface
            clip: true

            Image {
                anchors.fill: parent
                source: AudioService.artUrl
                fillMode: Image.PreserveAspectCrop
                visible: AudioService.artUrl !== ""
                asynchronous: true
            }
            Text {
                anchors.centerIn: parent
                text: "󰎈"
                font.family: "JetBrains Mono Nerd Font Propo"
                font.pixelSize: 18
                color: Colors.subtext
                visible: AudioService.artUrl === ""
            }
        }

        // --- Track info + transport controls ---
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 3
            Layout.preferredWidth: 140

            Text {
                text: AudioService.trackTitle
                color: Colors.fg
                font.pixelSize: Dimens.fontSizeSm
                font.bold: true
                elide: Text.ElideRight
                Layout.maximumWidth: 140
            }
            Text {
                text: AudioService.trackArtist
                color: Colors.fgMuted
                font.pixelSize: 10
                elide: Text.ElideRight
                Layout.maximumWidth: 140
            }

            RowLayout {
                spacing: 12
                Layout.topMargin: 3

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
            font.pixelSize: 26
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 14
        }

        // --- Week strip ---
        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            Repeater {
                model: 7

                ColumnLayout {
                    readonly property date dayDate: {
                        var d = new Date(clock.date)
                        d.setDate(d.getDate() + (index - 3))
                        return d
                    }
                    readonly property bool isToday: index === 3
                    spacing: 4

                    Text {
                        text: Qt.formatDateTime(dayDate, "ddd")[0]
                        color: isToday ? Colors.accent : Colors.fgMuted
                        font.pixelSize: 10
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Rectangle {
                        Layout.preferredWidth: 22
                        Layout.preferredHeight: 22
                        radius: 11
                        color: isToday ? Colors.accent : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: Qt.formatDateTime(dayDate, "d")
                            color: isToday ? Colors.bg : Colors.fg
                            font.pixelSize: 11
                            font.bold: isToday
                        }
                    }
                }
            }
        }

        // --- Wifi / battery ---
        Text {
            text: "󰤨"
            color: Colors.fg
            font.family: "JetBrains Mono Nerd Font Propo"
            font.pixelSize: 15
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 10
            TapHandler { onTapped: ShellState.showPage("control") }
        }
        Text {
            text: {
                const pct = Math.round((UPower.displayDevice?.percentage ?? 0) * 100)
                return "󰁹 " + pct + "%"
            }
            color: Colors.fg
            font.family: "JetBrains Mono Nerd Font Propo"
            font.pixelSize: 15
            Layout.alignment: Qt.AlignVCenter
        }
    }
}