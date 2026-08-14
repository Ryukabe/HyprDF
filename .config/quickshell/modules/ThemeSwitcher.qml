// modules/ThemeSwitcher.qml
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
            Layout.leftMargin: 4
        }

        GridLayout {
            id: grid
            columns: switcherRoot.columnsCount
            rowSpacing: 10
            columnSpacing: 10

            Repeater {
                model: ThemeService.themesList

                ThemeCard {
                    required property var modelData
                    required property int index

                    themeName: modelData.name
                    isApplied: ThemeService.currentTheme === modelData.name
                    isSelected: switcherRoot.selectedIndex === index

                    Layout.preferredWidth: 160
                    Layout.preferredHeight: 46

                    onClicked: {
                        switcherRoot.selectedIndex = index;
                        ThemeService.applyTheme(modelData.name);
                    }
                }
            }
        }
    }
}