import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland  
import "../styles"
import "../services"
import "../components/bar"

PanelWindow {
    id: window

    WlrLayershell.namespace: "quickshell:island"

    anchors { top: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    implicitHeight: 160

    mask: Region { item: island.expanded ? clickCatcher : island }

    Rectangle {
        id: clickCatcher
        anchors.fill: parent
        color: "transparent"
        visible: island.expanded

        TapHandler {
            onTapped: ShellState.showPage("clock")
        }
    }

    Rectangle {
        id: island
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Dimens.marginSm
        clip: true

        readonly property bool expanded: ShellState.activePage !== "clock"

        implicitWidth: pageLoader.item ? pageLoader.item.implicitWidth : 160
        implicitHeight: pageLoader.item ? pageLoader.item.implicitHeight : 36
        radius: Math.min(height / 2, Dimens.islandRadius)
        color: Colors.bgSurfaceMica
        border.color: Colors.border
        border.width: 0

        Behavior on implicitWidth { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        Behavior on implicitHeight { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

        TapHandler {
            enabled: ShellState.activePage === "clock"
            onTapped: ShellState.showPage("status")
        }

        Loader {
            id: pageLoader
            anchors.centerIn: parent
            sourceComponent: {
                switch (ShellState.activePage) {
                    case "clock":    return clockPage
                    case "status":   return statusPage
                    case "media":    return mediaPage
                    case "power":    return powerPage
                    case "control":  return controlPage
                    case "launcher": return launcherPage
                    default:         return clockPage
                }
            }
        }

Component { id: clockPage; Clock {} }
        Component { id: statusPage; StatusBar {} }
        Component { id: mediaPage; MediaExpanded { color: "transparent" } }

        Component {
            id: powerPage
            Rectangle {
                implicitWidth: 420
                implicitHeight: 60
                color: "transparent"
                Text { anchors.centerIn: parent; text: "Power menu"; color: Colors.fg }
            }
        }

        Component {
            id: controlPage
            Rectangle {
                implicitWidth: 380
                implicitHeight: 320
                color: "transparent"
                Text { anchors.centerIn: parent; text: "Control center"; color: Colors.fg }
            }
        }

        Component {
            id: launcherPage
            Rectangle {
                implicitWidth: 420
                implicitHeight: 420
                color: "transparent"
                Text { anchors.centerIn: parent; text: "Launcher"; color: Colors.fg }
            }
        }
    }
}