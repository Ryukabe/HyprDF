import QtQuick
import QtQuick.Controls
import "../../styles"
import "tiles"

Item {
    id: root
    property int columns: 3
    property real tileSpacing: Dimens.spacingSm
    implicitHeight: swipeView.height + pageIndicator.implicitHeight + Dimens.spacingSm

    signal openWifi()
    signal openBluetooth()
    signal openFocus()

    SwipeView {
        id: swipeView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 168
        clip: true

        Item {
            Grid {
                id: grid1
                width: parent.width
                columns: root.columns
                rowSpacing: root.tileSpacing
                columnSpacing: root.tileSpacing

                WifiToggleTile {
                    compact: true
                    width: (grid1.width - (root.columns - 1) * root.tileSpacing) / root.columns
                    onSubviewRequested: root.openWifi()
                }
                BluetoothToggleTile {
                    compact: true
                    width: (grid1.width - (root.columns - 1) * root.tileSpacing) / root.columns
                    onSubviewRequested: root.openBluetooth()
                }
                NightLightToggleTile {
                    compact: true
                    width: (grid1.width - (root.columns - 1) * root.tileSpacing) / root.columns
                }
                FocusToggleTile {
                    compact: true
                    width: (grid1.width - (root.columns - 1) * root.tileSpacing) / root.columns
                    onSubviewRequested: root.openFocus()
                }

                 AirplaneModeToggleTile {
                    compact: true
                    width: (grid2.width - (root.columns - 1) * root.tileSpacing) / root.columns
                }
                CaffeineToggleTile {
                    compact: true
                    width: (grid2.width - (root.columns - 1) * root.tileSpacing) / root.columns
                }
                RecordingToggleTile {
                    compact: true
                    width: (grid2.width - (root.columns - 1) * root.tileSpacing) / root.columns
                }

            }
        }

        Item {
            Grid {
                id: grid2
                width: parent.width
                columns: root.columns
                rowSpacing: root.tileSpacing
                columnSpacing: root.tileSpacing
            }
        }
    }

    PageIndicator {
        id: pageIndicator
        anchors.top: swipeView.bottom
        anchors.topMargin: Dimens.spacingSm
        anchors.horizontalCenter: parent.horizontalCenter
        count: swipeView.count
        currentIndex: swipeView.currentIndex
    }
}