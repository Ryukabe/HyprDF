// components/theme/ThemeCard.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../services"
import "../../styles"

Rectangle {
    id: card
    required property string themeName
    property bool isApplied: false   // currentTheme === this card's theme
        property bool isSelected: false  // keyboard cursor is on this card
            property bool isHovered: false   // mouse is over this card
                signal clicked()

                readonly property bool isRaised: isSelected || isHovered

                    property var palette: ({})
                    property bool loaded: false

                        FileView {
                            id: cardThemeFile
                            path: ThemeService.themeJsonPath(card.themeName)

                            onLoaded: {
                                try {
                                    card.palette = JSON.parse(text());
                                    card.loaded = true;
                                } catch (e) {
                                card.palette = ({});
                                card.loaded = false;
                            }
                        }
                        onLoadFailed: error => {
                        card.palette = ({});
                        card.loaded = false;
                    }
                }

                function pick(key, fallback)
                {
                    return (card.loaded && card.palette[key] !== undefined) ? card.palette[key] : fallback;
                }

                readonly property color previewBg: pick("background", Colors.bgSurface)
                readonly property color previewAccent: pick("accent", Colors.accent)
                readonly property color previewFg: pick("foreground", Colors.fg)

                implicitWidth: 120
                implicitHeight: 164
                radius: Dimens.borderRadiusMedium
                color: card.previewBg

                border.width: card.isApplied ? 2 : 0
                border.color: card.previewAccent

                scale: card.isRaised ? 1.15 : 1.0
                z: card.isRaised ? 1 : 0
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

        Behavior on y {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: card.isHovered = true
        onExited: card.isHovered = false
        onClicked: card.clicked()
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 8

        Rectangle {
            width: 26
            height: 4
            radius: 2
            color: card.previewAccent
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: card.themeName
            color: card.previewFg
            font.family: Fonts.display
            font.pixelSize: Dimens.fontSizeMd
            Layout.alignment: Qt.AlignHCenter
        }
    }
}