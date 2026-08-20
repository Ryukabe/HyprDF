// modules/WorkspaceOverview

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../components/overview"
import "../services"
import "../styles"

Item {
    id: root

    // Ported from the standalone Overview.qml's keyHandler Item — same
    // Hyprland.usingLua dispatch fix, just closing via ShellState instead
    // of GlobalStates directly.
    focus: true

    implicitWidth: overviewLoader.item ? overviewLoader.item.implicitWidth : 0
    implicitHeight: overviewLoader.item ? overviewLoader.item.implicitHeight : 0

    Loader {
        id: overviewLoader
        anchors.fill: parent
        sourceComponent: OverviewWidget {
            // OverviewWidget only ever reads panelWindow.screen
            panelWindow: Window.window
        }
    }

    // Bridge: opening this page marks the widget's own state open;
    // if the widget closes itself internally (window click, workspace
    // click, etc.) we close the island page in step.
    Component.onCompleted: {
        GlobalStates.overviewOpen = true;
        focusTimer.restart();
    }

    Connections {
        target: GlobalStates
        function onOverviewOpenChanged() {
            if (!GlobalStates.overviewOpen && ShellState.activePage === "workspaces") {
                ShellState.showPage("clock");
            }
        }
    }

    Timer {
        id: focusTimer
        interval: 50
        repeat: false
        onTriggered: root.forceActiveFocus()
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape || event.key === Qt.Key_Return) {
            ShellState.showPage("clock");
            event.accepted = true;
            return;
        }

        const workspacesPerGroup = overviewLoader.item.overviewConfig.rows * overviewLoader.item.overviewConfig.columns;
        const currentId = Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1;
        const useWorkspaceMap = overviewLoader.item.overviewConfig.useWorkspaceMap;
        const workspaceMap = overviewLoader.item.overviewConfig.workspaceMap ?? [];
        const focusedMonitorId = Hyprland.focusedMonitor?.id ?? 0;
        const workspaceOffset = useWorkspaceMap ? Number(workspaceMap[focusedMonitorId] ?? 0) : 0;
        const currentGroup = Math.floor((currentId - workspaceOffset - 1) / workspacesPerGroup);
        const minWorkspaceId = currentGroup * workspacesPerGroup + 1 + workspaceOffset;
        const maxWorkspaceId = minWorkspaceId + workspacesPerGroup - 1;

        const rows = overviewLoader.item.overviewConfig.rows;
        const columns = overviewLoader.item.overviewConfig.columns;
        const reverseColumns = overviewLoader.item.overviewConfig.orderRightLeft;
        const reverseRows = overviewLoader.item.overviewConfig.orderBottomUp;

        const clampedIndex = Math.max(0, Math.min(workspacesPerGroup - 1, currentId - minWorkspaceId));
        const currentNormalRow = Math.floor(clampedIndex / columns);
        const currentNormalColumn = clampedIndex % columns;

        function toVisualRow(normalRow) { return reverseRows ? (rows - normalRow - 1) : normalRow; }
        function toVisualColumn(normalColumn) { return reverseColumns ? (columns - normalColumn - 1) : normalColumn; }
        function toNormalRow(visualRow) { return reverseRows ? (rows - visualRow - 1) : visualRow; }
        function toNormalColumn(visualColumn) { return reverseColumns ? (columns - visualColumn - 1) : visualColumn; }

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

        if (targetId === null && (
            event.key === Qt.Key_Left || event.key === Qt.Key_H ||
            event.key === Qt.Key_Right || event.key === Qt.Key_L ||
            event.key === Qt.Key_Up || event.key === Qt.Key_K ||
            event.key === Qt.Key_Down || event.key === Qt.Key_J
        )) {
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
}
