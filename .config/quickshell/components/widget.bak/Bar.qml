import Quickshell
import QtQuick
import "../components/bar"


PanelWindow {
    anchors { top: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    implicitHeight: 160

    mask: Region { item: island }

    Rectangle {
        id: island
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 8
        clip: true

        property bool expanded: false

            implicitWidth: expanded ? 340 : 150
            implicitHeight: expanded ? 120 : 34
            radius: Math.min(height / 2, 26)
            color: "#181616"

            Behavior on implicitWidth { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1] } }}
            Behavior on implicitHeight { NumberAnimation { duration: 500; easing.type: Easing.Bezier; easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1] } }

            TapHandler {
                id: tap
                onTapped: island.expanded = !island.expanded
            }

            Clock {id: clock}
        }
    

    
