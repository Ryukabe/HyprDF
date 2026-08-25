import QtQuick
import "../"
import "../../../services"
import "../../../styles"

ToggleTile {
    title: "Night Light"
    active: NightLightService.enabled
    subtitle: NightLightService.enabled ? "On" : "Off"
    iconGlyph: "\uf185"
    iconColor: "#FF8A65"
    external: true
    onToggled: NightLightService.toggle()
}