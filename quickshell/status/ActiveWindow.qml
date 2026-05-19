import qs
import qs.services
import qs.components
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

MouseArea {
    id: root
    hoverEnabled: true
    onEntered: root.hovered = true
    onExited:  root.hovered  = false
    cursorShape: Qt.PointingHandCursor

    required property var bar
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen)
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    property string activeWindowAddress: `0x${activeWindow?.HyprlandToplevel?.address}`
    property bool isMonitorFocus: HyprlandData.activeWorkspace?.monitor == monitor.name
    property var largestWindow: HyprlandData.biggestWindowForWorkspace(HyprlandData.monitors[root.monitor.id]?.activeWorkspace.id)
    property bool hovered: false

    implicitWidth: colLayout.implicitWidth

    function activeWindowTitle() {
        if (root.isMonitorFocus && root.activeWindow?.activated && root.largestWindow) {
            return root.activeWindow?.title;
        }
        return `${qsTr("Workspace")} ${monitor.activeWorkspace?.id}`;
    }

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
            text: root.isMonitorFocus && root.activeWindow?.activated && root.largestWindow
                ? root.activeWindow?.appId
                : (root.largestWindow?.class) ?? qsTr("Desktop")

        }

        StyledText {
            Layout.fillWidth: true
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.foreground
            elide: Text.ElideRight
            text: activeWindowTitle()
        }


    }


    property var tooltip: TooltipItem {
        tooltip: root.bar.tooltip
        owner: root

        show: root.hovered

        StyledText {
            id: tooltipText
            text: activeWindowTitle()
            font.pixelSize: Appearance?.font.pixelSize.small
            color: Appearance.colors.foreground
        }
    }

}
