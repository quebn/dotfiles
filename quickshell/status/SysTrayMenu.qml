pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.services
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    required property bool menuOpen
    required property QsMenuHandle menuHandle

    implicitWidth: 300
    implicitHeight: 300

    anchors.margins: Appearance.sizes.elevationMargin * 2

    Rectangle {
        id: background
        anchors.fill: parent
        border.color: Appearance.colors.border
        border.width: 1
        color: Appearance.colors.background
        radius: Appearance?.rounding.corner

    }

}
