import QtQuick
import Quickshell
import "../../styles"
import "../../services"

Rectangle {
    id: root
    implicitWidth: 400
    implicitHeight: 74
    color: Colors.bg
    radius: 16

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Rectangle {
        id: art
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 12
        width: 50
        height: 50
        radius: 10
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

    Column {
        anchors.left: art.right
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.leftMargin: 10
        spacing: 1

        Text {
            text: AudioService.trackTitle
            color: Colors.fg
            font.pixelSize: 12
            font.bold: true
            elide: Text.ElideRight
            width: 110
        }
        Text {
            text: AudioService.trackArtist
            color: Colors.fgMuted
            font.pixelSize: 10
            elide: Text.ElideRight
            width: 110
        }
        Text {
            text: AudioService.trackAlbum.toUpperCase()
            color: Colors.fgMuted
            font.pixelSize: 9
            elide: Text.ElideRight
            width: 110
            visible: AudioService.trackAlbum !== ""
        }
    }

    Row {
        anchors.left: art.left
        anchors.top: art.bottom
        anchors.topMargin: 6
        spacing: 10

        Text {
            text: "󰒮"
            color: Colors.fg
            font.family: "JetBrains Mono Nerd Font Propo"
            font.pixelSize: 12
            TapHandler { onTapped: AudioService.previousTrack() }
        }
        Text {
            text: AudioService.isPlaying ? "󰏤" : "󰐊"
            color: Colors.fg
            font.family: "JetBrains Mono Nerd Font Propo"
            font.pixelSize: 13
            TapHandler { onTapped: AudioService.togglePlayPause() }
        }
        Text {
            text: "󰒭"
            color: Colors.fg
            font.family: "JetBrains Mono Nerd Font Propo"
            font.pixelSize: 12
            TapHandler { onTapped: AudioService.nextTrack() }
        }
    }

    Text {
        id: timeText
        anchors.right: weekStrip.left
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -14
        text: Qt.formatDateTime(clock.date, "hh:mm")
        color: Colors.fg
        font.pixelSize: 18
        font.weight: Font.DemiBold
    }

    Row {
        id: weekStrip
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -8
        spacing: 4

        Repeater {
            model: 7

            Column {
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
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle {
                    width: 18
                    height: 18
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
}