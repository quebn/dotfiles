import "root:/"
import "root:/components"
import "root:/services"
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitHeight: Appearance.sizes.bar.baseHeight
    implicitWidth: rowLayout.implicitWidth + padding * 2
    height: Appearance.sizes.bar.height

    property real padding: 5
    default property alias items: rowLayout.children

    Rectangle {
        id: background
        anchors {
            fill: parent
            topMargin: 4
            bottomMargin: 4
        }
        color: Appearance.transparent ? Appearance.colors.black : Appearance.colors.layer2
        radius: Appearance.rounding.corner
    }

    RowLayout {
        id: rowLayout
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: root.padding
            rightMargin: root.padding
        }
        spacing: 4

    }
}
