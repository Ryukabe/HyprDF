// components/control-center/WifiSubView.qml
import QtQuick
import QtQuick.Layouts
import "../../../styles"
import "../../../services"
Item {
    id: root
    implicitWidth: 580
    implicitHeight: 340

    signal backRequested()

    property string selectedSsid: ""
    property bool showingPasswordInput: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header Row
        Item {
            Layout.fillWidth: true
            implicitHeight: 28

            Text {
                text: "\uf060"
                font.family: Fonts.mono
                font.pixelSize: Dimens.fontSizeLg
                color: Colors.fg
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.showingPasswordInput) {
                            root.showingPasswordInput = false
                        } else {
                            root.backRequested()
                        }
                    }
                }
            }

            Text {
                text: root.showingPasswordInput ? "Connect to " + root.selectedSsid : "Wi-Fi Networks"
                font.family: Fonts.text
                font.pixelSize: Dimens.fontSize15
                font.bold: true
                color: Colors.fg
                anchors.centerIn: parent
                elide: Text.ElideRight
                width: parent.width - 80
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "\uf021"
                font.family: Fonts.mono
                font.pixelSize: Dimens.fontSizeLg
                color: Colors.fg
                visible: !root.showingPasswordInput
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        WifiService.networks = []
                        WifiService.refresh()
                    }
                }
            }
        }

        // Network List View
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !root.showingPasswordInput
            clip: true
            model: WifiService.networks
            spacing: 6

            delegate: Rectangle {
                required property var modelData
                width: ListView.view.width
                implicitHeight: 46
                radius: Dimens.radiusLarge
                color: modelData.ssid === WifiService.ssid ? Colors.bgSurface : Colors.surface
                border.width: 1
                border.color: Colors.border

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Text {
                        text: "\uf1eb"
                        font.family: Fonts.mono
                        font.pixelSize: Dimens.fontSizeMd
                        color: modelData.ssid === WifiService.ssid ? Colors.accent : Colors.fgMuted
                    }

                    Text {
                        Layout.fillWidth: true
                        text: modelData.ssid || "Hidden Network"
                        font.family: Fonts.text
                        font.pixelSize: Dimens.fontSizeSm
                        color: Colors.fg
                        elide: Text.ElideRight
                    }

                    Text {
                        text: modelData.secured ? "\uf023" : ""
                        font.family: Fonts.mono
                        font.pixelSize: Dimens.fontSizeSm
                        color: Colors.fgMuted
                        visible: modelData.ssid !== WifiService.ssid
                    }

                    Text {
                        text: modelData.ssid === WifiService.ssid ? "Connected" : ""
                        font.family: Fonts.text
                        font.pixelSize: Dimens.fontSizeXSm
                        color: Colors.accent
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.ssid === WifiService.ssid) return

                        root.selectedSsid = modelData.ssid
                        if (modelData.secured) {
                            passwordInput.text = ""
                            root.showingPasswordInput = true
                            passwordInput.forceActiveFocus()
                        } else {
                            WifiService.connectToNetwork(modelData.ssid, "")
                        }
                    }
                }
            }
        }

        // Password Input View
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.showingPasswordInput
            spacing: 12

            Text {
                text: "Enter Wi-Fi Password"
                font.family: Fonts.text
                font.pixelSize: Dimens.fontSizeSm
                color: Colors.fgMuted
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 40
                radius: Dimens.radiusMedium
                color: Colors.surface
                border.width: 1
                border.color: Colors.border

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.margins: 10
                    echoMode: TextInput.Password
                    font.family: Fonts.text
                    font.pixelSize: Dimens.fontSizeSm
                    color: Colors.fg
                    clip: true
                    onAccepted: connectBtn.click()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 38
                    radius: Dimens.radiusMedium
                    color: Colors.surface

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: Colors.fg
                        font.pixelSize: Dimens.fontSizeSm
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showingPasswordInput = false
                    }
                }

                Rectangle {
                    id: connectBtn
                    Layout.fillWidth: true
                    implicitHeight: 38
                    radius: Dimens.radiusMedium
                    color: Colors.accent

                    signal click()
                    onClick: {
                        WifiService.connectToNetwork(root.selectedSsid, passwordInput.text)
                        root.showingPasswordInput = false
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Connect"
                        color: Colors.bg
                        font.bold: true
                        font.pixelSize: Dimens.fontSizeSm
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: connectBtn.click()
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}