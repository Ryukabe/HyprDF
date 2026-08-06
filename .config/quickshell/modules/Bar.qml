import QtQuick
import QtQuick.Layouts
import Quickshell
import "../styles"
import "../services"
import "../components/bar"

PanelWindow {
    id: window

    anchors {
        top: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    implicitHeight: 160

    // 1. DYNAMIC MASK:
    // Switches to the full-width clickCatcher when expanded, allowing the empty space to receive clicks.
    // Reverts to just the island when collapsed so clicks pass through to your desktop.
    mask: Region { item: island.expanded ? clickCatcher : island }

    // 2. BACKGROUND CLICK CATCHER:
    // A transparent rectangle that fills the 160px bar area to catch clicks outside the island.
    Rectangle {
        id: clickCatcher
        anchors.fill: parent
        color: "transparent"
        visible: island.expanded
        
        TapHandler {
            onTapped: island.expanded = false
        }
    }

    Rectangle {
        id: island
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Dimens.marginSm
        clip: true

        property bool expanded: false

        // Dynamic sizing matched to MediaExpanded's target size when expanded
        implicitWidth: expanded ? 640 : 160
        implicitHeight: expanded ? 110 : 36
        radius: Math.min(height / 2, Dimens.islandRadius)
        color: Colors.bgSurface
        border.color: Colors.border
        border.width: 0

        // Smooth fluid morphing curves
        Behavior on implicitWidth {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        TapHandler {
            id: tap
            onTapped: island.expanded = !island.expanded
        }

        Clock {
            id: clock
        }

        // --- COMPACT STATE (Clock + Music Status Indicator) ---
        RowLayout {
            anchors.centerIn: parent
            opacity: island.expanded ? 0 : 1
            visible: opacity > 0
            spacing: 8

            Behavior on opacity { NumberAnimation { duration: 150 } }

            // Music indicator icon shown when AudioService is actively playing
            Text {
                text: "󰎈"
                color: Colors.accent
                font.family: "JetBrains Mono Nerd Font Propo"
                font.pixelSize: 14
                visible: AudioService.isPlaying
            }
        }

        // --- EXPANDED MEDIA CONTROLLER STATE ---
        MediaExpanded {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            opacity: island.expanded ? 1 : 0
            visible: opacity > 0
            color: "transparent" // Let island handle background styling

            Behavior on opacity { NumberAnimation { duration: 250 } }
        }
    }
}