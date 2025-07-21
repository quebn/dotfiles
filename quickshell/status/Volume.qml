import qs
import qs.components
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    property color mainColor: Appearance.colors.foreground
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: 32

    RowLayout {
        id: rowLayout

        spacing: 4
        anchors.centerIn: parent

        WheelHandler {
            onWheel: event => {
                const step = 0.05;
                if (event.angleDelta.y < 0)
                Audio.sink.audio.volume -= step;
                else if (event.angleDelta.y > 0)
                Audio.sink.audio.volume = Math.min(1, Audio.sink.audio.volume + step);
                // Store the mouse position and start tracking
                // barRightSideMouseArea.lastScrollX = event.x;
                // barRightSideMouseArea.lastScrollY = event.y;
                // barRightSideMouseArea.trackingScroll = true;
            }
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        }

        MaterialSymbol {
            text: "graphic_eq"
            iconSize: Appearance.font.pixelSize.larger
            color: Audio.sink?.audio.volume > 0 ? mainColor : Appearance.colors.hint
        }
    }
}
