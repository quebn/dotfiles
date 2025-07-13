import "root:/"
import "root:/components"
import "root:/services"

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Item {
    id: root
    property bool borderless: false
    property bool alwaysShowAllResources: false
    implicitWidth: row_layout.implicitWidth + row_layout.anchors.leftMargin + row_layout.anchors.rightMargin
    implicitHeight: 32

    RowLayout {
        id: row_layout

        spacing: 0
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4

        Resource {
            icon_name: "memory_alt"
            percentage: ResourceUsage.memory_used_percentage
            main_color: Appearance.colors.cyan
            shown: true
        }

        // Resource {
        //     icon_name: "swap_horiz"
        //     percentage: ResourceUsage.swap_used_percentage
        //     main_color: Appearance.colors.magenta
        //     shown: root.alwaysShowAllResources
        //     Layout.leftMargin: shown ? 4 : 0
        // }

        Resource {
            icon_name: "memory"
            percentage: ResourceUsage.cpu_usage
            main_color: Appearance.colors.green
            shown: true
            Layout.leftMargin: shown ? 4 : 0
        }

    }

}
