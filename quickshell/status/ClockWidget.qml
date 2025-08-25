import qs
import qs.components
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property bool borderless: false
    property bool showDate: true
    property color mainColor: Appearance.colors.foreground
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: 32

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 4

        StyledText {
            font.pixelSize: Appearance.font.pixelSize.large
            color: root.mainColor
            text: DateTime.time
        }

        StyledText {
            visible: true
            font.pixelSize: Appearance.font.pixelSize.large
            color: root.mainColor
            text: " • "
        }

        StyledText {
            visible: true
            font.pixelSize: Appearance.font.pixelSize.small
            color: root.mainColor
            text: DateTime.date
        }

    }

}
