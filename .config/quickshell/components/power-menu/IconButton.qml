// components/power-menu/IconButton.qml
import QtQuick
import "../../styles"

Rectangle {
    id: root
    property string iconSource: ""
    property string iconHoverSource: ""
    property bool selected: false
    signal clicked()

    width: 44
    height: 44
    radius: 12
    color: (mouseArea.containsMouse || root.selected) ? Colors.bgSurface : "transparent"
    Behavior on color { ColorAnimation { duration: 120 } }

    Image {
        anchors.centerIn: parent
        source: (mouseArea.containsMouse || root.selected) && root.iconHoverSource !== "" ? root.iconHoverSource : root.iconSource
        width: 22
        height: 22
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        sourceSize.width: 64
        sourceSize.height: 64
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}