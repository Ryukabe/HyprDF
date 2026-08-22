pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "."

// Island page wrapper around OverviewWidget. Opens as another page of the
// island (like your launcher/power menu); closes back into the resting
// clock on Escape/Enter or after a workspace jump.
//
// Registered as WorkspaceOverview in this folder's qmldir (see below) so it
// drops straight into Bar.qml's existing "workspaces" page — no renaming of
// the Component/IpcHandler/keyboardFocus wiring already there needed.
Item {
    id: root
    required property var panelWindow

    readonly property bool isOpen: ShellState.activePage === "workspaces"

    // GlobalStates.overviewOpen is the flag OverviewWidget/OverviewWindow
    // check internally (preview capture gating, drag masks, etc.) — kept
    // as-is from the module rather than rewiring every internal reference
    // to ShellState. Mirror it from the real page state.
    onIsOpenChanged: GlobalStates.overviewOpen = root.isOpen
    Component.onCompleted: GlobalStates.overviewOpen = root.isOpen

    // OverviewWidget sets GlobalStates.overviewOpen = false itself when you
    // click a workspace tile or toggle a special workspace — catch that and
    // morph the island back to the clock, same as Escape/Enter.
    Connections {
        target: GlobalStates
        function onOverviewOpenChanged() {
            if (!GlobalStates.overviewOpen && root.isOpen) {
                root.closeToClock();
            }
        }
    }

    // Bar.qml's PanelWindow has a FIXED surface (implicitWidth: 1200,
    // implicitHeight: 600) — it cannot grow beyond that. If the workspace
    // grid's natural size (driven by Config.options.overview.scale) comes
    // out bigger than the surface, the content gets clipped into nothing
    // visible while island.expanded still flips true — full-screen
    // clickCatcher activates with no pill to see. Clamp to what the
    // surface can actually hold, leaving a little margin.
    readonly property real maxWidth: (root.panelWindow?.width ?? 1200) - 40
    readonly property real maxHeight: (root.panelWindow?.height ?? 600) - 40

    implicitWidth: Math.min(overviewLoader.item?.implicitWidth ?? 0, root.maxWidth)
    implicitHeight: Math.min(overviewLoader.item?.implicitHeight ?? 0, root.maxHeight)

    focus: root.isOpen
    clip: true
    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape || event.key === Qt.Key_Return) {
            root.closeToClock();
            event.accepted = true;
            return;
        }

        const workspacesPerGroup = Config.options.overview.rows * Config.options.overview.columns;
        const currentId = Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1;
        const useWorkspaceMap = Config.options.overview.useWorkspaceMap;
        const workspaceMap = Config.options.overview.workspaceMap ?? [];
        const focusedMonitorId = Hyprland.focusedMonitor?.id ?? 0;
        const workspaceOffset = useWorkspaceMap ? Number(workspaceMap[focusedMonitorId] ?? 0) : 0;
        const currentGroup = Math.floor((currentId - workspaceOffset - 1) / workspacesPerGroup);
        const minWorkspaceId = currentGroup * workspacesPerGroup + 1 + workspaceOffset;
        const maxWorkspaceId = minWorkspaceId + workspacesPerGroup - 1;

        const rows = Config.options.overview.rows;
        const columns = Config.options.overview.columns;
        const reverseColumns = Config.options.overview.orderRightLeft;
        const reverseRows = Config.options.overview.orderBottomUp;

        const clampedIndex = Math.max(0, Math.min(workspacesPerGroup - 1, currentId - minWorkspaceId));
        const currentNormalRow = Math.floor(clampedIndex / columns);
        const currentNormalColumn = clampedIndex % columns;

        function toVisualRow(nr) { return reverseRows ? (rows - nr - 1) : nr; }
        function toVisualColumn(nc) { return reverseColumns ? (columns - nc - 1) : nc; }
        function toNormalRow(vr) { return reverseRows ? (rows - vr - 1) : vr; }
        function toNormalColumn(vc) { return reverseColumns ? (columns - vc - 1) : vc; }

        let targetVisualRow = toVisualRow(currentNormalRow);
        let targetVisualColumn = toVisualColumn(currentNormalColumn);
        let targetId = null;

        if (event.key === Qt.Key_Left || event.key === Qt.Key_H) {
            targetVisualColumn = (targetVisualColumn - 1 + columns) % columns;
        } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
            targetVisualColumn = (targetVisualColumn + 1) % columns;
        } else if (event.key === Qt.Key_Up || event.key === Qt.Key_K) {
            targetVisualRow = (targetVisualRow - 1 + rows) % rows;
        } else if (event.key === Qt.Key_Down || event.key === Qt.Key_J) {
            targetVisualRow = (targetVisualRow + 1) % rows;
        } else if (event.key >= Qt.Key_1 && event.key <= Qt.Key_9) {
            const position = event.key - Qt.Key_0;
            if (position <= workspacesPerGroup) targetId = minWorkspaceId + position - 1;
        } else if (event.key === Qt.Key_0) {
            if (workspacesPerGroup >= 10) targetId = minWorkspaceId + 9;
        }

        if (targetId === null && [Qt.Key_Left, Qt.Key_H, Qt.Key_Right, Qt.Key_L, Qt.Key_Up, Qt.Key_K, Qt.Key_Down, Qt.Key_J].includes(event.key)) {
            const targetNormalRow = toNormalRow(targetVisualRow);
            const targetNormalColumn = toNormalColumn(targetVisualColumn);
            targetId = minWorkspaceId + targetNormalRow * columns + targetNormalColumn;
        }

        if (targetId !== null) {
            const clampedTarget = Math.max(minWorkspaceId, Math.min(maxWorkspaceId, targetId));
            if (Hyprland.usingLua) {
                Hyprland.dispatch(`hl.dsp.focus({workspace = '${clampedTarget}'})`);
            } else {
                Hyprland.dispatch("workspace " + clampedTarget);
            }
            event.accepted = true;
        }
    }

    function closeToClock() {
        ShellState.showPage("clock");
    }

    Loader {
        id: overviewLoader
        anchors.centerIn: parent
        active: Config.options.overview.enable
        sourceComponent: OverviewWidget {
            panelWindow: root.panelWindow
        }
    }
}
