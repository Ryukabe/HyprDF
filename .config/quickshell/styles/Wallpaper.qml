pragma Singleton
import QtQuick

QtObject {
    // Current active wallpaper path
    property string currentWallpaper: "/home/user/Wallpapers/default.png"

    // Blur / FX controls for wallpaper widgets
    property real blurRadius: 30.0
    property real dimOpacity: 0.2
}
