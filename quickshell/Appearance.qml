import QtQuick
import Quickshell

pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    property QtObject colortheme
    property QtObject animation
    property QtObject animationCurves
    property QtObject colors
    property QtObject materials
    property QtObject rounding
    property QtObject font
    property QtObject sizes
    readonly property bool transparent: true

    colortheme: QtObject {
        property color base:             "#000000"
        property color surface:          "#110D12"
        property color overlay:          "#121212"
        property color base_alt:         "#191724"
        property color surface_alt:      "#1f1d2e"
        property color overlay_alt:      "#26233a"
        property color muted:            "#6e6a86"
        property color subtle:           "#908caa"
        property color text:             "#e0def4"
        property color love:             "#eb6f92"
        property color gold:             "#f6c177"
        property color rose:             "#ebbcba"
        property color pine:             "#31748f"
        property color foam:             "#9ccfd8"
        property color iris:             "#c4a7e7"
        property color highlight_low:    "#21202e"
        property color highlight_medium: "#403d52"
        property color highlight_high:   "#524f67"
    }

    colors: QtObject {
        property color background: root.transparent ? Qt.rgba(0, 0, 0, .90) : colortheme.base
        property color foreground: colortheme.text
        property color gutter: colortheme.highlight_medium
        property color gutter_alt: colortheme.highlight_low
        property color layer1: colortheme.surface
        property color layer2: colortheme.overlay
        property color layer1_alt: colortheme.surface_alt
        property color layer2_alt: colortheme.overlay_alt
        property color hint: colortheme.subtle
        property color border: colortheme.highlight_high
        property color separator: colors.border
        property color hover: colortheme.foam
        property color primary: colortheme.pine
        property color secondary: colortheme.rose
        property color tertiary: colortheme.foam
        property color black: colortheme.base
        property color white: colortheme.text
        property color red: colortheme.love
        property color yellow: colortheme.gold
        property color cyan: colortheme.rose
        property color green: colortheme.pine
        property color blue: colortheme.foam
        property color magenta: colortheme.iris
    }

    materials: QtObject {
        property bool darkmode: true
        property bool transparent: false
        property color primary_pallete: "#91689E"
        property color secondary_pallete: "#837186"
        property color tertiary_pallete: "#9D6A67"
        property color neutral_pallete: "#7C757B"
        property color neutral_alt_pallete: "#7D747D"
        property color background: colors.background
        property color on_background: colors.foreground
        property color surface: colortheme.surface
        property color surface_dim: colors.background
        property color surface_bright: "#3D373D"
        property color surface_container_lowest: "#110D12"
        property color surface_container_low: "#1F1A1F"
        property color surface_container: "#231E23"
        property color surface_container_high: "#2D282E"
        property color surface_container_highest: "#383339"
        property color on_surface: "#EAE0E7"
        property color surface_variant: "#4C444D"
        property color on_surface_variant: "#CFC3CD"
        property color inverse_surface: "#EAE0E7"
        property color inverse_on_surface: "#342F34"
        property color outline: "#988E97"
        property color outline_variant: "#4C444D"
        property color shadow: "#000000"
        property color scrim: "#000000"
        property color surface_tint: colors.primary
        property color primary: colors.primary
        property color on_primary: colors.black
        property color primary_container: "#5D386A"
        property color on_primary_container: "#F9D8FF"
        property color inverse_primary: "#775084"
        property color secondary: "#D5C0D7"
        property color on_secondary: "#392C3D"
        property color secondary_container: "#534457"
        property color on_secondary_container: "#F2DCF3"
        property color tertiary: "#F5B7B3"
        property color on_tertiary: "#4C2523"
        property color tertiary_container: "#BA837F"
        property color on_tertiary_container: "#000000"
        property color error: "#FFB4AB"
        property color on_error: "#690005"
        property color error_container: "#93000A"
        property color on_error_container: "#FFDAD6"
        property color primary_fixed: "#F9D8FF"
        property color primary_fixed_dim: "#E5B6F2"
        property color on_primary_fixed: "#2E0A3C"
        property color on_primary_fixed_variant: "#5D386A"
        property color secondary_fixed: "#F2DCF3"
        property color secondary_fixed_dim: "#D5C0D7"
        property color on_secondary_fixed: "#241727"
        property color on_secondary_fixed_varian: "#514254"
        property color tertiary_fixed: "#FFDAD7"
        property color tertiary_fixed_dim: "#F5B7B3"
        property color on_tertiary_fixed: "#331110"
        property color on_tertiary_fixed_variant: "#663B39"
        property color success: "#B5CCBA"
        property color on_success: "#213528"
        property color success_container: "#374B3E"
        property color on_success_container: "#D1E9D6"
        property color term0: "#EDE4E4"
        property color term1: "#B52755"
        property color term2: "#A97363"
        property color term3: "#AF535D"
        property color term4: "#A67F7C"
        property color term5: "#B2416B"
        property color term6: "#8D76AD"
        property color term7: "#272022"
        property color term8: "#0E0D0D"
        property color term9: "#B52755"
        property color term10: "#A97363"
        property color term11: "#AF535D"
        property color term12: "#A67F7C"
        property color term13: "#B2416B"
        property color term14: "#8D76AD"
        property color term15: "#221A1A"
    }

    rounding: QtObject {
        property int unsharpen: 2
        property int corner: 12
        property int full: 9999
        property int button: 6
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: "Zx Gamut Semi Bold"
            property string title: "Zx Gamut Extra Bold"
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: "JetBrainsMono NL ExtraBold"
            property string monospace: "0xProto"
            property string reading: "ZxGamut"
        }

        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int small: 14
            property int normal: 16
            property int large: 18
            property int larger: 20
            property int huge: 22
            property int hugeass: 24
            property int title: huge
        }
    }

    sizes: QtObject {
        property real bar_base_height: 40
        property real bar_height: bar_base_height
        property real bar_center_side_module_width:  360
        property real bar_center_side_module_width_short: 280
        property real barCenterSideModuleWidthHellaShortened: 190
        property real barShortenScreenWidthThreshold: 1200 // Shorten if screen width is at most this value
        property real barHellaShortenScreenWidthThreshold: 1000 // Shorten even more...
        property real sidebarWidth: 460
        property real sidebarWidthExtended: 750
        property real osdWidth: 200
        property real mediaControlsWidth: 440
        property real mediaControlsHeight: 160
        property real notificationPopupWidth: 410
        property real searchWidthCollapsed: 260
        property real searchWidth: 450
        property real hyprland_gaps_out: 10
        property real fabShadowRadius: 5
        property real fabHoveredShadowRadius: 7
        property real elevationMargin: 10
    }

    animationCurves: QtObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1] // Default, 350ms
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1] // Default, 500ms
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1] // Default, 650ms
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1] // Default, 200ms
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        readonly property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property real expressiveFastSpatialDuration: 350
        readonly property real expressiveDefaultSpatialDuration: 500
        readonly property real expressiveSlowSpatialDuration: 650
        readonly property real expressiveEffectsDuration: 200
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
            property Component colorAnimation: Component {
                ColorAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }
        property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }
        property QtObject elementMoveExit: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedAccel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveExit.duration
                    easing.type: root.animation.elementMoveExit.type
                    easing.bezierCurve: root.animation.elementMoveExit.bezierCurve
                }
            }
        }
        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property int velocity: 850
            property Component colorAnimation: Component { ColorAnimation {
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
            property Component numberAnimation: Component { NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
        }

        property QtObject clickBounce: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveFastSpatial
            property int velocity: 850
            property Component numberAnimation: Component { NumberAnimation {
                    duration: root.animation.clickBounce.duration
                    easing.type: root.animation.clickBounce.type
                    easing.bezierCurve: root.animation.clickBounce.bezierCurve
            }}
        }
        property QtObject scroll: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
        }
        property QtObject menuDecel: QtObject {
            property int duration: 350
            property int type: Easing.OutExpo
        }
    }
}
