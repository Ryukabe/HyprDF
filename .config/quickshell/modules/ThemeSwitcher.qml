// modules/ThemeSwitcher.qml
import QtQuick
import QtQuick.Layouts
import "../services"
import "../components/theme"
import "../styles"

FocusScope {
    id: switcherRoot
    implicitWidth: contentColumn.implicitWidth + 48
    implicitHeight: contentColumn.implicitHeight + 48
    focus: true

    property int selectedIndex: 0
    readonly property int columnsCount: 3

    Component.onCompleted: {
        switcherRoot.forceActiveFocus()
    }

    Keys.onPressed: event => {
        var count = ThemeService.themesList.length;
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
            if (ThemeService.themesList[selectedIndex]) {
                ThemeService.applyTheme(ThemeService.themesList[selectedIndex].name);
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            ShellState.showPage("clock");
            event.accepted = true;
        }
    }

    ColumnLayout {
        id: contentColumn
        anchors.centerIn: parent
        spacing: 16

        Text {
            text: "Theme Selector"
            color: Colors.fg
            font.pixelSize: Dimens.fontSizeLg
            font.bold: true
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: 8
        }

        GridLayout {
            id: grid
            columns: switcherRoot.columnsCount
            rowSpacing: 12
            columnSpacing: 12

            Repeater {
                model: ThemeService.themesList

                ThemeCard {
                    required property var modelData
                    required property int index

                    themeName: modelData.name
                    accentColor: modelData.accent
                    isLight: modelData.isLight
                    isActive: ThemeService.currentTheme === modelData.name || switcherRoot.selectedIndex === index

                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 70

                    onClicked: {
                        switcherRoot.selectedIndex = index;
                        ThemeService.applyTheme(modelData.name);
                    }
                }
            }
        }
    }
}