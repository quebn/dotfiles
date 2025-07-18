import qs
import qs.components
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland


Item {
    id: root
    property color mainColor: Appearance.colors.foreground
    required property var monitor

    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: 32

    RowLayout {
        id: rowLayout

        spacing: 4
        anchors.centerIn: parent

        WheelHandler {
            onWheel: event => {
                if (event.angleDelta.y < 0) {
                    monitor.setBrightness(monitor.brightness - 0.05);
                } else if (event.angleDelta.y > 0) {
                    monitor.setBrightness(monitor.brightness + 0.05);
                }
            }
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        }

        MaterialSymbol {
            text: "brightness_6"
            iconSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.foreground
        }
    }
}
