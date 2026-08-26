pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "../../../styles"
import "../../../services"

Item {
    id: root
    implicitWidth: 580
    implicitHeight: Math.min(contentColumn.implicitHeight + 32, 540)

    signal backRequested()

    // BluetoothService doesn't track a real "connected" state yet (see note),
    // so this just lists everything discovered.
    readonly property var deviceList: BluetoothService.availableDevices.concat(BluetoothService.connectedDevices)

    Column {
        id: contentColumn
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        spacing: 14

        // Header Row (Back Arrow & Title)
        Item {
            id: headerRow
            width: parent.width
            height: 28

            Text {
                id: backBtn
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
                    onClicked: root.backRequested()
                }
            }

            Text {
                text: "Bluetooth"
                font.family: Fonts.text
                font.pixelSize: Dimens.fontSize15
                font.bold: true
                color: Colors.fg
                anchors.centerIn: parent
            }

            Text {
                text: "\uf021"
                font.family: Fonts.mono
                font.pixelSize: Dimens.fontSizeMd
                color: Colors.fgMuted
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: BluetoothService.enabled

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    cursorShape: Qt.PointingHandCursor
                    onClicked: BluetoothService.refresh()
                }
            }
        }

        // Bluetooth Toggle Switch Card
        Rectangle {
            width: parent.width
            height: 48
            radius: Dimens.radiusLarge
            color: Colors.surface
            border.width: 1
            border.color: Colors.border

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12

                Text {
                    text: "\uf294"
                    font.family: Fonts.mono
                    font.pixelSize: Dimens.fontSizeLg
                    color: BluetoothService.enabled ? Colors.accent : Colors.fgMuted
                }

                Text {
                    text: "Bluetooth"
                    font.family: Fonts.text
                    font.pixelSize: Dimens.fontSizeMd
                    font.weight: Font.Medium
                    color: Colors.fg
                    Layout.fillWidth: true
                }

                // Switch Indicator
                Rectangle {
                    width: 40
                    height: 22
                    radius: 11
                    color: BluetoothService.enabled ? Colors.accent : Colors.bgMica
                    border.width: 1
                    border.color: Colors.border

                    Rectangle {
                        width: 16
                        height: 16
                        radius: 8
                        color: Colors.fg
                        anchors.verticalCenter: parent.verticalCenter
                        x: BluetoothService.enabled ? parent.width - width - 3 : 3

                        Behavior on x {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: BluetoothService.toggle()
                    }
                }
            }
        }

        // Devices List
        Flickable {
            width: parent.width
            height: Math.min(deviceListColumn.implicitHeight, 380)
            contentWidth: width
            contentHeight: deviceListColumn.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            visible: BluetoothService.enabled

            Column {
                id: deviceListColumn
                width: parent.width
                spacing: 8

                Text {
                    text: "Discovered Devices"
                    font.family: Fonts.text
                    font.pixelSize: Dimens.fontSizeSm
                    font.bold: true
                    color: Colors.fgMuted
                    topPadding: 4
                    bottomPadding: 4
                }

                Repeater {
                    model: root.deviceList

                    delegate: Rectangle {
                        required property var modelData

                        width: deviceListColumn.width
                        height: 48
                        radius: Dimens.radiusLarge
                        color: deviceMa.containsMouse ? Colors.bgSurface : Colors.surface
                        border.width: 1
                        border.color: Colors.border

                        Behavior on color { ColorAnimation { duration: 120 } }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 12

                            Text {
                                text: "\uf294"
                                font.family: Fonts.mono
                                font.pixelSize: Dimens.fontSizeMd
                                color: modelData.connected ? Colors.accent : Colors.fgMuted
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: modelData.name || "Unknown Device"
                                    font.family: Fonts.text
                                    font.pixelSize: Dimens.fontSizeMd
                                    font.weight: Font.Medium
                                    color: Colors.fg
                                    elide: Text.ElideRight
                                    width: parent.width
                                }

                                Text {
                                    text: modelData.connected ? "Connected" : "Available"
                                    font.pixelSize: Dimens.fontSizeXSm
                                    color: modelData.connected ? Colors.accent : Colors.fgMuted
                                }
                            }

                            Text {
                                text: modelData.connected ? "\uf00c" : ""
                                font.family: Fonts.mono
                                font.pixelSize: Dimens.fontSizeMd
                                color: Colors.accent
                                visible: modelData.connected
                            }
                        }

                        MouseArea {
                            id: deviceMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.connected) {
                                    BluetoothService.disconnectDevice(modelData.mac)
                                } else {
                                    BluetoothService.connectDevice(modelData.mac)
                                }
                            }
                        }
                    }
                }

                Text {
                    text: "No devices found"
                    font.pixelSize: Dimens.fontSizeSm
                    color: Colors.fgMuted
                    visible: root.deviceList.length === 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    topPadding: 20
                    bottomPadding: 20
                }
            }
        }

        // Disabled State Message
        Text {
            text: "Bluetooth is turned off"
            font.pixelSize: Dimens.fontSizeSm
            color: Colors.fgMuted
            visible: !BluetoothService.enabled
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 30
            bottomPadding: 30
        }
    }
}