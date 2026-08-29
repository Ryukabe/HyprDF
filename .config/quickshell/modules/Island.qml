// modules/Island.qml

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../modules"
import "../styles"
import "../styles/ColorsTemps"
import "../services"
import "../components/bar"
import "../components/common"
import "../components/power-menu"

PanelWindow {
    id: window

    // Wayland Layer Shell Configuration
    WlrLayershell.namespace: "quickshell:island"
    WlrLayershell.keyboardFocus: (
        ShellState.activePage === "launcher" ||
        ShellState.activePage === "clipboard" ||
        ShellState.activePage === "power" ||
        ShellState.activePage === "theme" ||
        ShellState.activePage === "wallpaper" ||
        ShellState.activePage === "control" ||
        ShellState.activePage === "notificationcenter" ||
        ShellState.activePage === "polkit" ||
        ShellState.activePage === "status" ||
        ShellState.activePage === "timer"
    ) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Layout and Display
    anchors { top: true; left: true; right: true }
    implicitHeight: 600
    implicitWidth: 1200
    color: "transparent"

    // Exclusion Zone
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: island.compactHeight + island.anchors.topMargin

    // Keyboard Shortcuts
    Shortcut {
        sequence: "Escape"
        enabled: ShellState.activePage !== "clock"
        onActivated: ShellState.showPage("clock")
    }

    Component.onCompleted: {
        BrightnessService.percent
        VolumeService.percent
        NotificationService.trackedNotifications
        PolkitService.isActive
        HyprlandColorsTemp
        KittyColorsTemp
        VSCodeColorsTemp
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

    // --- Clipboard IPC Handler ---
    IpcHandler {
        target: "clipboard"
        function toggle(): void { 
            ShellState.activePage === "clipboard" ? ShellState.showPage("clock") : ShellState.showPage("clipboard") 
        }
        function open(): void { 
            ShellState.showPage("clipboard") 
        }
        function close(): void { 
            ShellState.showPage("clock") 
        }
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
        function close() { ShellState.showPage("clock") }
    }

    IpcHandler {
        target: "notificationcenter"
        function toggle(): void { ShellState.activePage === "notificationcenter" ? ShellState.showPage("clock") : ShellState.showPage("notificationcenter") }
        function open(): void { ShellState.showPage("notificationcenter") }
        function close() { ShellState.showPage("clock") }
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
        target: "timer"
        function toggle() { ShellState.activePage = ShellState.activePage === "timer" ? "clock" : "timer" }
        function open() { ShellState.showPage("timer") }
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
        // Anchors
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5
        clip: true

        // Properties
        readonly property bool expanded: ShellState.activePage !== "clock"
        readonly property int compactHeight: 36
        readonly property int compactWidth: 160
        property int targetWidth: pageLoader.item ? pageLoader.item.implicitWidth : compactWidth
        property int targetHeight: pageLoader.item ? pageLoader.item.implicitHeight : compactHeight

        // Size
        width: targetWidth
        height: targetHeight

        // Styling
        radius: Math.min(height / 2, Dimens.islandRadius)
        color: Colors.bgMica
        border.color: Colors.border
        border.width: 0

        // Animations
        Behavior on width {
            NumberAnimation {
                duration: 380
                easing.type: Easing.OutExpo
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 380
                easing.type: Easing.OutExpo
            }
        }

        Behavior on radius {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutCubic
            }
        }

        // Interaction (Only active when collapsed on clock view)
        MouseArea {
            id: islandTapArea
            anchors.fill: parent
            enabled: ShellState.activePage === "clock"
            hoverEnabled: enabled
            cursorShape: Qt.PointingHandCursor
            onClicked: ShellState.togglePage("status")
        }

        // Interaction (Eats clicks when expanded so it doesn't fall through)
        MouseArea {
            id: islandConsumeArea
            anchors.fill: parent
            enabled: island.expanded
            onClicked: {}
        }

        // Content Loader
        Loader {
            id: pageLoader
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            scale: islandTapArea.containsMouse ? 1.02 : 1.0
            opacity: 1.0

            Behavior on scale {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.2
                }
            }

            onItemChanged: {
                if (item) {
                    contentAnim.stop()
                    item.opacity = 0
                    item.scale = 0.94
                    contentAnim.start()
                }
            }

            ParallelAnimation {
                id: contentAnim
                NumberAnimation {
                    target: pageLoader.item
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 220
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: pageLoader.item
                    property: "scale"
                    from: 0.94
                    to: 1.0
                    duration: 280
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.1
                }
            }

            sourceComponent: {
                switch (ShellState.activePage) {
                    case "clock": return clockPage
                    case "status": return statusPage
                    case "media": return mediaPage
                    case "power": return powerPage
                    case "control": return controlPage
                    case "launcher": return launcherPage
                    case "clipboard": return clipboardPage
                    case "volume": return volumePage
                    case "brightness": return brightnessPage
                    case "notification": return notificationPage
                    case "notificationcenter": return notificationCenterPage
                    case "theme": return themePage
                    case "wallpaper": return wallpaperSwitcherPage
                    case "polkit": return polkitPage
                    case "timer": return timerPage
                    default: return clockPage
                }
            }
        }

        // Page Components
        Component { id: clockPage; Clock {} }
        Component { id: statusPage; StatusPanel {} }
        Component { id: mediaPage; MediaExpanded { color: "transparent" } }
        Component { id: notificationPage; NotificationToast {} }
        Component { id: launcherPage; AppLauncher {} }
        Component { id: clipboardPage; Clipboard {} }
        Component { id: powerPage; PowerMenu {} }
        Component { id: themePage; ThemeSwitcher {} }
        Component { id: wallpaperSwitcherPage; WallpaperSwitcher {} }
        Component { id: controlPage; ControlCenter {} }
        Component { id: notificationCenterPage; NotificationCenter {} }
        Component { id: polkitPage; PolkitAgent {} }
        Component { id: timerPage; TimerModule {} }

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