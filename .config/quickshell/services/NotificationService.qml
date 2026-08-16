pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "../services"

Singleton {
    id: root

    readonly property alias trackedNotifications: server.trackedNotifications
    property var latestNotification: null

    NotificationServer {
        id: server
        keepOnReload: false
        bodySupported: true
        imageSupported: true
        actionsSupported: true

        onNotification: (notification) => {
            notification.tracked = true
            root.latestNotification = notification

            // expireTimeout is in seconds per spec; fall back to 4s if the
            // sender didn't specify one (-1/0 means "server decides")
            var timeoutMs = notification.expireTimeout > 0
                ? notification.expireTimeout * 1000
                : 4000

            ShellState.flashPageFor("notification", timeoutMs)

            console.log(
                "[NotificationService] received —",
                "app:", notification.appName,
                "summary:", notification.summary,
                "body:", notification.body,
                "urgency:", notification.urgency
            )
        }
    }
}