pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "../../../styles"
import "../../../services"

Item {
    id: root
    implicitWidth: 580
    implicitHeight: Math.min(contentColumn.implicitHeight + 32, 540)

    signal backRequested()

    Column {
        id: contentColumn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        spacing: 14

        // Header
        Item {
            width: parent.width
            height: 28

            Text {
                text: "\uf060"
                font.family: Fonts.mono
                font.pixelSize: Dimens.fontSizeLg
                color: Colors.fg
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.backRequested()
                }
            }

            Text {
                text: "Audio Output Sinks"
                font.family: Fonts.text
                font.pixelSize: Dimens.fontSize15
                font.bold: true
                color: Colors.fg
                anchors.centerIn: parent
            }
        }

        // Sub-view item placeholder / sink list
        Text {
            text: "Select Active Output Device"
            font.family: Fonts.text
            font.pixelSize: Dimens.fontSizeSm
            font.bold: true
            color: Colors.fgMuted
            topPadding: 4
        }
    }
}