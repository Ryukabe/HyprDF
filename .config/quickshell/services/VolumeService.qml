pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../services"

Singleton {
    id: root
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property int percent: sink ? Math.round(sink.audio.volume * 100) : 0
    readonly property bool muted: sink ? sink.audio.muted : false

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    onPercentChanged: ShellState.flashPage("volume")
    onMutedChanged: ShellState.flashPage("volume")
}