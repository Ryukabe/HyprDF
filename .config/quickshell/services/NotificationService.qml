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

            // expireTimeout is already provided in milliseconds by Quickshell.
            // If expireTimeout <= 0 (-1 means server decides), fall back to 4000ms.
            var timeoutMs = notification.expireTimeout > 0
                ? notification.expireTimeout
                : 2500

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