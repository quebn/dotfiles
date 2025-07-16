import "root:/"
import "root:/components"
import "root:/services"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    property color mainColor: Appearance.colors.magenta
    readonly property real networkStrength: Network.networkStrength
    readonly property real percentage: networkStrength * 0.01
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: 32

    RowLayout {
        id: rowLayout

        spacing: 4
        anchors.centerIn: parent

        Rectangle {
            implicitWidth: 0

            Behavior on implicitWidth {
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }
        }


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
                text: Network.materialSymbol
                iconSize: Appearance.font.pixelSize.normal
                color: mainColor
            }

        }
        StyledText {
            Layout.alignment: Qt.AlignVCenter
            color: mainColor
            text: `${networkStrength}%`
        }

    }
}
