// ~/.config/quickshell/components/bar/Clock.qml
import QtQuick
import QtQuick.Layouts
import styles 1.0

Item {
    id: root

    // Layout dimensions derived from component content
    implicitWidth: clockRow.implicitWidth
    implicitHeight: clockRow.implicitHeight

    // Track system time
    property var currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    RowLayout {
        id: clockRow
        anchors.centerIn: parent
        spacing: Dimens.spacingSm

        // Main Time Display (e.g. 10:45 PM)
        Text {
            text: root.currentTime.toLocaleTimeString(Qt.locale(), "hh:mm A")
            color: Colors.fg
            font.pixelSize: Dimens.fontSizeMd
            font.weight: Font.Bold
            font.family: "Sans-Serif"
        }

        // Optional Date Badge (e.g. Tue, Aug 4)
        Text {
            text: root.currentTime.toLocaleDateString(Qt.locale(), "ddd, MMM d")
            color: Colors.fgMuted
            font.pixelSize: Dimens.fontSizeSm
            font.family: "Sans-Serif"
        }
    }
}