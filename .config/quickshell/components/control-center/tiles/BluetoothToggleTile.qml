import QtQuick
import "../"
import "../../../services"
import "../../../styles"

ToggleTile {
    title: "Bluetooth"
    active: BluetoothService.enabled
    subtitle: BluetoothService.statusText
    iconGlyph: "\uf294"
    iconColor: "#7C93FF"
    external: true
    onToggled: BluetoothService.toggle()
}