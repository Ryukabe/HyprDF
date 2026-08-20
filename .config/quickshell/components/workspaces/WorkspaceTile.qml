// components/workspaces/WorkspaceTile.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../../services"
import "../../styles"

Rectangle {
    id: tileRoot

    required property int workspaceId
    readonly property bool isFocused: WorkspaceService.focusedWorkspaceId === workspaceId

    implicitWidth: 180
    implicitHeight: 110
    radius: Dimens.radiusMedium
    color: isFocused ? Colors.bgSurface : Colors.bgMica
    border.width: isFocused ? 2 : 1
    border.color: isFocused ? Colors.accent : Colors.border

    // Background workspace number indicator
    Text {
        anchors.centerIn: parent
        text: tileRoot.workspaceId
        font.family: Fonts.text
        font.pixelSize: 28
        font.bold: true
        color: tileRoot.isFocused ? Colors.accent : Colors.fgMuted
        opacity: clientsRepeater.count === 0 ? 0.5 : 0.15
    }

    // Live Hyprland Window Previews Container
    Item {
        id: previewArea
        anchors.fill: parent
        anchors.margins: 6

        Repeater {
            id: clientsRepeater
            model: Hyprland.clients ? Hyprland.clients.values.filter(c => c.workspace && c.workspace.id === tileRoot.workspaceId) : []

            Item {
                id: clientWrapper
                required property var modelData

                // Map monitor resolution proportions to the preview tile box
                x: Math.max(0, Math.min(previewArea.width - width, (modelData.at[0] / 1920) * previewArea.width))
                y: Math.max(0, Math.min(previewArea.height - height, (modelData.at[1] / 1080) * previewArea.height))
                width: Math.max(20, (modelData.size[0] / 1920) * previewArea.width)
                height: Math.max(16, (modelData.size[1] / 1080) * previewArea.height)

                Rectangle {
                    anchors.fill: parent
                    radius: Dimens.radiusSmall
                    color: Colors.bg
                    border.width: 1
                    border.color: clientWrapper.modelData.focusHistoryID === 0 ? Colors.accent : Colors.border
                    clip: true

                    // Screencopy view with attached HyprlandWindow object
                    ScreencopyView {
                        anchors.fill: parent
                        anchors.margins: 1
                        HyprlandWindow.window: clientWrapper.modelData
                    }

                    // Window Title Header Overlay
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 12
                        color: Qt.rgba(0, 0, 0, 0.6)

                        Text {
                            anchors.centerIn: parent
                            text: clientWrapper.modelData.title || clientWrapper.modelData.class || ""
                            font.pixelSize: 8
                            color: Colors.fg
                            elide: Text.ElideRight
                            width: parent.width - 4
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            WorkspaceService.dispatchWorkspace(tileRoot.workspaceId)
            ShellState.showPage("clock")
        }
    }
}