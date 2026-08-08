pragma Singleton
import QtQuick

QtObject {
    // Border Radii
    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 16
    readonly property int radiusFull: 9999
    readonly property int borderRadiusSmall: radiusSmall
    readonly property int borderRadiusLarge: radiusLarge

    // Padding & Spacing
    readonly property int paddingSmall: 6
    readonly property int paddingMedium: 12
    readonly property int paddingLarge: 20
    readonly property int paddingSm: paddingSmall
    readonly property int paddingMd: paddingMedium
    readonly property int paddingLg: paddingLarge

    readonly property int spacingSmall: 6
    readonly property int spacingMedium: 12
    readonly property int spacingLarge: 18
    readonly property int spacingSm: spacingSmall
    readonly property int spacingMd: spacingMedium
    readonly property int spacingLg: spacingLarge

    readonly property int marginSmall: 6
    readonly property int marginMedium: 12
    readonly property int marginLg: marginMedium

    // Font Sizes
    readonly property int fontSizeSm: 12
    readonly property int fontSizeMd: 14
    readonly property int fontSizeLg: 16

    // Component Sizes
    readonly property int barHeight: 40
    readonly property int islandHeight: 40
    readonly property int islandRadius: 10
}