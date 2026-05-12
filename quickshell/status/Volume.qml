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
    required property var bar
    property color mainColor: root.hovered ? Appearance.colors.primary : Appearance.colors.foreground
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: 32
    property bool showValue: false
    property bool hovered: false
    readonly property string tooltipTextValue: {
        if (showValue) {
            return `Volume: ${Math.round((Audio.sink?.audio.volume ?? 0) * 100)}%`;
        }
        return "Volume";
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            root.showValue = false
            root.hovered = true
        }
        onExited: {
            root.hovered = false
        }
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: (event) => {
            if (event.button === Qt.LeftButton) {
                Hyprland.dispatch(`hl.dsp.exec_cmd("runapp pavucontrol")`)
            } else {
                root.showValue = !root.showValue;
            }
        }
    }

    RowLayout {
        id: rowLayout

        spacing: 4
        anchors.centerIn: parent

        WheelHandler {
            onWheel: event => {
                hovered = false;
                const step = 0.05;
                if (event.angleDelta.y < 0) {
                    Audio.sink.audio.volume -= step;
                } else if (event.angleDelta.y > 0) {
                    Audio.sink.audio.volume = Math.min(1, Audio.sink.audio.volume + step);
                }
            }
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        }

        MaterialSymbol {
            id: symbol
            text: "graphic_eq"
            iconSize: Appearance.font.pixelSize.larger
            color: Audio.sink?.audio.volume > 0 ? mainColor : Appearance.colors.hint
        }
    }

    property var tooltip: TooltipItem {
        tooltip: root.bar.tooltip
        owner: root
        show: root.hovered

        StyledText {
            id: tooltipText
            text: root.tooltipTextValue
            font.pixelSize: Appearance?.font.pixelSize.small
            color: Appearance.colors.foreground
        }
    }
}
