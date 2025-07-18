import qs
import QtQuick
import QtQuick.Effects

RectangularShadow {
    required property var target
    anchors.fill: target
    radius: target.radius
    blur: 0
    offset: Qt.vector2d(0.0, 1.0)
    spread: 1
    color: "transparent"
    cached: true
}
