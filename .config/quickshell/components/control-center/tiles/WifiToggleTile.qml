import QtQuick
import "../"
import "../../../services"
import "../../../styles"

ToggleTile {
    title: "Wi-Fi"
    active: WifiService.enabled
    subtitle: {
        if (!WifiService.enabled) return "Off"
        if (WifiService.ssid === "") return "On"
        if (!WifiService.hasInternet) return "No Internet"
        return WifiService.ssid
    }
    iconGlyph: "\uf1eb"
    iconColor: "#4FC3F7"
    external: true
    onToggled: WifiService.toggle()
}