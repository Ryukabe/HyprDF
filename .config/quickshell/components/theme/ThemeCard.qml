// components/theme/ThemeCard.qml
import QtQuick
import QtQuick.Layouts
import "../../styles"

Rectangle {
    id: card
    property string themeName: ""
    property color accentColor: "#73d0ff"
    property bool isLight: false
    property bool isActive: false
    signal clicked()

    implicitWidth: 100
    implicitHeight: 70
    radius: Dimens.radiusMedium
    color: isActive ? Colors.surface : Colors.bgSurface
    border.color: isActive ? Colors.accent : Colors.border
    border.width: isActive ? 2 : 1

    MouseArea {
        anchors.fill: parent
        onClicked: card.clicked()
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 8

        Rectangle {
            width: 24
            height: 4
            radius: 2
            color: card.accentColor
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: card.themeName
            color: Colors.fg
            font.pixelSize: Dimens.fontSizeSm
            Layout.alignment: Qt.AlignHCenter
        }
    }
}