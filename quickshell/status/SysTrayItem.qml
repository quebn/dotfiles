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
                modelData.activate();
            } break;
            default: {
                if (!modelData.hasMenu) return;
                // if (root.prevOpenMenu) {
                //     root.prevOpenMenu.targetMenuOpen = false;
                // }
                root.targetMenuOpen = !root.targetMenuOpen;
                // root.prevOpenMenu = root;
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

    QsMenuAnchor {
        id: menuAnchor
        menu: modelData.menu
        anchor.window: bar
    }

    // property var rightclickMenu: TooltipItem {
    //     id: rightclickMenu
    //     tooltip: bar.tooltip
    //     owner: root
    //
    //     isMenu: true
    //     show: root.targetMenuOpen
    //     animateSize: !(menuContentLoader?.item?.animating ?? false)
    //
    //     onClose: root.targetMenuOpen = false;
    //
    //     Loader {
    //         id: menuContentLoader
    //         active: root.targetMenuOpen || rightclickMenu.visible || root.containsMouse
    //
    //         sourceComponent: MenuView {
    //             menu: modelData.menu
    //             onClose: root.targetMenuOpen = false;
    //         }
    //     }
    // }

    Loader {
        id: systrayMenuLoader
        active: root.targetMenuOpen

        sourceComponent: PanelWindow {
            id: systrayMenuWindow
            visible: true

            exclusiveZone: 0
            implicitWidth: systrayMenu.implicitWidth
            implicitHeight: systrayMenu.implicitHeight
            color: "transparent"
            WlrLayershell.namespace: `traymenu${root.modelData.id}`

            anchors {
                top: true
                bottom: false
                right: true
            }

            mask: Region {
                item: systrayMenu
            }

            SysTrayMenu {
                id: systrayMenu
                menuOpen: root.targetMenuOpen
                trayItem: modelData.menu
            }

        }
    }
}
