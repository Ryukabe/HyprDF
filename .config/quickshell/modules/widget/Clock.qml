        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }

        Text {
            anchors.centerIn: parent
            opacity: island.expanded ? 0 : 1
            text: Qt.formatDateTime(clock.date, "hh:mm AP")
            color: "#c5c9c5"
            font { pixelSize: 14; weight: 600 }
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        Column {
            anchors.centerIn: parent
            spacing: 2
            opacity: island.expanded ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.Bezier; easing.bezierCurve: [0.34, 0.8, 0.34, 1, 1, 1] } }

            Text { anchors.horizontalCenter: parent.horizontalCenter; text: Qt.formatDateTime(clock.date, "hh:mm AP"); color: "#8ba4b0"; font { pixelSize: 26; weight: 600 } }
            Text { anchors.horizontalCenter: parent.horizontalCenter; text: Qt.formatDateTime(clock.date, "dddd, MMMM d"); color: "#a6a69c"; font.pixelSize: 13 }
        }