import "root:/"
import "root:/components"
import "root:/services"
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitHeight: Appearance.sizes.bar_base_height
    implicitWidth: row_layout.implicitWidth + padding * 2
    height: Appearance.sizes.bar_height

    property real padding: 5
    default property alias items: row_layout.children

    Rectangle {
        id: background
        anchors {
            fill: parent
            topMargin: 4
            bottomMargin: 4
        }
        color: Appearance.colors.layer2
        radius: Appearance.rounding.corner
    }

    RowLayout {
        id: row_layout
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
