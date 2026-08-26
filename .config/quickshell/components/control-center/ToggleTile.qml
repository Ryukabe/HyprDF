import QtQuick
import "../../styles"

Rectangle {
    id: tile

    property string title: ""
    property string subtitle: ""
    property string displayName: title
    property string iconGlyph: "\uf013"
    property color iconColor: Colors.fg
    property bool active: false
    property bool external: false
    property bool compact: false
    property bool hasSubview: false

    signal toggled()
    signal subviewRequested()

    implicitWidth: compact ? 76 : 160
    implicitHeight: compact ? 78 : 64

    // Updated: Increase corner radius to match sliders/cards
    radius: compact ? 20 : 24
    color: Colors.surface
    border.width: 1
    border.color: Colors.border

    Behavior on color { ColorAnimation { duration: 150 } }

    // Base toggle target — fills the whole tile.
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!tile.external) {
                tile.active = !tile.active
            }
            tile.toggled()
        }
    }

    // ---- Compact layout: icon + label stacked, bottom-left ----
    Column {
        id: compactContent
        visible: tile.compact
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 12
        spacing: 6

        Text {
            text: tile.iconGlyph
            font.family: Fonts.mono
            font.pixelSize: Dimens.fontSizeXl
            color: tile.active ? Colors.accent : Colors.fg
        }

        Text {
            text: tile.displayName
            font.family: Fonts.text
            font.pixelSize: Dimens.fontSizeXSm
            color: Colors.fgMuted
            elide: Text.ElideRight
            width: tile.width - 24
        }
    }

    // Hit area for compactContent — subview navigation target
    MouseArea {
        visible: tile.compact
        enabled: tile.hasSubview
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        x: compactContent.x - 6
        y: compactContent.y - 6
        width: compactContent.width + 12
        height: compactContent.height + 12
        onClicked: tile.subviewRequested()
    }

    // ---- Full layout: icon + title/subtitle, left-aligned ----
    Row {
        id: fullContent
        visible: !tile.compact
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 14
        spacing: 10

        Text {
            text: tile.iconGlyph
            font.family: Fonts.mono
            font.pixelSize: Dimens.fontSizeLg
            color: tile.active ? Colors.accent : Colors.fg
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
                width: Math.min(implicitWidth, tile.width - 60)
            }
        }
    }

    // Hit area for fullContent — subview navigation target
    MouseArea {
        visible: !tile.compact
        enabled: tile.hasSubview
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        x: fullContent.x - 6
        y: fullContent.y - 6
        width: fullContent.width + 12
        height: fullContent.height + 12
        onClicked: tile.subviewRequested()
    }

    // Active indicator — accent when on, muted when off
    Rectangle {
        width: 8
        height: 8
        radius: 4
        color: tile.active ? Colors.accent : Colors.fgMuted
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        Behavior on color { ColorAnimation { duration: 150 } }
    }
}