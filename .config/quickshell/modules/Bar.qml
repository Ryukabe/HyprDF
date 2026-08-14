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

    WlrLayershell.keyboardFocus: (
        ShellState.activePage === "launcher" ||
        ShellState.activePage === "power" ||
        ShellState.activePage === "theme" ||
        ShellState.activePage === "wallpaper"
    ) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors { top: true; left: true; right: true }
    color: "transparent"

    // =========================================================================
    // CRITICAL PERFORMANCE FIX:
    // Keep window boundaries FIXED so Hyprland does NOT destroy and re-allocate 
    // Wayland layer shell surface framebuffers 60-144 times per second!
    // =========================================================================
    implicitHeight: 600
    implicitWidth: 1200

    exclusionMode: ExclusionMode.Normal
    exclusiveZone: island.compactHeight + island.anchors.topMargin

    Component.onCompleted: {
        BrightnessService.percent
        VolumeService.percent
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

    mask: Region {
        item: island.expanded ? clickCatcher : island
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

        // Explicit discrete dimensions to avoid QML layout re-binding thrashing
        width: targetWidth
        height: targetHeight

        property int targetWidth: pageLoader.item ? pageLoader.item.implicitWidth : compactWidth
        property int targetHeight: pageLoader.item ? pageLoader.item.implicitHeight : compactHeight

        radius: Math.min(height / 2, Dimens.islandRadius)
        color: Colors.bgMica
        border.color: Colors.border
        border.width: 0

        // GPU-Accelerated Explicit Width & Height Animations
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

        MouseArea {
            anchors.fill: parent
            enabled: ShellState.activePage === "clock"
            onClicked: ShellState.showPage("status")
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
                    case "theme": return themePage
                    case "wallpaper": return wallpaperSwitcherPage
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