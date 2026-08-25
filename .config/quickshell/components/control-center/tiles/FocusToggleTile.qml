import QtQuick
import "../"
import "../../../services"
import "../../../styles"

ToggleTile {
    title: "Focus"
    active: ShellState.focusModeEnabled
    subtitle: ShellState.focusModeEnabled ? "On" : "Off"
    iconGlyph: "\uf186"
    iconColor: "#FFB74D"
    external: false
    onToggled: ShellState.toggleFocusMode()
}