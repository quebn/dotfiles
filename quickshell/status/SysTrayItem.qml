import "root:/"
import "root:/services"
import "root:/components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

MouseArea {
    id: root

    required property var bar
    required property SystemTrayItem item
    property bool targetMenuOpen: false
    property int trayItemWidth: Appearance.font.pixelSize.larger

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    Layout.fillHeight: true
    implicitWidth: trayItemWidth
    onClicked: (event) => {
        switch (event.button) {
            case Qt.LeftButton: {
                item.activate();
            } break;
            case Qt.RightButton: {
                if (item.hasMenu) menu.open();
            } break;
        }
        event.accepted = true;
    }

    QsMenuAnchor {
        id: menu


        // menu: root.item.menu
        // anchor.window: this.QsWindow.window
        //
        menu: root.item.menu
        anchor.window: bar
        anchor.rect.x: root.x + bar.width
        anchor.rect.y: root.y
        anchor.rect.height: root.height
        anchor.edges: Edges.Bottom
    }

    // QsMenuHandle {
    //     id: trayHandle
    // }
    MaterialSymbol {
        id: trayIconAlt
        anchors.centerIn: parent
        visible: root.item.id == "nm-applet"
        fill: 1
        text: Network.materialSymbol
        iconSize: Appearance.font.pixelSize.larger
    }

    IconImage {
        id: trayIcon
        visible: root.item.id != "nm-applet"
        source: root.item.icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    // SysTrayMenu {
    //     trayItem: root.item.menu
    // }
}
