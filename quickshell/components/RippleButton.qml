import "root:/"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets

/**
 * INFO: A button with ripple effect similar to in Material Design.
 */
Button {
    id: root
    property bool toggled
    property string text_button
    property real radius: Appearance?.rounding?.button ?? 4
    property real pressed_radius: root.radius
    property real effective_radius: root.down ? root.pressed_radius : root.radius
    property int anim_duration: 1200
    property bool anim_enabled: true
    property var action_down // When left clicking (down)
    property var action_release // When left clicking (release)
    property var action_alt // When right clicking
    property var action_midclick // When middle clicking

    property color bg: Appearance.colors.background
    property color bg_hover: root.bg
    property color bg_toggled: root.bg
    property color bg_toggled_hover: root.bg
    property color col_ripple: Appearance.colors.primary
    property color col_ripple_toggled: Appearance.colors.hover

    property color buttonColor: root.enabled ? (root.toggled ?
        (root.hovered ? bg_toggled_hover :
            bg_toggled) :
        (root.hovered ? bg_hover :
            bg)) : bg
    property color ripple_color: root.toggled ? col_ripple_toggled : col_ripple

    function start_ripple(x, y) {
        const state_y = button_background.y;
        animation.x = x;
        animation.y = y - state_y;

        const dist = (ox,oy) => ox*ox + oy*oy
        const end_state_y = state_y + button_background.height
        animation.radius = Math.sqrt(Math.max(
            dist(0, state_y),
            dist(0, end_state_y),
            dist(width, state_y),
            dist(width, end_state_y)
        ))

        animation_fade.complete();
        animation.restart();
    }

    component RippleAnim: NumberAnimation {
        duration: anim_duration
        easing.type: Appearance?.animation.elementMoveEnter.type
        easing.bezierCurve: Appearance?.animationCurves.standardDecel
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onPressed: (event) => {
            if(event.button === Qt.RightButton) {
                if (root.action_alt) root.action_alt();
                return;
            }
            if(event.button === Qt.MiddleButton) {
                if (root.action_midclick) root.action_midclick();
                return;
            }
            root.down = true
            if (root.action_down) root.action_down();
            if (!root.anim_enabled) return;
            const {x,y} = event
            start_ripple(x, y)
        }
        onReleased: (event) => {
            root.down = false
            if (event.button != Qt.LeftButton) return;
            if (root.action_release) root.action_release();
            root.click() // Because the MouseArea already consumed the event
            if (!root.anim_enabled) return;
            animation_fade.restart();
        }
        onCanceled: (event) => {
            root.down = false
            if (!root.anim_enabled) return;
            animation_fade.restart();
        }
    }

    RippleAnim {
        id: animation_fade
        target: ripple
        property: "opacity"
        to: 0
    }

    SequentialAnimation {
        id: animation

        property real x
        property real y
        property real radius

        PropertyAction {
            target: ripple
            property: "x"
            value: animation.x
        }
        PropertyAction {
            target: ripple
            property: "y"
            value: animation.y
        }
        PropertyAction {
            target: ripple
            property: "opacity"
            value: 1
        }
        ParallelAnimation {
            RippleAnim {
                target: ripple
                properties: "implicitWidth,implicitHeight"
                from: 0
                to: animation.radius * 2
            }
        }
    }

    background: Rectangle {
        id: button_background
        radius: root.effective_radius
        implicitHeight: 50

        color: root.buttonColor
        Behavior on color {
            animation: Appearance?.animation.elementMoveFast.colorAnimation.createObject(this)
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: button_background.width
                height: button_background.height
                radius: root.effective_radius
            }
        }

        Item {
            id: ripple
            width: ripple.implicitWidth
            height: ripple.implicitHeight
            opacity: 0
            visible: width > 0 && height > 0

            property real implicitWidth: 0
            property real implicitHeight: 0

            Behavior on opacity {
                animation: Appearance?.animation.elementMoveFast.colorAnimation.createObject(this)
            }

            RadialGradient {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: root.ripple_color }
                    GradientStop { position: 0.3; color: root.ripple_color }
                    GradientStop { position: 0.5; color: Qt.rgba(root.ripple_color.r, root.ripple_color.g, root.ripple_color.b, 0) }
                }
            }

            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }
    }

    contentItem: StyledText {
        text: root.text_button
    }
}
