// components/theme/WallpaperCard.qml
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../styles"

Rectangle {
    id: card
    required property string wallpaperPath
    required property string wallpaperName
    property bool isApplied: false
    property bool isSelected: false
    property bool isHovered: false
    signal clicked()

    readonly property bool isRaised: isSelected || isHovered

    implicitWidth: 160
    implicitHeight: 90
    radius: Dimens.radiusSmall
    color: Colors.bgSurface
    // Note: clip: true is no longer needed here since OpacityMask handles the corner clipping

    border.width: card.isApplied ? 2 : 0
    border.color: Colors.accent

    scale: card.isRaised ? 1.1 : 1.0
    z: card.isRaised ? 2 : 0
    transformOrigin: Item.Center

    transform: Translate {
        y: card.isRaised ? -3 : 0

        Behavior on y {
            NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
        }
    }

    Behavior on scale {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }

    // Hidden source image for the mask
    Image {
        id: wallpaperImage
        anchors.fill: parent
        source: "file://" + card.wallpaperPath
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        sourceSize.width: 320
        sourceSize.height: 180
        visible: false
    }

    // Invisible mask shape matching the card's rounded corners
    Rectangle {
        id: maskRect
        anchors.fill: parent
        radius: card.radius
        visible: false
    }

    // Applies the rounded corner mask to the image
    OpacityMask {
        anchors.fill: wallpaperImage
        source: wallpaperImage
        maskSource: maskRect
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: card.isHovered = true
        onExited: card.isHovered = false
        onClicked: card.clicked()
    }
}