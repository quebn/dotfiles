import qs
import qs.components
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Hyprland

Item {
    id: root
    property bool borderless: false
    property bool alwaysShowAllResources: false
    implicitWidth: rowLayout.implicitWidth + rowLayout.anchors.leftMargin + rowLayout.anchors.rightMargin
    implicitHeight: 32

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onPressed: (event) => {
            Hyprland.dispatch("exec app2unit kitty --start-as=fullscreen --title btop sh -c 'btop'")
        }
    }
    RowLayout {
        id: rowLayout

        spacing: 0
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4

        Resource {
            // icon_name: "memory_alt"
            // "view_agenda"
            iconName: "view_stream"
            percentage: ResourceUsage.memoryUsedPercentage
            mainColor: Appearance.colors.cyan
            shown: true
        }

        Resource {
            visible: false
            iconName: "swap_horiz"
            percentage: ResourceUsage.swapUsedPercentage
            mainColor: Appearance.colors.magenta
            Layout.leftMargin: 4
        }

        Resource {
            iconName: "memory"
            percentage: ResourceUsage.cpuUsage
            mainColor: Appearance.colors.green
            shown: true
        }

    }

}
