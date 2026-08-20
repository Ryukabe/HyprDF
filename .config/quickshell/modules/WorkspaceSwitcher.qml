// modules/WorkspaceSwitcher.qml
import QtQuick
import QtQuick.Layouts
import "../components/workspaces"
import "../services"
import "../styles"

FocusScope {
    id: switcherRoot

    implicitWidth: mainLayout.implicitWidth + 48
    implicitHeight: mainLayout.implicitHeight + 48
    focus: true

    Component.onCompleted: {
        switcherRoot.forceActiveFocus()
    }

    ColumnLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: 16

        // Header Section
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "WINDOW MANAGEMENT"
                color: Colors.fg
                font.family: Fonts.text
                font.pixelSize: Dimens.fontSizeSm
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Active Workspace " + WorkspaceService.focusedWorkspaceId
                color: Colors.accent
                font.family: Fonts.text
                font.pixelSize: Dimens.fontSizeSm
            }
        }

        // Live Overview Grid (5 columns x 2 rows)
        GridLayout {
            columns: 5
            rowSpacing: 12
            columnSpacing: 12

            Repeater {
                model: 10

                WorkspaceTile {
                    required property int index
                    workspaceId: index + 1
                }
            }
        }
    }

    // Direct key controls
    Keys.onPressed: (event) => {
        if (event.key >= Qt.Key_1 && event.key <= Qt.Key_9) {
            WorkspaceService.dispatchWorkspace(event.key - Qt.Key_0)
            ShellState.showPage("clock")
            event.accepted = true
        } else if (event.key === Qt.Key_0) {
            WorkspaceService.dispatchWorkspace(10)
            ShellState.showPage("clock")
            event.accepted = true
        } else if (event.key === Qt.Key_Escape) {
            ShellState.showPage("clock")
            event.accepted = true
        }
    }
}