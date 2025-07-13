// From https://github.com/end-4/dots-hyprland with modifications
// License: LGPL-3.0 - A copy can be found in `licenses` folder of repo

import QtQuick
import "root:/"

/**
 * Material 3 circular progress. See https://m3.material.io/components/progress-indicators/specs
 */
Item {
    id: root

    property int size: 30
    property int line_width: 2
    property real value: 0
    property color primaryColor: Appearance.colors.primary
    property color secondaryColor: Appearance.colors.foreground
    property real gap_angle: Math.PI / 9
    property bool fill: false
    property int fill_overflow: 2
    property int animation_duration: 1000
    property var easing_type: Easing.OutCubic

    width: size
    height: size

    signal animationFinished();

    onValueChanged: {
        canvas.degree = value * 360;
    }
    onPrimaryColorChanged: {
        canvas.requestPaint();
    }
    onSecondaryColorChanged: {
        canvas.requestPaint();
    }

    Canvas {
        id: canvas

        property real degree: 0

        anchors.fill: parent
        antialiasing: true

        onDegreeChanged: {
            requestPaint();
        }

        onPaint: {
            var ctx = getContext("2d");
            var x = root.width / 2;
            var y = root.height / 2;
            var radius = root.size / 2 - root.line_width;
            var start_angle = (Math.PI / 180) * 270;
            var full_angle = (Math.PI / 180) * (270 + 360);
            var progress_angle = (Math.PI / 180) * (270 + degree);
            var epsilon = 0.01; // Small angle in radians

            ctx.reset();
            if (root.fill) {
                ctx.fillStyle = root.primary;
                ctx.beginPath();
                ctx.arc(x, y, radius + fill_overflow, start_angle, full_angle);
                ctx.fill();
            }
            ctx.lineCap = 'round';
            ctx.lineWidth = root.line_width;

            // Secondary
            ctx.beginPath();
            ctx.arc(x, y, radius, progress_angle + gap_angle, full_angle - gap_angle);
            ctx.strokeStyle = root.secondaryColor;
            ctx.stroke();

            // Primary (value indication)
            var end_angle = progress_angle + (value > 0 ? 0 : epsilon);
            ctx.beginPath();
            ctx.arc(x, y, radius, start_angle, end_angle);
            ctx.strokeStyle = root.primaryColor;
            ctx.stroke();
        }

        Behavior on degree {
            NumberAnimation {
                duration: root.animation_duration
                easing.type: root.easing_type
            }

        }

    }

}
