pragma Singleton
import QtQuick

QtObject {
    id: root

    property string activePage: "clock"

    function showPage(page) {
        root.activePage = page
    }
}