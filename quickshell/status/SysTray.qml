import qs
import qs.components

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import Quickshell.Widgets

Item {
    id: root

    required property var bar

    height: parent.height
    implicitWidth: rowLayout.implicitWidth
    Layout.rightMargin: 4

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        spacing: 10

        Repeater {
            model: SystemTray.items
            SysTrayItem {
                id: trayItem
                bar: root.bar
            }

        }
    }
}
