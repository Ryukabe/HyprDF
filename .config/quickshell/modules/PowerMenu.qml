// modules/PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../styles"

PanelWindow {
    id: root

    // Hidden by default
    visible: false

    // Cover the full screen on the overlay layer
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: root.visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"

    // Close when pressing ESC
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
            root.visible = false;
        }
    }

    // Dismiss when clicking anywhere outside the card
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }

    // Styled Dark Card Container
    Rectangle {
        anchors.centerIn: parent
        width: 320
        height: 100
        radius: Dimens.radiusM
        
        // FIX 1: Explicit dark color so it stops being a white box!
        color: Colors.surface ? Colors.surface : "#1e1e2e" 
        border.color: Colors.border ? Colors.border : "#313244"
        border.width: 1

        // Prevent clicking inside the menu card from closing it
        MouseArea {
            anchors.fill: parent
            onClicked: (mouse) => mouse.accepted = true
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: 28

            // Lock Button
            Text {
                text: "🔒"
                font.pixelSize: 24
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.visible = false;
                        // add lock command here if needed
                    }
                }
            }

            // Reboot Button
            Text {
                text: "🔄"
                font.pixelSize: 24
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.visible = false;
                        // add reboot command here if needed
                    }
                }
            }

            // Shutdown Button
            Text {
                text: "⚡"
                font.pixelSize: 24
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.visible = false;
                        // add shutdown command here if needed
                    }
                }
            }
        }
    }

    // Listen for IPC commands
    IpcHandler {
        target: "powermenu"

        function toggle() {
            root.visible = !root.visible
        }
        function show() {
            root.visible = true
        }
        function hide() {
            root.visible = false
        }
    }
}