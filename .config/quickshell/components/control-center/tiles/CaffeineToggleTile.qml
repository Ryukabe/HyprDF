import QtQuick
import "../"
import "../../../styles"
import "../../../services"

ToggleTile {
    title: "Caffeine"
    active: CaffeineService.enabled
    subtitle: CaffeineService.enabled ? "Awake" : "Off"
    iconGlyph: "\uf0f4"
    iconColor: Colors.green
    external: false
    onToggled: CaffeineService.toggle()
}