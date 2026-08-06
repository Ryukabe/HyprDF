// components/bar/MediaExpanded.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../styles"
import "../../services"

Rectangle {
    id: root
    
    // Smooth transition dimensions for expanding the island
    implicitWidth: 640
    implicitHeight: 110
    color: Colors.bg // Ayu Dark background
    radius: Dimens.borderRadiusLarge // Sizing from Dimens

    Behavior on implicitWidth { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
    Behavior on implicitHeight { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Dimens.marginMedium
        spacing: 12

        // Album Art Thumbnail
        Rectangle {
            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
            Layout.alignment: Qt.AlignVCenter
            radius: Dimens.borderRadiusSmall
            color: Colors.surface
            clip: true

            Image {
                anchors.fill: parent
                source: AudioService.artUrl
                fillMode: Image.PreserveAspectCrop
                visible: AudioService.artUrl !== ""
            }

            // Fallback icon if no album art
            Text {
                anchors.centerIn: parent
                text: "󰎈" // Nerd font music note icon
                font.family: "JetBrains Mono Nerd Font Propo"
                font.pixelSize: 28
                color: Colors.subtext
                visible: AudioService.artUrl === ""
            }
        }

        // Track Info & Controls
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2 // Tighter spacing between title, artist, and controls

            // Track Title
            Text {
                text: AudioService.trackTitle
                font.family: "SF Pro Text"
                font.pixelSize: 13
                font.bold: true
                color: Colors.fg
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Artist Name
            Text {
                text: AudioService.trackArtist
                font.family: "SF Pro Text"
                font.pixelSize: 11
                color: Colors.subtext
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Playback Controls Row
            RowLayout {
                Layout.alignment: Qt.AlignHLeft
                Layout.topMargin: 4 // Small gap above controls
                spacing: 16

                // Previous
                Text {
                    text: "󰒮"
                    font.family: "JetBrains Mono Nerd Font Propo"
                    font.pixelSize: 20
                    color: Colors.fg
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: AudioService.previousTrack()
                    }
                }

                // Play / Pause
                Text {
                    text: AudioService.isPlaying ? "󰏤" : "󰐊"
                    font.family: "JetBrains Mono Nerd Font Propo"
                    font.pixelSize: 22
                    color: Colors.accent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: AudioService.togglePlayPause()
                    }
                }

                // Next
                Text {
                    text: "󰒭"
                    font.family: "JetBrains Mono Nerd Font Propo"
                    font.pixelSize: 20
                    color: Colors.fg

                    MouseArea {
                        anchors.fill: parent
                        onClicked: AudioService.nextTrack()
                    }
                }
            }
        }
    }
}