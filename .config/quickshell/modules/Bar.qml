// modules/Bar.qml
//
// The Dynamic Island — a single morphing floating pill anchored to the top
// of the screen. Every "page" (clock, status, media, power menu, control
// center, launcher, OSDs, notifications, etc.) is a Loader-swapped QML
// component rendered inside this one Rectangle. ShellState.activePage
// decides which page is currently showing.

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

    // Wayland layer-shell surface name — used by Hyprland layer rules
    // (e.g. no_anim, ignore_zero) to target this specific surface.
    WlrLayershell.namespace: "quickshell:island"

    // Only grab exclusive keyboard focus (steal input from every other
    // window) while a page that actually needs typing/arrow-key nav is
    // open. Everything else (clock, status, OSDs, toasts) stays
    // non-exclusive so it doesn't interrupt whatever you're doing elsewhere.
    WlrLayershell.keyboardFocus: (
        ShellState.activePage === "launcher" ||
        ShellState.activePage === "power" ||
        ShellState.activePage === "theme" ||
        ShellState.activePage === "wallpaper" ||
        ShellState.activePage === "control" ||
        ShellState.activePage === "notificationcenter"
    ) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors { top: true; left: true; right: true }
    color: "transparent"

    // =========================================================================
    // CRITICAL PERFORMANCE FIX:
    // Keep window boundaries FIXED so Hyprland does NOT destroy and re-allocate
    // Wayland layer shell surface framebuffers 60-144 times per second!
    // The island itself animates its own width/height internally — the
    // PanelWindow surface behind it never resizes.
    // =========================================================================
    implicitHeight: 600
    implicitWidth: 1200

    // Reserve just enough screen space (top strip) for the compact pill —
    // the rest of implicitHeight/Width above is just canvas room for the
    // island to expand into without the surface itself resizing.
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: island.compactHeight + island.anchors.topMargin

    // Force these singletons to instantiate immediately at shell startup
    // rather than lazily on first reference — without this, e.g. the
    // NotificationServer inside NotificationService might not start
    // listening on DBus until something else happens to touch it first.
    Component.onCompleted: {
        BrightnessService.percent
        VolumeService.percent
        NotificationService.trackedNotifications
    }

    // Snaps a raw brightness percent to the nearest 20% icon tier
    // (20/40/60/80/100) for the brightness OSD icon lookup.
    function brightnessTier(percent) {
        var tier = Math.round(percent / 20) * 20
        return Math.max(20, Math.min(100, tier))
    }

    // ---- IPC handlers -------------------------------------------------
    // Each of these lives here (not inside the lazily-loaded page itself)
    // because Loader-created components don't exist yet when a keybind
    // fires — the handler needs to exist up front to receive the call
    // and only then tell ShellState to load the page.

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

    // ---- Pointer masking ------------------------------------------------
    // PanelWindow's mask defines the ONLY region that receives pointer
    // events at the compositor level — anything outside it passes straight
    // through to whatever's behind the shell. While collapsed, only the
    // small island itself is clickable. While expanded, the mask widens to
    // clickCatcher (full surface) so clicking anywhere outside the island
    // closes it back to clock.
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

    // ---- The island itself -----------------------------------------------
    Rectangle {
        id: island
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5

        // Clips child page content to the pill's rounded shape as it morphs.
        clip: true

        readonly property bool expanded: ShellState.activePage !== "clock"
        readonly property int compactHeight: 36
        readonly property int compactWidth: 160

        // Explicit discrete width/height (not layout-computed) to avoid
        // QML re-binding thrashing during the morph animation.
        width: targetWidth
        height: targetHeight

        // Target size comes from whatever page is currently loaded; falls
        // back to the compact pill size when nothing's loaded yet.
        property int targetWidth: pageLoader.item ? pageLoader.item.implicitWidth : compactWidth
        property int targetHeight: pageLoader.item ? pageLoader.item.implicitHeight : compactHeight

        radius: Math.min(height / 2, Dimens.islandRadius)
        color: Colors.bgMica
        border.color: Colors.border
        border.width: 0

        // GPU-accelerated morph animation — width and height animate
        // together on the same fixed duration so the pill never distorts
        // (mismatched durations would make width/height finish at
        // different times and visibly warp the shape).
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

        // Hover-driven status panel: hovering the compact island opens the
        // status page; moving the cursor away closes it back to clock.
        // Scoped to only fire while on clock/status so it never interferes
        // with pages opened deliberately via keybind (launcher, power,
        // control center, etc.) — those close on their own Escape/click-
        // outside logic instead, not on incidental mouse-leave.
        HoverHandler {
            id: statusHover
            enabled: ShellState.activePage === "clock" || ShellState.activePage === "status"
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

        // Consumes clicks landing on blank space inside the expanded
        // island (gaps between widgets, padding, empty list states) so
        // they don't fall through the transparent island background to
        // clickCatcher underneath and accidentally close the panel.
        MouseArea {
            anchors.fill: parent
            enabled: island.expanded
            onClicked: {}
        }

        // ---- Page loader ---------------------------------------------------
        // Swaps in whichever Component matches ShellState.activePage.
        // Island width/height (above) reactively track whatever this
        // Loader ends up displaying.
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
                    default: return clockPage
                }
            }
        }

        // ---- Page components -------------------------------------------
        Component { id: clockPage; Clock {} }                              // resting state — clock + audio visualizer
        Component { id: statusPage; StatusPanel {} }                       // hover-revealed quick status view
        Component { id: mediaPage; MediaExpanded { color: "transparent" } } // now-playing media controls
        Component { id: launcherPage; AppLauncher {} }                     // keyboard-driven app launcher
        Component { id: powerPage; PowerMenu {} }                          // shutdown/restart/lock/logout
        Component { id: themePage; ThemeSwitcher {} }                      // theme picker grid
        Component { id: wallpaperSwitcherPage; WallpaperSwitcher {} }      // wallpaper picker grid
        Component { id: controlPage; ControlCenter {} }                   // Wi-Fi/BT/Focus/Night Light + sliders + media
        Component { id: notificationPage; NotificationToast {} }          // single-line incoming notification pill
        Component { id: notificationCenterPage; NotificationCenter {} }   // full notification list + clear all

        // Brightness OSD — icon tier picked by brightnessTier(), level
        // driven live by BrightnessService.percent.
        Component {
            id: brightnessPage
            LevelIndicator {
                iconSource: "../../assets/icons/brightness-" + brightnessTier(BrightnessService.percent) + ".png"
                percent: BrightnessService.percent
            }
        }

        // Volume OSD — icon picked by mute state and volume tier,
        // level driven live by VolumeService.percent.
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