// services/WallpaperService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel

Item {
    id: root

    property var wallpapersList: []
    property string currentWallpaper: ""
        property bool isOpen: false

            readonly property string applyScript: ThemeService.projectRoot + "/scripts/apply-wallpaper.sh"
                readonly property string wallpaperStateFile: ThemeService.themesPath + "/.wallpaper-state"
                    readonly property string wallpapersPath: ThemeService.themesPath + "/" + ThemeService.currentTheme + "/wallpapers"

                        onWallpapersPathChanged: rescan()

                        Component.onCompleted: rescan()

                        function rescan()
                        {
                            loadCurrentWallpaperProc.running = true;
                            folderModel.folder = "file://" + root.wallpapersPath;
                        }

                        // ── Discover wallpaper files for the active theme ──────────────────────
                        FolderListModel {
                            id: folderModel
                            folder: "file://" + root.wallpapersPath
                            showDirs: false
                            showFiles: true
                            nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp"]
                            showDotAndDotDot: false

                            onCountChanged: updateWallpapers()
                        }

                        function updateWallpapers()
                        {
                            var list = [];
                            for (var i = 0; i < folderModel.count; i++) {
                                var fileName = folderModel.get(i, "fileName");
                                var filePath = root.wallpapersPath + "/" + fileName;
                                list.push({ name: fileName, path: filePath });
                            }
                            wallpapersList = list;
                        }

                        // ── Read which wallpaper is active for the current theme ───────────────
                        Process {
                            id: loadCurrentWallpaperProc
                            command: ["bash", "-c", "grep '^" + ThemeService.currentTheme + ":' '" + root.wallpaperStateFile + "' 2>/dev/null | cut -d: -f2-"]
                            stdout: SplitParser {
                                onRead: data => {
                                if (data.trim().length > 0)
                                {
                                    root.currentWallpaper = data.trim();
                                }
                            }
                        }
                    }

                    // ── Apply a wallpaper ────────────────────────────────────────────────
                    function applyWallpaper(wallpaperPath)
                    {
                        if (!wallpaperPath) return;
                        currentWallpaper = wallpaperPath;
                        applyProcess.command = ["bash", root.applyScript, wallpaperPath];
                        applyProcess.workingDirectory = ThemeService.projectRoot;
                        applyProcess.running = true;
                    }

                    Process {
                        id: applyProcess
                        stdout: SplitParser {
                            onRead: data => console.log("[WallpaperService] stdout:", data)
                        }
                        stderr: SplitParser {
                            onRead: data => console.log("[WallpaperService] stderr:", data)
                        }
                        onExited: (exitCode, exitStatus) => {
                        console.log("[WallpaperService] apply-wallpaper.sh exited with code", exitCode);
                    }
                }
            }