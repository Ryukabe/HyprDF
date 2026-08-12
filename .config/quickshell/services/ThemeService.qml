// services/ThemeService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel

Item {
    id: root

    property string currentTheme: "ariadne"
    property bool isOpen: false
    property var themesList: []

    // Using shellDir to remove deprecation warning
    readonly property string themesPath: Quickshell.shellDir + "/../HyprDF/themes"
    readonly property string currentThemeFile: Quickshell.shellDir + "/../HyprDF/themes/.current-theme"

    Component.onCompleted: {
        loadCurrentTheme();
    }

    Process {
        id: readCurrentThemeProc
        command: ["cat", root.currentThemeFile]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim().length > 0) {
                    root.currentTheme = data.trim();
                }
            }
        }
    }

    function loadCurrentTheme() {
        readCurrentThemeProc.running = true;
    }

    FolderListModel {
        id: folderModel
        folder: "file://" + root.themesPath
        showDirs: true
        showFiles: false
        showDotAndDotDot: false

        onCountChanged: updateThemes()
    }

    function updateThemes() {
        var list = [];
        for (var i = 0; i < folderModel.count; i++) {
            var folderName = folderModel.get(i, "fileName");
            
            if (folderName.startsWith(".")) continue;

            var accent = "#00e6a8";
            var isLight = folderName === "e-ink";

            list.push({
                name: folderName,
                accent: accent,
                isLight: isLight
            });
        }
        themesList = list;
    }

    function applyTheme(themeName) {
        currentTheme = themeName;
        applyProcess.command = ["bash", "-c", root.themesPath + "/../apply-theme.sh " + themeName];
        applyProcess.running = true;
    }

    Process {
        id: applyProcess
    }
}