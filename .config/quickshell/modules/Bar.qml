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
import "../components/common"
import "../components/power-menu"
//import "../components/overview"

PanelWindow {
    id: window

    WlrLayershell.namespace: "quickshell:island"

    WlrLayershell.keyboardFocus: (
        ShellState.activePage === "launcher" ||
        ShellState.activePage === "power" ||
        ShellState.activePage === "theme" ||
        ShellState.activePage === "wallpaper" ||
        ShellState.activePage === "control" ||
        ShellState.activePage === "notificationcenter" ||
        ShellState.activePage === "polkit"
    ) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors { top: true; left: true; right: true }
    color: "transparent"

    implicitHeight: 600
    implicitWidth: 1200

    exclusionMode: ExclusionMode.Normal
    exclusiveZone: island.compactHeight + island.anchors.topMargin

    Component.onCompleted: {
        BrightnessService.percent
        VolumeService.percent
        NotificationService.trackedNotifications
        PolkitService.isActive
    }

    function brightnessTier(percent) {
        var tier = Math.round(percent / 20) * 20
        return Math.max(20, Math.min(100, tier))
    }

    IpcHandler {
        target: "launcher"
        function toggle() { ShellState.activePage = ShellState.activePage === "launcher" ? "clock" : "launcher" }
        function open() { ShellState.showPage("launcher") }
        function close() { ShellState.showPage("clock") }
    }

    IpcHandler {
        target: "power"
        function toggle() { ShellState.activePage = ShellState.activePage === "power" ? "clock" : "power" }
        function open() { ShellState.showPage("power") }
        function close() { ShellState.showPage("clock") }
    }

    IpcHandler {
        target: "controlcenter"
        function toggle(): void { ShellState.activePage === "control" ? ShellState.showPage("clock") : ShellState.showPage("control") }
        function open(): void { ShellState.showPage("control") }
        function close(): void { ShellState.showPage("clock") }
    }

    IpcHandler {
        target: "notificationcenter"
        function toggle(): void { ShellState.activePage === "notificationcenter" ? ShellState.showPage("clock") : ShellState.showPage("notificationcenter") }
        function open(): void { ShellState.showPage("notificationcenter") }
        function close(): void { ShellState.showPage("clock") }
    }

    IpcHandler {
        target: "themeswitcher"
        function toggle() { ShellState.activePage = ShellState.activePage === "theme" ? "clock" : "theme" }
        function open() { ShellState.showPage("theme") }
        function close() { ShellState.showPage("clock") }
    }

    IpcHandler {
        target: "wallpaper"
        function toggle(): void {
            WallpaperService.isOpen = !WallpaperService.isOpen;
            if (WallpaperService.isOpen) {
                ShellState.showPage("wallpaper");
            } else {
                ShellState.showPage("clock");
            }
        }
    }

    IpcHandler {
        target: "workspaces"
        function toggle() { ShellState.activePage = ShellState.activePage === "workspaces" ? "clock" : "workspaces" }
        function open() { ShellState.showPage("workspaces") }
        function close() { ShellState.showPage("clock") }
    }

    mask: Region {
        item: (island.expanded && ShellState.activePage !== "notification") ? clickCatcher : island
    }

    Rectangle {
        id: clickCatcher
        anchors.fill: parent
        color: "transparent"
        visible: island.expanded

        MouseArea {
            anchors.fill: parent
            onClicked: ShellState.showPage("clock")
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
        readonly property int compactWidth: 160

        width: targetWidth
        height: targetHeight

        property int targetWidth: pageLoader.item ? pageLoader.item.implicitWidth : compactWidth
        property int targetHeight: pageLoader.item ? pageLoader.item.implicitHeight : compactHeight

        radius: Math.min(height / 2, Dimens.islandRadius)
        color: Colors.bgMica
        border.color: Colors.border
        border.width: 0

        Behavior on width {
            NumberAnimation {
                duration: 320
                easing.type: Easing.OutCubic
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 320
                easing.type: Easing.OutCubic
            }
        }

        property bool canHoverOpen: true
        property string previousPage: "clock"

        Connections {
            target: ShellState
            function onActivePageChanged() {
                var wasModule = island.previousPage !== "clock" && island.previousPage !== "status"
                var nowClock = ShellState.activePage === "clock" || ShellState.activePage === "status"

                if (wasModule && nowClock) {
                    island.canHoverOpen = false
                }

                island.previousPage = ShellState.activePage
            }
        }

        HoverHandler {
            id: statusHover
            enabled: island.canHoverOpen && (ShellState.activePage === "clock" || ShellState.activePage === "status")

            onHoveredChanged: {
                if (hovered) {
                    if (ShellState.activePage === "clock") {
                        ShellState.showPage("status")
                    }
                } else {
                    if (ShellState.activePage === "status") {
                        ShellState.showPage("clock")
                    }
                }
            }
        }

        HoverHandler {
            id: exitTracker
            onHoveredChanged: {
                if (!hovered) {
                    island.canHoverOpen = true
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: island.expanded
            onClicked: {}
        }

        Loader {
            id: pageLoader
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

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
                    case "notification": return notificationPage
                    case "notificationcenter": return notificationCenterPage
                    case "theme": return themePage
                    case "wallpaper": return wallpaperSwitcherPage
                    case "polkit": return polkitPage
                    default: return clockPage
                }
            }
        }

        Component { id: clockPage; Clock {} }
        Component { id: statusPage; StatusPanel {} }
        Component { id: mediaPage; MediaExpanded { color: "transparent" } }
        Component { id: launcherPage; AppLauncher {} }
        Component { id: powerPage; PowerMenu {} }
        Component { id: themePage; ThemeSwitcher {} }
        Component { id: wallpaperSwitcherPage; WallpaperSwitcher {} }
        Component { id: controlPage; ControlCenter {} }
        Component { id: notificationPage; NotificationToast {} }
        Component { id: notificationCenterPage; NotificationCenter {} }
        Component { id: polkitPage; PolkitAgent {} }

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
    }
}