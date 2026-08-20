// shell.qml
import QtQuick
import Quickshell
import "modules"

ShellRoot {
    Component.onCompleted: {
        Qt.application.name = "quickshell"
        Qt.application.organization = "quickshell"
    }
    
    // Main island bar
    Bar {}

}