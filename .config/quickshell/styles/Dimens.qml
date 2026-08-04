pragma Singleton
import QtQuick

QtObject {
    // Border Radii
    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 16
    readonly property int radiusFull: 9999

    // Padding & Spacing
    readonly property int paddingSmall: 6
    readonly property int paddingMedium: 12
    readonly property int paddingLarge: 20

    // Component Sizes
    readonly property int barHeight: 40
}
