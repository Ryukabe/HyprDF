// modules/Bar.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../modules"
import "../styles"
import "../services"
import "../components/bar"
import "../components/power-menu"

PanelWindow {
    id: window

    WlrLayershell.namespace: "quickshell:island"

   WlrLayershell.keyboardFocus: (ShellState.activePage === "launcher" || ShellState.activePage === "power")
    ? WlrKeyboardFocus.Exclusive
    : WlrKeyboardFocus.None

    anchors { top: true; left: true; right: true }
    color: "transparent"

    implicitHeight: Math.max(160, island.implicitHeight + island.anchors.topMargin + 10)

    exclusionMode: ExclusionMode.Normal
    exclusiveZone: island.compactHeight + island.anchors.topMargin

    Component.onCompleted: {
        BrightnessService.percent
        VolumeService.percent
    }

    function brightnessTier(percent)
    {
        var tier = Math.round(percent / 20) * 20
        return Math.max(20, Math.min(100, tier))
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            ShellState.activePage = ShellState.activePage === "launcher" ? "clock" : "launcher"
        }
        function open() {
            ShellState.showPage("launcher")
        }
        function close() {
            ShellState.showPage("clock")
        }
    }

    IpcHandler {
        target: "powermenu"
        function toggle() {
            ShellState.activePage = ShellState.activePage === "power" ? "clock" : "power"
        }
        function open() {
            ShellState.showPage("power")
        }
        function close() {
            ShellState.showPage("clock")
        }
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

        // Smooth cubic expansion without vertical overshoot/bouncing glitches
        Behavior on implicitWidth {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }
        Behavior on implicitHeight {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        TapHandler {
            enabled: ShellState.activePage === "clock"
            onTapped: ShellState.showPage("status")
        }

        Loader {
            id: pageLoader
            // Anchors to top-center instead of centerIn so top elements stay fixed as island expands downward
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            // Content used to pop in at full opacity the instant sourceComponent
            // swapped — only the container was animating. This fades the new
            // page's content in on top of the container resize instead.
            opacity: 0
            onSourceComponentChanged: opacity = 0
            onLoaded: opacity = 1
            Behavior on opacity {
                NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
            }

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
        Component { id: launcherPage; AppLauncher {} }

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
            PowerExpanded {}
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
    }
}