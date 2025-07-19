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
    property QtObject rounding
    property QtObject font
    property QtObject sizes
    readonly property bool transparent: true

    colortheme: QtObject {
        property color base:             "#000000"
        property color surface:          "#110D12"
        property color overlay:          "#121212"
        property color baseAlt:          "#191724"
        property color surfaceAlt:       "#1f1d2e"
        property color overlayAlt:       "#26233a"
        property color muted:            "#6e6a86"
        property color subtle:           "#908caa"
        property color text:             "#e0def4"
        property color love:             "#eb6f92"
        property color gold:             "#f6c177"
        property color rose:             "#ebbcba"
        property color pine:             "#31748f"
        property color foam:             "#9ccfd8"
        property color iris:             "#c4a7e7"
        property color highlightLow:     "#21202e"
        property color highlightMedium:  "#403d52"
        property color highlightHigh:    "#524f67"
    }

    colors: QtObject {
        property color background: root.transparent ? Qt.rgba(0, 0, 0, .9) : colortheme.base
        property color foreground: colortheme.text
        property color gutter: colortheme.highlightMedium
        property color gutterAlt: colortheme.highlightLow
        property color backgroundAlt: colortheme.baseAlt
        property color layer1: colortheme.surface
        property color layer2: colortheme.overlay
        property color layer1Alt: colortheme.surfaceAlt
        property color layer2Alt: colortheme.overlayAlt
        property color hint: colortheme.subtle
        property color hintAlt: colortheme.muted
        property color border: colors.layer2Alt
        property color borderAlt: colortheme.highlightHigh
        property color separator: colors.border
        property color error: colortheme.love
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
        property QtObject bar: QtObject {
            property real baseHeight: 40
            property real height: root.sizes.bar.baseHeight
            property real centerSideModuleWidth: 360
            property real centerSideModuleWidthShort: 280
            property real centerSideModuleWidthShortest: 190
            property real shortenScreenWidthThreshold: 1200
            property real hellaShortenScreenWidthThreshold: 1000
        }
        property real sidebarWidth: 460
        property real sidebarWidthExtended: 750
        property real osdWidth: 200
        property real mediaControlsWidth: 440
        property real mediaControlsHeight: 160
        property real notificationPopupWidth: 410
        property real searchWidthCollapsed: 260
        property real searchWidth: 450
        property real compositorGaps: 10
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
