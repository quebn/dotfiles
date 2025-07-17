import "root:/"
import "root:/components"

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import Quickshell.Widgets

// TODO: More fancy animation
Item {
    id: root

    required property var bar

    height: parent.height
    implicitWidth: rowLayout.implicitWidth
    Layout.rightMargin: 4

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        spacing: 15

        Repeater {
            model: SystemTray.items
            SysTrayItem {
                required property SystemTrayItem modelData
                bar: root.bar
                item: modelData
            }

        }
    }
}
