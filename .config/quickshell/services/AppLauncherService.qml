// services/AppLauncherService.qml
pragma Singleton
import QtQuick
import QtCore
import Quickshell

QtObject {
    id: root

    property var recentIds: []

    property var _settings: Settings {
        category: "AppLauncher"
        
        // In Qt 6, 'location' tells Settings exactly where to save, 
        // silencing the organizationName warnings.
        location: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/quickshell/applauncher_settings.ini"
        
        property string recentIdsSerialized: "[]"
    }

    Component.onCompleted: {
        recentIds = JSON.parse(_settings.recentIdsSerialized)
    }

    function recordLaunch(id) {
        var list = recentIds.slice()
        var idx  = list.indexOf(id)
        if (idx !== -1) list.splice(idx, 1)
        list.unshift(id)
        if (list.length > 12) list = list.slice(0, 12)
        recentIds = list
        _settings.recentIdsSerialized = JSON.stringify(list)
    }

    function clearRecents() {
        recentIds = []
        _settings.recentIdsSerialized = "[]"
    }

    // ── App list + search ──────────────────────────────────────────────
    // DesktopEntries.applications already excludes Hidden/NoDisplay entries
    function filteredApps(query) {
        var all = [...DesktopEntries.applications.values].sort(
            (a, b) => a.name.localeCompare(b.name)
        )

        if (!query || query.trim().length === 0) {
            var recents = recentIds
                .map(id => DesktopEntries.byId(id))
                .filter(a => a !== null && a !== undefined)
            var rest = all.filter(a => recentIds.indexOf(a.id) === -1)
            return recents.concat(rest)
        }

        var q = query.trim().toLowerCase()
        return all.filter(a => {
            var name = (a.name || "").toLowerCase()
            var comment = (a.comment || "").toLowerCase()
            return name.includes(q) || comment.includes(q)
        })
    }

    function launch(app) {
        if (!app) return
        app.execute()
        recordLaunch(app.id)
    }
}