// modules/ThemeSwitcher.qml
import QtQuick
import QtQuick.Layouts
import "../services"
import "../components/theme"
import "../styles"

FocusScope {
    id: switcherRoot

    implicitWidth: 680
    implicitHeight: 210
    focus: true

    property int selectedIndex: -1
    property string searchQuery: ""
    property bool searchActive: false

    readonly property var filteredThemes: {
        var list = ThemeService.themesList || [];
        if (!searchQuery.trim()) return list;
        return list.filter(function(item) {
            return item.name.toLowerCase().includes(searchQuery.toLowerCase());
        });
    }

    Component.onCompleted: {
        switcherRoot.forceActiveFocus()
        listView.currentIndex = -1
    }

    Keys.onPressed: event => {
        var count = filteredThemes.length;
        if (count === 0) return;

        if (event.key === Qt.Key_Right || event.key === Qt.Key_Down) {
            if (selectedIndex < count - 1) {
                selectedIndex += 1;
                listView.currentIndex = selectedIndex;
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
            if (selectedIndex > 0) {
                selectedIndex -= 1;
                listView.currentIndex = selectedIndex;
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            if (selectedIndex >= 0 && filteredThemes[selectedIndex]) {
                ThemeService.applyTheme(filteredThemes[selectedIndex].name);
            }
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            if (searchActive) {
                searchActive = false;
                searchQuery = "";
            } else if (typeof ShellState !== "undefined") {
                ShellState.showPage("clock");
            }
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: "Themes"
                color: Colors.fg
                font.family: Fonts.text
                font.pixelSize: Dimens.fontSizeLg
                font.bold: true
            }

            Rectangle {
                implicitWidth: activeThemeText.implicitWidth + 14
                implicitHeight: 20
                radius: 10
                color: Qt.rgba(1, 1, 1, 0.08)

                Text {
                    id: activeThemeText
                    anchors.centerIn: parent
                    text: "Active: " + (ThemeService.currentTheme || "Default")
                    color: Colors.accent
                    font.family: Fonts.text
                    font.pixelSize: Dimens.fontSizeSm - 1
                    font.bold: true
                }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                id: searchBar
                visible: switcherRoot.searchActive
                implicitWidth: switcherRoot.searchActive ? 180 : 0
                implicitHeight: 30
                radius: 15
                color: Qt.rgba(1, 1, 1, 0.08)
                border.width: searchInput.activeFocus ? 1 : 0
                border.color: Colors.accent

                Behavior on implicitWidth {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    verticalAlignment: Text.AlignVCenter
                    color: Colors.fg
                    font.pixelSize: Dimens.fontSizeSm
                    clip: true
                    onTextChanged: switcherRoot.searchQuery = text

                    Text {
                        text: "Search..."
                        color: Colors.fgMuted
                        font.pixelSize: Dimens.fontSizeSm
                        visible: !searchInput.text && !searchInput.inputMethodComposing
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                implicitWidth: 30
                implicitHeight: 30
                radius: 15
                color: switcherRoot.searchActive ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(1, 1, 1, 0.08)

                Text {
                    anchors.centerIn: parent
                    text: "search"
                    font.family: Fonts.icon
                    font.pixelSize: 16
                    font.variableAxes: Fonts.iconAxes
                    font.features: { "liga": 1 }
                    color: switcherRoot.searchActive ? Colors.accent : Colors.fg
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        switcherRoot.searchActive = !switcherRoot.searchActive;
                        if (switcherRoot.searchActive) {
                            searchInput.forceActiveFocus();
                        } else {
                            switcherRoot.searchQuery = "";
                            switcherRoot.forceActiveFocus();
                        }
                    }
                }
            }
        }

        // Fast Continuous Horizontal Scroll View
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: ListView.Horizontal
            spacing: 14
            clip: true

            // Fast continuous scrolling configurations
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds
            highlightMoveDuration: 0
            highlightRangeMode: ListView.ApplyRange
            preferredHighlightBegin: 0
            preferredHighlightEnd: width

            model: switcherRoot.filteredThemes

            // Mouse/Trackpad wheel horizontal scrolling support
            WheelHandler {
                orientation: Qt.Horizontal
                property: "contentX"
                rotationScale: 15
            }

            delegate: ThemeCard {
                required property var modelData
                required property int index

                themeName: modelData.name
                isApplied: ThemeService.currentTheme === modelData.name
                isSelected: switcherRoot.selectedIndex === index

                implicitWidth: 145
                implicitHeight: 125

                onClicked: {
                    switcherRoot.selectedIndex = index;
                    listView.currentIndex = index;
                    ThemeService.applyTheme(modelData.name);
                }
            }
        }
    }
}