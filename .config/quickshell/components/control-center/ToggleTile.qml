import QtQuick
import "../../styles"

Rectangle {
    id: tile

    property string title: ""
    property string subtitle: ""
    property string iconGlyph: "\uf013"
    property bool active: false
    property bool external: false

    signal toggled()

    implicitWidth: 160
    implicitHeight: 64
    radius: Dimens.radiusMediumLarge
    color: active
        ? Qt.rgba(Colors.accent.r, Colors.accent.g, Colors.accent.b, 0.22)
        : Colors.surface
    border.width: 1
    border.color: active ? Colors.accent : Colors.border

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Text {
        id: iconText
        text: tile.iconGlyph
        font.family: Fonts.mono
        font.pixelSize: Dimens.fontSizeLg
        color: tile.active ? Colors.accent : Colors.fg
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 12
        anchors.topMargin: 10
    }

    Text {
        id: titleText
        text: tile.title
        font.family: Fonts.text
        font.pixelSize: Dimens.fontSizeBase
        font.bold: true
        color: Colors.fg
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: iconText.bottom
        anchors.topMargin: 6
    }

    Text {
        id: subtitleText
        text: tile.subtitle
        font.pixelSize: Dimens.fontSizeXSm
        color: tile.active ? Colors.accent : Colors.fgMuted
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 8
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!tile.external) {
                tile.active = !tile.active
            }
            tile.toggled()
        }
    }
}