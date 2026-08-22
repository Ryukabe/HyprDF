pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

// Adapter for the overview module's Config.options.* API surface.
// The version Alvi uploaded loads a JSON file at
// ~/.config/quickshell/overview/config.json and merges it over defaults —
// that's a second, module-local config pattern that doesn't exist anywhere
// else in HyprDF. Dropped in favor of plain QML properties you edit
// directly in this file, consistent with how the rest of the shell works.
// Same field names/shape the module expects, so OverviewWidget.qml and
// OverviewWindow.qml are untouched below the import line.
Singleton {
    id: root

    property QtObject options: QtObject {
        property QtObject overview: QtObject {
            property int rows: 2
            property int columns: 5
            property real scale: 0.10
            property bool enable: true
            property bool hideEmptyRows: false
            property bool closeOnFocusLoss: true
            property bool useWorkspaceMap: false
            property var workspaceMap: []
            property bool orderRightLeft: false
            property bool orderBottomUp: false

            // previews: real feature, uses Quickshell's built-in ScreencopyView
            // (wlr-screencopy). If your compositor/session doesn't support it
            // you'll just see blank tiles where the live image would be —
            // flip previewsEnabled off if that happens.
            property bool previewsEnabled: true
            property string previewMode: "live" // "live" or "event"
            property bool includeInactiveMonitorPreviews: true
            property int previewRecaptureDelayMs: 60

            property bool showSpecialWorkspaces: true
            property var specialWorkspaces: []
            property int specialWorkspaceColumns: columns
            property string emptyWorkspaceWallpaper: ""
            property string specialEmptyWorkspaceWallpaper: ""

            property real workspaceSpacing: 6
            property real backgroundPadding: 10
            property real workspaceNumberBaseSize: 220

            property QtObject effects: QtObject {
                property bool enableBackdrop: true
                property real backdropOpacity: 0.28
                property real panelOpacity: 0.92
                property real workspaceOpacity: 0.86
                property real emptyWorkspaceWallpaperOverlayOpacity: 0.18
                property real windowOverlayOpacity: 0.22
                property bool enableBlur: false
                property bool glassMode: false
                property real glassTintStrength: 0.35
                property real glassBorderOpacity: 0.72
                property real glassShineOpacity: 0.14
            }
        }

        property QtObject position: QtObject {
            property int topMargin: 8
        }

        property QtObject windowPreview: QtObject {
            property bool showIcons: true
            property real iconToWindowRatio: 0.25
            property real iconToWindowRatioCompact: 0.45
            property real xwaylandIndicatorToIconRatio: 0.35
            property real inactiveMonitorOpacity: 0.4
            property bool cropToFill: false
        }

        property QtObject hacks: QtObject {
            property int arbitraryRaceConditionDelay: 150
            property int hyprlandEventDebounceMs: 50
        }
    }
}
