import "root:/"
import Quickshell.Widgets
import QtQuick

ClippingRectangle {
    id: root

    color: "transparent"

    Behavior on color {
        ColorAnimation {
            duration: 400
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animation.elementMoveEnter.bezierCurve
        }
    }
}
