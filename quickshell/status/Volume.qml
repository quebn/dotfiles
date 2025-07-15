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

        WheelHandler {
            onWheel: event => {
                const currentVolume = Audio.value;
                const step = 0.2;
                if (event.angleDelta.y < 0)
                Audio.sink.audio.volume -= step;
                else if (event.angleDelta.y > 0)
                Audio.sink.audio.volume = Math.min(1, Audio.sink.audio.volume + step);
                // Store the mouse position and start tracking
                barRightSideMouseArea.lastScrollX = event.x;
                barRightSideMouseArea.lastScrollY = event.y;
                barRightSideMouseArea.trackingScroll = true;
            }
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        }

        MaterialSymbol {
            text: "graphic_eq"
            iconSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.foreground
        }
    }
}
