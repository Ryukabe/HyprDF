// services/WorkspaceService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    // Reactive list of active workspace IDs (e.g. [1, 2, 3, 4, 5])
    readonly property var activeWorkspaces: Hyprland.workspaces ? Hyprland.workspaces.values : []
    readonly property int focusedWorkspaceId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1

    // Switch active workspace in Hyprland
    function dispatchWorkspace(id) {
        Hyprland.dispatch("workspace " + id)
    }

    // Move focused window to workspace
    function moveToWorkspace(id) {
        Hyprland.dispatch("movetoworkspace " + id)
    }
}