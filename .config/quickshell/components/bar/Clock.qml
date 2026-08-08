import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../styles"
import "../../services"

Item {
    id: root

    implicitWidth: 120
    implicitHeight: 36

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: Qt.formatDateTime(clock.date, "hh:mm AP")
            color: Colors.fg
            font {
                family: Fonts.display
                pixelSize: 13
                weight: 600
            }
        }

        Text {
            text: "󰎈"
            color: Colors.accent
            font.family: Fonts.nerdFont
            font.pixelSize: Dimens.fontSizeSm
            visible: AudioService.isPlaying
        }
    }
}