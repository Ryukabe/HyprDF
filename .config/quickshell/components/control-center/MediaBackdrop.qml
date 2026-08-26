import QtQuick
import "../../styles"
import "../../services"

Rectangle {
    id: root

    implicitWidth: 340
    implicitHeight: 140
    radius: 28 // Updated for rounder corners
    color: Colors.surface
    clip: true // keeps the art from spilling past the rounded corners

    // Full-bleed album art background
    Image {
        id: artImage
        anchors.fill: parent
        source: AudioService.artUrl
        fillMode: Image.PreserveAspectCrop
        visible: AudioService.artUrl !== ""
        smooth: true
        mipmap: true
    }

    // Fallback when there's no art — plain surface + centered note icon
    Text {
        anchors.centerIn: parent
        text: "󰎈"
        font.family: Fonts.nerdFont
        font.pixelSize: Dimens.fontSizeMassive
        color: Colors.subtext
        visible: AudioService.artUrl === ""
    }

    // Dark gradient overlay for text legibility over the art
    Rectangle {
        anchors.fill: parent
        visible: AudioService.artUrl !== ""
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.45) }
            GradientStop { position: 0.4; color: Qt.rgba(0, 0, 0, 0.15) }
            GradientStop { position: 0.6; color: Qt.rgba(0, 0, 0, 0.15) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.55) }
        }
    }

    // Title / artist — pinned top-left
    Column {
        id: trackInfo
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: Dimens.paddingMedium
        width: parent.width - (Dimens.paddingMedium * 2)
        spacing: Dimens.spacingSmall / 2

        Text {
            text: AudioService.trackTitle || "No Media Playing"
            font.family: Fonts.text
            font.pixelSize: Dimens.fontSizeLg
            font.bold: true
            color: Colors.white
            elide: Text.ElideRight
            width: parent.width
        }

        Text {
            text: AudioService.artistName || "Unknown Artist"
            font.family: Fonts.text
            font.pixelSize: Dimens.fontSizeSm
            color: Qt.rgba(1, 1, 1, 0.75)
            elide: Text.ElideRight
            width: parent.width
        }
    }

    // Playback controls — pinned bottom-right
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Dimens.paddingMedium
        spacing: Dimens.spacingLarge

        Text {
            text: "󰒮"
            font.family: Fonts.nerdFont
            font.pixelSize: Dimens.fontSizeLg
            color: Colors.white

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                onClicked: AudioService.previousTrack()
            }
        }

        Text {
            text: AudioService.isPlaying ? "󰏤" : "󰐊"
            font.family: Fonts.nerdFont
            font.pixelSize: Dimens.fontSizeLg + 2
            color: Colors.accent

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                onClicked: AudioService.togglePlayPause()
            }
        }

        Text {
            text: "󰒭"
            font.family: Fonts.nerdFont
            font.pixelSize: Dimens.fontSizeLg
            color: Colors.white

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                onClicked: AudioService.nextTrack()
            }
        }
    }
}