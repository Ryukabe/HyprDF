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
                family: "JetBrains Mono Nerd Font Propo"
                pixelSize: Dimens.fontSizeSm
                weight: Font.DemiBold
            }
        }

        Text {
            text: "󰎈"
            color: Colors.accent
            font.family: "JetBrains Mono Nerd Font Propo"
            font.pixelSize: 14
            visible: AudioService.isPlaying
        }
    }
}