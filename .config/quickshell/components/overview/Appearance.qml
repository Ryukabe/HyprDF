pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "functions"

// Adapter for the overview module's Appearance.* API surface.
// Deliberately does NOT bring in the uploaded Appearance.qml's own
// matugen/caelestia color pipeline — HyprDF already has one reactive
// palette (Colors.qml, 18 tokens, driven by your Theme Switcher). Running
// two parallel color systems means this module silently stops matching
// your theme the moment you switch palettes. Everything below just
// re-exposes Colors / Dimens / Fonts under the property names
// OverviewWidget.qml and OverviewWindow.qml already expect, so those two
// files are unmodified below their import line.
Singleton {
    id: root

    property QtObject m3colors: QtObject {
        property color m3outline: Colors.border
        property color m3onBackground: Colors.fg
    }

    property QtObject colors: QtObject {
        property color colSubtext: Colors.subtext
        property color colLayer0: Colors.bg
        property color colOnLayer0: Colors.fg
        property color colLayer0Border: Colors.border
        property color colLayer1: Colors.bgSurface
        property color colOnLayer1: Colors.fg
        property color colOnLayer1Inactive: Colors.fgMuted
        property color colLayer1Hover: ColorUtils.mix(Colors.bgSurface, Colors.fg, 0.92)
        property color colLayer1Active: ColorUtils.mix(Colors.bgSurface, Colors.fg, 0.85)
        property color colLayer2: Colors.surface
        property color colOnLayer2: Colors.fg
        property color colLayer2Hover: ColorUtils.mix(Colors.surface, Colors.fg, 0.90)
        property color colLayer2Active: ColorUtils.mix(Colors.surface, Colors.fg, 0.80)
        // the one field missing from the Appearance.qml you uploaded —
        // OverviewWidget.qml references it for window-tile borders
        property color colLayer2Border: Colors.border
        property color colPrimary: Colors.accent
        property color colOnPrimary: Colors.bg
        property color colSecondary: Colors.accent
        property color colSecondaryContainer: ColorUtils.mix(Colors.accent, Colors.bg, 0.22)
        property color colOnSecondaryContainer: Colors.fg
        property color colTooltip: Colors.surface
        property color colOnTooltip: Colors.fg
        property color colShadow: ColorUtils.transparentize(Colors.black, 0.7)
        property color colOutline: Colors.border
    }

    property QtObject rounding: QtObject {
        property int verysmall: Math.max(1, Math.round(Dimens.borderRadiusSmall * 0.6))
        property int normal: Dimens.borderRadiusMedium
        property int screenRounding: Dimens.borderRadiusLarge
        property int windowRounding: Dimens.borderRadiusSmall
    }

    property QtObject font: QtObject {
        property QtObject family: QtObject {
            property string main: Fonts.text
            property string title: Fonts.text
            property string expressive: Fonts.display
        }
        property QtObject pixelSize: QtObject {
            property int smaller: Math.round(Dimens.fontSizeSm * 0.85)
            property int small: Dimens.fontSizeSm
            property int normal: Dimens.fontSizeMd
            property int larger: Dimens.fontSizeLg
            // background workspace-number glyph — no equivalent tier in
            // Dimens, scaled off fontSizeLg; tune directly if it looks off
            property int huge: Dimens.fontSizeLg * 3
        }
    }

    property QtObject sizes: QtObject {
        property real elevationMargin: Dimens.spacingMedium
    }

    // Same duration/easing convention as Bar.qml's island morph: no
    // bounce/overshoot, short critically-damped curves for opacity.
    property QtObject animation: QtObject {
        property QtObject elementMoveEnter: QtObject {
            property int duration: 340
            property int type: Easing.OutCubic
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                }
            }
        }
        property QtObject elementMoveFast: QtObject {
            property int duration: 180
            property int type: Easing.OutCubic
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                }
            }
        }
    }
}
