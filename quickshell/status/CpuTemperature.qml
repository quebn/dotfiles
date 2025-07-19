import qs
import qs.components
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    property color mainColor: Appearance.colors.magenta
    readonly property real usage: ResourceUsage.cpuTemp
    readonly property real percentage: usage
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

        Resource {
            iconName: "device_thermostat"
            percentage: root.percentage
            mainColor: root.mainColor
            shown: true
            suffix: "°C"
        }
    }
}
