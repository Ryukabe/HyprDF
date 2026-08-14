// modules/WallpaperSwitcher.qml
import QtQuick
import QtQuick.Layouts
import "../services"
import "../components/theme"
import "../styles"

FocusScope {
    id: switcherRoot
    
    // Hardcoded implicit limits so the Island knows exact target size immediately
    implicitWidth: 1024
    implicitHeight: 480
    focus: true

    property int selectedIndex: 0
    readonly property int columnsCount: 6

    Component.onCompleted: {
        switcherRoot.forceActiveFocus()
        revealTimer.restart()
    }

    // --- Staged Reveal Architecture ---
    Timer {
        id: revealTimer
        interval: 40
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
        scale: 0.96

        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            clip: true // Containment fix

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