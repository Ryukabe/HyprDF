import QtQuick
import "../"
import "../../../styles"
import "../../../services"

ToggleTile {
    title: "Airplane Mode"
    active: AirplaneModeService.enabled
    subtitle: AirplaneModeService.enabled ? "On" : "Off"
    iconGlyph: "\uf072"
    iconColor: Colors.cyan
    external: false
    onToggled: AirplaneModeService.toggle()
}