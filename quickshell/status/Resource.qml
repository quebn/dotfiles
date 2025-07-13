import "root:/"
import "root:/components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    required property string icon_name
    required property double percentage
    property color main_color
    property bool shown: true
    clip: true
    visible: width > 0 && height > 0
    implicitWidth: resourceRowLayout.x < 0 ? 0 : childrenRect.width
    implicitHeight: childrenRect.height

    RowLayout {
        spacing: 4
        id: resourceRowLayout
        x: shown ? 0 : -resourceRowLayout.width

        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            line_width: 2
            value: percentage
            size: 26
            secondaryColor: Appearance.colors.gutter
            primaryColor: main_color

            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: icon_name
                iconSize: Appearance.font.pixelSize.normal
                color: main_color
            }

        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            color: main_color
            text: `${Math.round(percentage * 100)}%`
        }

        Behavior on x {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }

    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
            easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }
}
