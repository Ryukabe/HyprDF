// services/ThemeService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel

Item {
    id: root

    property string currentTheme: "dragon"
    property bool isOpen: false
    property var themesList: []

    readonly property string projectRoot: Quickshell.shellDir + "/../HyprDF"
    readonly property string themesPath: root.projectRoot + "/themes"
    readonly property string applyScript: root.projectRoot + "/scripts/apply-theme.sh"
    readonly property string currentThemeFile: root.themesPath + "/.current-theme"

    // Path to the *currently active* theme's color file — Colors.qml binds to this.
    readonly property string currentThemeJsonPath: root.themeJsonPath(root.currentTheme)

    // Path to *any* theme's color file, by name — ThemeCard uses this for previews.
    function themeJsonPath(themeName) {
        return root.themesPath + "/" + themeName + "/quickshell/quickshell.json";
    }

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
            list.push({ name: folderName });
        }
        themesList = list;
    }

    function applyTheme(themeName) {
        if (!themeName) return;
        currentTheme = themeName;
        applyProcess.command = ["bash", root.applyScript, themeName];
        applyProcess.workingDirectory = root.projectRoot;
        applyProcess.running = true;
    }

    Process {
        id: applyProcess
        stdout: SplitParser {
            onRead: data => console.log("[ThemeService] stdout:", data)
        }
        stderr: SplitParser {
            onRead: data => console.log("[ThemeService] stderr:", data)
        }
        onExited: (exitCode, exitStatus) => {
            console.log("[ThemeService] apply-theme.sh exited with code", exitCode);
        }
    }
}