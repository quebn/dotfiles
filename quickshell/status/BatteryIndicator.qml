import qs
import qs.components
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    property color mainColor: Appearance.colors.foreground
    readonly property var chargeState: Battery.chargeState
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isPluggedIn: Battery.isPluggedIn
    readonly property real percentage: Battery.percentage
    readonly property bool isLow: percentage <= Config.options.battery.low / 100

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
            iconFont: "Symbols Nerd Font"
            iconName: Battery.nerdSymbol
            percentage: root.percentage
            mainColor: root.mainColor
            shown: true
        }

    }
    // Loader {
    //     id: boltIconLoader
    //     active: true
    //     anchors.left: rowLayout.left
    //     anchors.verticalCenter: rowLayout.verticalCenter
    //
    //     Connections {
    //         target: root
    //         function onIsChargingChanged() {
    //             if (isCharging) boltIconLoader.active = true
    //         }
    //     }
    //
    //     sourceComponent: MaterialSymbol {
    //         id: boltIcon
    //         text: "bolt"
    //         iconSize: Appearance.font.pixelSize.large
    //         color: mainColor
    //         visible: root.isCharging
    //         onVisibleChanged: {
    //             if (!visible) boltIconLoader.active = false
    //         }
    //
    //         Behavior on opacity {
    //             animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
    //         }
    //     }
    // }
}
