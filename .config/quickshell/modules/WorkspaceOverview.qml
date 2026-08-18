// modules/WorkspaceOverview.qml
//
// Pass 1 (skeleton): a workspace grid inside the island. Shows every
// Hyprland workspace as a tile, lets you navigate with arrow keys or
// mouse, and switches on Enter/click. No live window content yet —
// that's layered in once this routing/data plumbing is confirmed
// working (Pass 2 hooks into WorkspaceTile with per-window
// ScreencopyView captures, positioned via HyprlandToplevel geometry).

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../styles"
import "../services"

Item {
    id: root

    // ---- layout constants -------------------------------------------
    readonly property int columns: 5
    readonly property int tileWidth: 140
    readonly property int tileHeight: Math.round(tileWidth * 9 / 16)
    readonly property int gridSpacing: Dimens.spacingSmall

    // Hyprland.workspaces is already sorted by id; we just drop
    // named/scratchpad workspaces (negative ids) for this grid.
    property var workspaceList: Hyprland.workspaces.values.filter(function(ws) {
        return ws.id > 0
    })
    property int selectedIndex: 0

    implicitWidth: grid.implicitWidth + Dimens.paddingLarge * 2
    implicitHeight: header.implicitHeight + grid.implicitHeight + Dimens.paddingLarge * 2 + Dimens.spacingSmall

    focus: true

    // Loader-created components don't have focus yet the instant they're
    // swapped in — same race as everywhere else in this shell. Force it
    // shortly after completion rather than relying on signal timing.
    Timer {
        id: focusTimer
        interval: 50
        repeat: false
        onTriggered: root.forceActiveFocus()
    }

    Component.onCompleted: {
        // Land the keyboard cursor on whichever workspace is currently
        // focused, so arrow nav starts from "where you are" not tile 0.
        for (var i = 0; i < workspaceList.length; i++) {
            if (workspaceList[i].active) {
                selectedIndex = i
                break
            }
        }
        focusTimer.restart()
    }

    function switchTo(index) {
        if (index < 0 || index >= workspaceList.length) return
        Hyprland.dispatch("workspace " + workspaceList[index].id)
        ShellState.showPage("clock")
    }

    Keys.onPressed: (event) => {
        switch (event.key) {
            case Qt.Key_Left:
                selectedIndex = Math.max(0, selectedIndex - 1)
                event.accepted = true
                break
            case Qt.Key_Right:
                selectedIndex = Math.min(workspaceList.length - 1, selectedIndex + 1)
                event.accepted = true
                break
            case Qt.Key_Up:
                selectedIndex = Math.max(0, selectedIndex - columns)
                event.accepted = true
                break
            case Qt.Key_Down:
                selectedIndex = Math.min(workspaceList.length - 1, selectedIndex + columns)
                event.accepted = true
                break
            case Qt.Key_Return:
            case Qt.Key_Enter:
                switchTo(selectedIndex)
                event.accepted = true
                break
            case Qt.Key_Escape:
                ShellState.showPage("clock")
                event.accepted = true
                break
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Dimens.paddingLarge
        spacing: Dimens.spacingSmall

        Text {
            id: header
            text: "Workspaces"
            color: Colors.fgMuted
            font.family: Fonts.text
            font.pixelSize: Dimens.fontSizeSm
        }

        GridLayout {
            id: grid
            columns: root.columns
            rowSpacing: root.gridSpacing
            columnSpacing: root.gridSpacing

            Repeater {
                model: root.workspaceList

                delegate: Rectangle {
                    id: tile

                    Layout.preferredWidth: root.tileWidth
                    Layout.preferredHeight: root.tileHeight

                    radius: Dimens.borderRadiusSmall
                    color: Colors.surface
                    border.width: index === root.selectedIndex ? 2 : 1
                    border.color: modelData.active ? Colors.accent
                        : (index === root.selectedIndex ? Colors.fgMuted : Colors.border)

                    Behavior on border.color { ColorAnimation { duration: 120 } }

                    Text {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: 6
                        text: modelData.id
                        color: modelData.active ? Colors.accent : Colors.fgMuted
                        font.family: Fonts.mono
                        font.pixelSize: Dimens.fontSizeSm
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.selectedIndex = index
                            root.switchTo(index)
                        }
                    }
                }
            }
        }
    }
}