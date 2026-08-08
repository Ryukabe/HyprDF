import QtQuick
import Quickshell
import "../../styles"
import "../../services"

Rectangle {
    id: root
    implicitWidth: 520
    implicitHeight: 100
    color: Colors.bg
    radius: 18

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    function dayAt(offset) {
        var d = new Date(clock.date)
        d.setDate(d.getDate() + offset)
        return d
    }

    // ================= MEDIA PLAYER (left side) =================
    Rectangle {
        id: art
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        width: 72
        height: 72
        radius: 14
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
            font.pixelSize: 24
            color: Colors.subtext
            visible: AudioService.artUrl === ""
        }
    }

    // Track info + transport controls, both beside the art now
    Column {
        anchors.left: art.right
        anchors.leftMargin: 14
        anchors.verticalCenter: art.verticalCenter
        spacing: 6

        Text {
            text: AudioService.trackTitle
            color: Colors.fg
            font.pixelSize: 13
            font.bold: true
            elide: Text.ElideRight
            width: 140
        }
        Text {
            text: AudioService.trackArtist
            color: Colors.fgMuted
            font.pixelSize: 11
            elide: Text.ElideRight
            width: 140
        }
        Text {
            text: AudioService.trackAlbum.toUpperCase()
            color: Colors.fgMuted
            font.pixelSize: 9
            elide: Text.ElideRight
            width: 140
            visible: AudioService.trackAlbum !== ""
        }

        Row {
            spacing: 14
            topPadding: 2

            Text {
                text: "󰒮"
                color: Colors.fg
                font.family: "JetBrains Mono Nerd Font Propo"
                font.pixelSize: 14
                TapHandler { onTapped: AudioService.previousTrack() }
            }
            Text {
                text: AudioService.isPlaying ? "󰏤" : "󰐊"
                color: Colors.accent
                font.family: "JetBrains Mono Nerd Font Propo"
                font.pixelSize: 15
                TapHandler { onTapped: AudioService.togglePlayPause() }
            }
            Text {
                text: "󰒭"
                color: Colors.fg
                font.family: "JetBrains Mono Nerd Font Propo"
                font.pixelSize: 14
                TapHandler { onTapped: AudioService.nextTrack() }
            }
        }
    }

    // ================= CLOCK + CALENDAR (right side) =================
    Column {
        anchors.right: parent.right
        anchors.rightMargin: 18
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

Text {
    anchors.horizontalCenter: parent.horizontalCenter
    text: Qt.formatDateTime(clock.date, "hh:mm AP")
    color: Colors.accent
    font.pixelSize: 22
    font.weight: 800
}

        // 5 consecutive days, today centered
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            Repeater {
                model: [-2, -1, 0, 1, 2]

                delegate: Column {
                    readonly property date dayDate: root.dayAt(modelData)
                    readonly property bool isToday: modelData === 0
                    readonly property bool isFriday: dayDate.getDay() === 5
                    spacing: 4

                    Rectangle {
                        width: isToday ? 26 : 22
                        height: isToday ? 26 : 22
                        radius: width / 2
                        color: isToday ? Colors.accent : "transparent"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            anchors.centerIn: parent
                            text: Qt.formatDateTime(dayDate, "d")
                            color: isToday ? Colors.bg : (isFriday ? Colors.red : Colors.fg)
                            font.pixelSize: isToday ? 12 : 11
                            font.bold: isToday
                        }
                    }

                    // Week name under the date, 3 letters
                    Text {
                        text: Qt.formatDateTime(dayDate, "ddd")
                        color: isFriday ? Colors.red : (isToday ? Colors.accent : Colors.fgMuted)
                        font.pixelSize: 9
                        font.bold: isToday || isFriday
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }
}