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
    color: "transparent"
    implicitHeight: 160

    // fixed reservation sized to the compact pill — stays constant regardless
    // of which page the island morphs into, so windows never jump
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: island.compactHeight + island.anchors.topMargin

    // Force these singletons to load immediately so their IpcHandlers
    // register at startup, instead of waiting for their page to be shown
    Component.onCompleted: {
        BrightnessService.percent
        VolumeService.percent
    }

    function brightnessTier(percent)
    {
        var tier = Math.round(percent / 20) * 20
        return Math.max(20, Math.min(100, tier))
    }

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
        anchors.topMargin: 5
        clip: true

        readonly property bool expanded: ShellState.activePage !== "clock"
            readonly property int compactHeight: 36

                implicitWidth: pageLoader.item ? pageLoader.item.implicitWidth : 160
                implicitHeight: pageLoader.item ? pageLoader.item.implicitHeight : compactHeight
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
                        case "clock": return clockPage
                        case "status": return statusPage
                        case "media": return mediaPage
                        case "power": return powerPage
                        case "control": return controlPage
                        case "launcher": return launcherPage
                        case "volume": return volumePage
                        case "brightness": return brightnessPage
                        default: return clockPage
                    }
                }
            }

            Component { id: clockPage; Clock {} }
            Component { id: statusPage; StatusPanel {} }
            Component { id: mediaPage; MediaExpanded { color: "transparent" } }

            Component {
                id: brightnessPage
                LevelIndicator {
                    iconSource: "../../assets/icons/brightness-" + brightnessTier(BrightnessService.percent) + ".png"
                    percent: BrightnessService.percent
                }
            }

            Component {
    id: volumePage
    LevelIndicator {
        iconSource: VolumeService.muted || VolumeService.percent === 0 ? "../../assets/icons/volume-mute.png"
                    : VolumeService.percent <= 35 ? "../../assets/icons/volume-low.png"
                    : VolumeService.percent <= 65 ? "../../assets/icons/volume-mid.png"
                    : "../../assets/icons/volume-high.png"
        percent: VolumeService.percent
    }
}

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