import QtQuick
import Quickshell
import "../../styles"

Item {
    id: root

    anchors.fill: parent

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // --- Compact Time (Shown when bar is collapsed) ---
    Text {
        anchors.centerIn: parent
        
        // Slide right by 160 pixels into the right-central area when expanding
        anchors.horizontalCenterOffset: island.expanded ? 160 : 0
        
        opacity: island.expanded ? 0 : 1
        text: Qt.formatDateTime(clock.date, "hh:mm AP")
        color: Colors.fg
        font {
            family: Dimens.fontFamily
            pixelSize: Dimens.fontSizeSm
            weight: Font.DemiBold
        }

        Behavior on opacity { 
            NumberAnimation { duration: 150 } 
        }

        // Smooth sliding animation matching the island's morph duration
        Behavior on anchors.horizontalCenterOffset {
            NumberAnimation { 
                duration: 400 
                easing.type: Easing.OutCubic 
            }
        }
    }

    // --- Expanded Time & Date (Shown when bar is expanded) ---
    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        
        // Slide in from the edge when expanding
        anchors.rightMargin: island.expanded ? 32 : 10
        
        spacing: 2
        opacity: island.expanded ? 1 : 0

        Behavior on opacity { 
            NumberAnimation { 
                duration: 200
                easing.type: Easing.Bezier
                easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1] 
            } 
        }

        // Smooth sliding animation matching the island's morph duration
        Behavior on anchors.rightMargin {
            NumberAnimation { 
                duration: 400 
                easing.type: Easing.OutCubic 
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "hh:mm AP")
            color: Colors.accent
            font {
                family: Dimens.fontFamily
                pixelSize: 20
                weight: 800
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "dddd, MMMM d")
            color: Colors.fgMuted
            font {
                family: Dimens.fontFamily
                pixelSize: Dimens.fontSizeXs
            }
        }
    }
}