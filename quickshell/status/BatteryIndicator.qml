import "root:/"
import "root:/components"
import "root:/services"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
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
            implicitWidth: (isCharging ? (boltIconLoader?.item?.width ?? 0) : 0)

            Behavior on implicitWidth {
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }
        }


        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            line_width: 2
            value: percentage
            size: 26
            secondaryColor: Appearance.colors.gutter
            primaryColor: Appearance.colors.magenta
            fill: !isCharging

            // battery_0_bar
            // battery_3_bar
            // battery_charging_90
            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: "battery_full"
                iconSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.magenta
            }

        }
        StyledText {
            Layout.alignment: Qt.AlignVCenter
            color: Appearance.colors.magenta
            text: `${Math.round(percentage * 100)}%`
        }

    }
    Loader {
        id: boltIconLoader
        active: true
        anchors.left: rowLayout.left
        anchors.verticalCenter: rowLayout.verticalCenter

        Connections {
            target: root
            function onIsChargingChanged() {
                if (isCharging) boltIconLoader.active = true
            }
        }

        sourceComponent: MaterialSymbol {
            id: boltIcon
            text: "bolt"
            iconSize: Appearance.font.pixelSize.large
            color: Appearance.colors.magenta
            visible: isCharging
            onVisibleChanged: {
                if (!visible) boltIconLoader.active = false
            }

            Behavior on opacity {
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }

        }
    }
}
