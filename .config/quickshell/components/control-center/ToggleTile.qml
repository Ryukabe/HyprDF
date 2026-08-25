import QtQuick
import "../../styles"

Rectangle {
    id: tile

    property string title: ""
    property string subtitle: ""
    property string iconGlyph: "\uf013"
    property color iconColor: Colors.fg
    property bool active: false
    property bool external: false

    signal toggled()

    implicitWidth: 160
    implicitHeight: 68
    radius: Dimens.radiusMediumLarge
    color: active
        ? Qt.rgba(Colors.accent.r, Colors.accent.g, Colors.accent.b, 0.22)
        : Colors.surface
    border.width: 1
    border.color: active ? Colors.accent : Colors.border

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    Row {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: tile.iconGlyph
            font.family: Fonts.mono
            font.pixelSize: Dimens.fontSizeLg
            color: tile.iconColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            spacing: 1
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: tile.title
                font.family: Fonts.text
                font.pixelSize: Dimens.fontSizeSm
                font.bold: true
                color: Colors.fg
            }

            Text {
                text: tile.subtitle
                font.pixelSize: Dimens.fontSizeXSm
                color: tile.active ? Colors.accent : Colors.fgMuted
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 130)
            }
        }
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