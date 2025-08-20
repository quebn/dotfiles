import qs
import qs.services
import qs.components
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    required property var statusbar
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(statusbar.screen)
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    property string activeWindowAddress: `0x${activeWindow?.HyprlandToplevel?.address}`
    property bool isMonitorFocus: HyprlandData.activeWorkspace?.monitor == monitor.name
    property var largestWindow: HyprlandData.biggestWindowForWorkspace(HyprlandData.monitors[root.monitor.id]?.activeWorkspace.id)

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
            text: root.isMonitorFocus && root.activeWindow?.activated && root.largestWindow ?
                root.activeWindow?.appId :
                (root.largestWindow?.class) ?? qsTr("Desktop")

        }

        StyledText {
            Layout.fillWidth: true
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.foreground
            elide: Text.ElideRight
            text: root.isMonitorFocus && root.activeWindow?.activated && root.largestWindow ?
                root.activeWindow?.title :
                (root.largestWindow?.title) ?? `${qsTr("Workspace")} ${monitor.activeWorkspace?.id}`
        }

    }

}
