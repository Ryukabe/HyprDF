// modules/WallpaperSwitcher.qml
import QtQuick
import QtQuick.Layouts
import "../services"
import "../components/theme"
import "../styles"

FocusScope {
    id: switcherRoot
    
    implicitWidth: contentColumn.implicitWidth + 40
    implicitHeight: contentColumn.implicitHeight + 40
    focus: true

    property int selectedIndex: 0
    readonly property int columnsCount: 7

    Component.onCompleted: {
        switcherRoot.forceActiveFocus()
        revealTimer.restart()
    }

    Timer {
        id: revealTimer
        interval: 30
        onTriggered: {
            contentWrapper.opacity = 1.0
            contentWrapper.scale = 1.0
        }
    }

    Keys.onPressed: event => {
        var count = WallpaperService.wallpapersList.length;
        if (count === 0) return;

        if (event.key === Qt.Key_Right) {
            selectedIndex = (selectedIndex + 1) % count;
            event.accepted = true;
        } else if (event.key === Qt.Key_Left) {
            selectedIndex = (selectedIndex - 1 + count) % count;
            event.accepted = true;
        } else if (event.key === Qt.Key_Down) {
            if (selectedIndex + columnsCount < count) {
                selectedIndex += columnsCount;
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Up) {
            if (selectedIndex - columnsCount >= 0) {
                selectedIndex -= columnsCount;
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            if (WallpaperService.wallpapersList[selectedIndex]) {
                WallpaperService.applyWallpaper(WallpaperService.wallpapersList[selectedIndex].path);
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            ShellState.showPage("clock");
            event.accepted = true;
        }
    }

    Item {
        id: contentWrapper
        anchors.fill: parent
        opacity: 0.0
        scale: 0.94

        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: 280; easing.type: Easing.OutBack; easing.overshoot: 1.15 }
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            clip: true

            ColumnLayout {
                id: contentColumn
                anchors.centerIn: parent
                spacing: 16

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Wallpaper"
                        color: Colors.fg
                        font.pixelSize: Dimens.fontSizeLg + 2
                        font.bold: true
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: ThemeService.currentTheme
                        color: Colors.fgMuted
                        font.pixelSize: Dimens.fontSizeSm
                    }
                }

                GridLayout {
                    id: grid
                    columns: switcherRoot.columnsCount
                    rowSpacing: 12
                    columnSpacing: 12

                    Repeater {
                        model: WallpaperService.wallpapersList

                        WallpaperCard {
                            required property var modelData
                            required property int index

                            wallpaperPath: modelData.path
                            wallpaperName: modelData.name
                            isApplied: WallpaperService.currentWallpaper === modelData.path
                            isSelected: switcherRoot.selectedIndex === index

                            Layout.preferredWidth: 160
                            Layout.preferredHeight: 90

                            scale: switcherRoot.selectedIndex === index ? 1.04 : 1.0
                            Behavior on scale {
                                NumberAnimation { duration: 180; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
                            }

                            onClicked: {
                                switcherRoot.selectedIndex = index;
                                WallpaperService.applyWallpaper(modelData.path);
                            }
                        }
                    }
                }
            }
        }
    }
}