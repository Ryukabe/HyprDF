// services/AudioService.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    // Fetch active player or default to the first available player
    readonly property MprisPlayer activePlayer: Mpris.players.values[0] ?? null

    readonly property string trackTitle: activePlayer?.trackTitle ?? "No Media Playing"
    readonly property string trackArtist: activePlayer?.trackArtist ?? "Unknown Artist"
    readonly property string artUrl: activePlayer?.trackUrl ?? ""
    readonly property bool isPlaying: activePlayer?.playbackState === MprisPlaybackState.Playing

    function togglePlayPause() {
        if (activePlayer) activePlayer.togglePlaying()
    }

    function nextTrack() {
        if (activePlayer) activePlayer.next()
    }

    function previousTrack() {
        if (activePlayer) activePlayer.previous()
    }
}
