import "root:/"
import "root:/components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    required property string iconName
    required property double percentage
    property color mainColor
    property int iconSize: Appearance.font.pixelSize.normal
    property bool shown: true
    clip: true
    visible: true
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height

    RowLayout {
        spacing: 4
        id: resourceRowLayout
        x: 0

        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            lineWidth: 2
            value: percentage
            size: 26
            secondaryColor: Appearance.colors.gutter
            primaryColor: mainColor

            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: iconName
                iconSize: iconSize
                color: mainColor
            }

        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            color: mainColor
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
