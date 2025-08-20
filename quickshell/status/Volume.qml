import qs
import qs.components
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Item {
    id: root
    property color mainColor: root.hovered ? Appearance.colors.primary : Appearance.colors.foreground
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: 32
    property bool hovered: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onPressed: (event) => {
            Hyprland.dispatch("exec app2unit pavucontrol")
        }
    }

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
