import "root:/"
import "root:/components"
import "root:/services"
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property bool borderless: false
    property bool showDate: true
    implicitWidth: row_layout.implicitWidth
    implicitHeight: 32

    RowLayout {
        id: row_layout
        anchors.centerIn: parent
        spacing: 4

        StyledText {
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.foreground
            text: DateTime.time
        }

        StyledText {
            visible: true
            font.pixelSize: Appearance.font.pixelSize.large
            color: Appearance.colors.foreground
            text: "•"
        }

        StyledText {
            visible: true
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.foreground
            text: DateTime.date
        }

    }

}
