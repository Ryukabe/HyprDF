// services/PolkitService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Polkit

Singleton {
    id: root

    readonly property alias agent: polkitAgent
    readonly property bool isActive: polkitAgent.isActive
    readonly property var currentFlow: polkitAgent.flow

    property string errorMessage: ""

    PolkitAgent {
        id: polkitAgent

        // Automatically switches back to "clock" when isActive becomes false
        onIsActiveChanged: {
            if (polkitAgent.isActive) {
                root.errorMessage = ""
                ShellState.showPage("polkit")
            } else {
                root.errorMessage = ""
                ShellState.showPage("clock")
            }
        }
    }

    Connections {
        target: polkitAgent.flow

        function onAuthenticationFailed() {
            root.errorMessage = "Authentication failed. Try again."
        }

        function onAuthenticationSucceeded() {
            root.errorMessage = ""
            ShellState.showPage("clock")
        }

        function onAuthenticationRequestCancelled() {
            root.errorMessage = ""
            ShellState.showPage("clock")
        }
    }

    function submitPassword(inputPass) {
        if (polkitAgent.flow && inputPass && inputPass.trim().length > 0) {
            polkitAgent.flow.submit(inputPass)
        }
    }

    function cancel() {
        if (polkitAgent.flow) {
            polkitAgent.flow.submit("")
        }
        root.errorMessage = ""
        ShellState.showPage("clock")
    }
}