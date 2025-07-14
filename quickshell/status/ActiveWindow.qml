import "root:/"
import "root:/services"
import "root:/components"
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    required property var statusbar
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(statusbar.screen)
    readonly property Toplevel active_window: ToplevelManager.activeToplevel

    property string active_window_address: `0x${active_window?.HyprlandToplevel?.address}`
    property bool is_monitor_focus: HyprlandData.activeWorkspace?.monitor == monitor.name
    property var largest_window: HyprlandData.biggestWindowForWorkspace(HyprlandData.monitors[root.monitor.id]?.activeWorkspace.id)

    implicitWidth: colLayout.implicitWidth

    ColumnLayout {
        id: colLayout

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: -4

        StyledText {
            Layout.fillWidth: true
            font.pixelSize: Appearance.font.pixelSize.smaller
            color: Appearance.colors.hint
            elide: Text.ElideRight
            text: root.is_monitor_focus && root.active_window?.activated && root.largest_window ?
                root.active_window?.appId :
                (root.largest_window?.class) ?? qsTr("Desktop")

        }

        StyledText {
            Layout.fillWidth: true
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.foreground
            elide: Text.ElideRight
            text: root.is_monitor_focus && root.active_window?.activated && root.largest_window ?
                root.active_window?.title :
                (root.largest_window?.title) ?? `${qsTr("Workspace")} ${monitor.activeWorkspace?.id}`
        }

    }

}
