import qs
import qs.services
import qs.status
import qs.components
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects

MouseArea {
    id: root

    required property var bar
    required property SystemTrayItem modelData
    readonly property bool isAlt: modelData.id == "nm-applet" || modelData.id == "blueman"
    property bool targetMenuOpen: false;

    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    cursorShape: Qt.PointingHandCursor
    Layout.fillHeight: true
    implicitWidth: Appearance.font.pixelSize.larger
    onClicked: (event) => {
        event.accepted = true;
        switch (event.button) {
            case Qt.LeftButton: {
                modelData.activate();
            } break;
            case Qt.MiddleButton: {
                modelData.secondaryActivate();
            } break;
            default: {
                if (!modelData.hasMenu) return;
                root.targetMenuOpen = !root.targetMenuOpen;
            } break;
        }
    }

    function altSymbol() {
        switch (modelData.id) {
            case "nm-applet": {
                return Network.materialSymbol
            } break;
            case "blueman": {
                return Bluetooth.materialSymbol
            } break;
            default: {
                return "question_mark"
            } break;
        }
    }

    function altColor() {
        switch (modelData.id) {
            case "nm-applet": {
                return Network.mainColor
            } break;
            case "blueman": {
                return Bluetooth.mainColor
            } break;
            default: {
                return Appearance.colors.hint
            } break;
        }
    }


    MaterialSymbol {
        id: trayIconAlt
        anchors.centerIn: parent
        visible: isAlt
        fill: 1
        text: altSymbol()
        iconSize: Appearance.font.pixelSize.larger
        color: altColor()
    }

    IconImage {
        id: trayIcon
        visible: !isAlt
        source: modelData.icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    property var tooltip: TooltipItem {
        tooltip: root.bar.tooltip
        owner: root

        show: root.containsMouse

        Text {
            id: tooltipText
            text: root.modelData.tooltipTitle != "" ? root.modelData.tooltipTitle : root.modelData.id
            color: "white"
        }
    }

    property var rightclickMenu: TooltipItem {
        id: rightclickMenu
        tooltip: root.bar.tooltip
        owner: root

        isMenu: true
        show: root.targetMenuOpen
        animateSize: !(menuContentLoader?.item?.animating ?? false)

        onClose: root.targetMenuOpen = false;

        Loader {
            id: menuContentLoader
            active: root.targetMenuOpen || rightclickMenu.visible || root.containsMouse

            // sourceComponent: PanelWindow {
            //
            //     id: menuViewWindow
            //     visible: true
            //
            //     exclusiveZone: 0
            //     implicitWidth: menuView.implicitWidth
            //     implicitHeight: menuView.implicitHeight
            //     color: "transparent"
            //     WlrLayershell.namespace: "quickshell:traymenu"
            //
            //     anchors {
            //         top: true
            //         bottom: false
            //         left: true
            //     }
            //
            //     mask: Region {
            //         item: menuView
            //     }
            //
            //     MenuView {
            //         id: menuView
            //         menu: root.modelData.menu
            //         onClose: root.targetMenuOpen = false;
            //     }
            // }

            sourceComponent: MenuView {
                menu: root.modelData.menu
                onClose: root.targetMenuOpen = false;
            }
        }
    }
}
