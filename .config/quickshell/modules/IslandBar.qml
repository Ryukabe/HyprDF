// ~/.config/quickshell/modules/IslandBar.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import styles 1.0
import components.bar 1.0

PanelWindow {
    id: window

    // Wayland LayerShell setup
    WlLayerSurface.namespace: "quickshell-island"
    WlLayerSurface.layer: WlLayer.Top

    // Anchor island to the top edge and center horizontally
    anchors {
        top: true
        left: false
        right: false
        bottom: false
    }

    // Pass-through clicks outside the island pill
    color: "transparent"

    // Island Dimensions
    implicitWidth: islandContainer.implicitWidth + (Dimens.paddingMd * 2)
    implicitHeight: islandContainer.implicitHeight + (Dimens.paddingSm * 2)

    // Floating Island Surface
    Rectangle {
        id: islandContainer
        anchors.top: parent.top
        anchors.topMargin: Dimens.marginSm
        anchors.horizontalCenter: parent.horizontalCenter

        // Size adapts dynamically to the sub-widgets inside
        implicitWidth: mainLayout.implicitWidth + (Dimens.paddingLg * 2)
        implicitHeight: Dimens.islandHeight

        color: Colors.bgSurface
        radius: Dimens.islandRadius
        border.color: Colors.border
        border.width: 1

        // Content layout inside island
        RowLayout {
            id: mainLayout
            anchors.centerIn: parent
            spacing: Dimens.spacingMd

            // Clock Sub-Widget
            Clock {}
        }
    }
}