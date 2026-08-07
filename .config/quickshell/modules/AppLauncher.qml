import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../styles"
import "../services"

PanelWindow {
    id: root
    property var screen

    IpcHandler {
        target: "applauncher"
        function toggle() {
            AppLauncherService.toggle();
        }
        function show() {
            AppLauncherService.show();
        }
        function hide() {
            AppLauncherService.hide();
        }
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: AppLauncherService.launcherVisible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "quickshell-launcher"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    mask: Region {
        item: AppLauncherService.launcherVisible ? maskCover : null
    }
    Item {
        id: maskCover
        anchors.fill: parent
    }

    color: "transparent"

    // ── State ──────────────────────────────────────────────────────────────
    property string searchQuery: ""
    property int selectedIndex: 0
    readonly property bool isSearching: searchQuery.trim() !== ""

    property var filteredApps: {
        var q = searchQuery.trim().toLowerCase();
        var vals = DesktopEntries.applications.values;

        if (q !== "") {
            // Search mode: filter by name / genericName / keywords, alpha sort
            return vals.filter(function (e) {
                if (e.name.toLowerCase().indexOf(q) !== -1)
                    return true;
                if (e.genericName && e.genericName.toLowerCase().indexOf(q) !== -1)
                    return true;
                for (var i = 0; i < e.keywords.length; i++)
                    if (e.keywords[i].toLowerCase().indexOf(q) !== -1)
                        return true;
                return false;
            }).sort(function (a, b) {
                return a.name.localeCompare(b.name);
            });
        }

        // Default mode: recent apps first, then alphabetical
        var recent = AppLauncherService.recentIds;
        return vals.slice().sort(function (a, b) {
            var ai = recent.indexOf(a.id);
            var bi = recent.indexOf(b.id);
            if (ai !== -1 && bi !== -1)
                return ai - bi;
            if (ai !== -1)
                return -1;
            if (bi !== -1)
                return 1;
            return a.name.localeCompare(b.name);
        });
    }

    onFilteredAppsChanged: selectedIndex = 0

    // ── Launch ─────────────────────────────────────────────────────────────
    function launchEntry(entry) {
        AppLauncherService.recordLaunch(entry.id);
        entry.execute();
        AppLauncherService.hide();
    }

    // ── Navigation ─────────────────────────────────────────────────────────
    function navigate(delta) {
        if (filteredApps.length === 0)
            return;
        selectedIndex = (selectedIndex + delta + filteredApps.length) % filteredApps.length;
        listView.positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    Connections {
        target: AppLauncherService
        function onLauncherVisibleChanged() {
            if (AppLauncherService.launcherVisible) {
                searchInput.text = "";
                root.searchQuery = "";
                root.selectedIndex = 0;
                searchInput.forceActiveFocus();
            }
        }
    }

    // ── UI ─────────────────────────────────────────────────────────────────
    MouseArea {
        anchors.fill: parent
        visible: AppLauncherService.launcherVisible
        onClicked: AppLauncherService.hide()

        Rectangle {
            id: mainContainer
            width: 480
            height: 520
            anchors.centerIn: parent
            color: Colors.surface
            border.color: Colors.border
            border.width: 1
            radius: 12

            MouseArea {
                anchors.fill: parent
                onClicked: mouse.accepted = true
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                // Search Bar Input Box
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44
                    color: Colors.background
                    radius: 8
                    border.color: selectedIndex === -1 ? Colors.accent : Colors.border
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            text: "󰍉"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 16
                            color: Colors.colFg
                            opacity: 0.5
                        }

                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            color: Colors.colFg
                            focus: true
                            selectByMouse: true

                            onTextChanged: {
                                root.searchQuery = text;
                            }

                            Keys.onPressed: function(event) {
                                if (event.key === Qt.Key_Down) {
                                    root.navigate(1);
                                    event.accepted = true;
                                } else if (event.key === Qt.Key_Up) {
                                    root.navigate(-1);
                                    event.accepted = true;
                                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    if (root.filteredApps.length > 0) {
                                        root.launchEntry(root.filteredApps[root.selectedIndex]);
                                    }
                                    event.accepted = true;
                                } else if (event.key === Qt.Key_Escape) {
                                    AppLauncherService.hide();
                                    event.accepted = true;
                                }
                            }
                        }

                        Text {
                            visible: searchInput.text !== ""
                            text: "󰅖"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            color: Colors.colFg
                            opacity: 0.5

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    searchInput.text = "";
                                    root.searchQuery = "";
                                    searchInput.forceActiveFocus();
                                }
                            }
                        }
                    }
                }

                // Section Label for Recent Apps
                Text {
                    visible: !root.isSearching && AppLauncherService.recentIds.length > 0
                    text: "Recent Applications"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    font.bold: true
                    color: Colors.colFg
                    opacity: 0.6
                }

                // Application ListView
                ListView {
                    id: listView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: root.filteredApps
                    spacing: 4

                    delegate: Rectangle {
                        width: listView.width
                        height: 48
                        color: root.selectedIndex === index ? Colors.accent + "22" : "transparent"
                        radius: 8

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            Image {
                                Layout.preferredWidth: 28
                                Layout.preferredHeight: 28
                                source: modelData.icon ? "image://icon/" + modelData.icon : ""
                                sourceSize.width: 28
                                sourceSize.height: 28
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 13
                                    font.bold: root.selectedIndex === index
                                    color: Colors.colFg
                                    elide: Text.ElideRight
                                }

                                Text {
                                    visible: modelData.genericName !== ""
                                    Layout.fillWidth: true
                                    text: modelData.genericName
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 11
                                    color: Colors.colFg
                                    opacity: 0.4
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: root.selectedIndex = index
                            onClicked: root.launchEntry(modelData)
                            onWheel: function (wheel) {
                                if (wheel.angleDelta.y < 0)
                                    root.navigate(1);
                                else
                                    root.navigate(-1);
                            }
                        }
                    }
                }

                Item {
                    width: 1
                    height: 4
                }
            }
        }
    }
}