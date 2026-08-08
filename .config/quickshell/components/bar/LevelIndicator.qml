import QtQuick
import "../../styles"

Rectangle {
    id: root
    property string icon: "\uf028"
    property string iconSource: ""   // set this to use an image instead of a glyph
    property int percent: 50
    property color barColor: Colors.accent

    implicitWidth: 160
    implicitHeight: 36
    color: Colors.bg
    radius: height / 2

    Text {
        id: iconText
        visible: root.iconSource === ""
        text: root.icon
        font.family: Fonts.mono
        font.pixelSize: 14
        color: Colors.fg
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    Image {
        id: iconImage
        visible: root.iconSource !== ""
        source: root.iconSource
        width: 16
        height: 16
        fillMode: Image.PreserveAspectFit
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: percentText
        text: root.percent + "%"
        font.family: Fonts.mono
        font.pixelSize: 12
        font.weight: Font.DemiBold
        color: Colors.fg
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: track
        height: 4
        radius: 2
        color: Colors.bgSurface
        anchors.left: root.iconSource === "" ? iconText.right : iconImage.right
        anchors.leftMargin: 10
        anchors.right: percentText.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            width: track.width * (root.percent / 100)
            height: parent.height
            radius: parent.radius
            color: root.barColor
        }
    }
}