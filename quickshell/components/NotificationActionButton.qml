import "root:/"
import "root:/services"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

RippleButton {
    id: button
    property string buttonText
    property string urgency

    implicitHeight: 30
    leftPadding: 15
    rightPadding: 15
    radius: Appearance.rounding.corner
    bg: Appearance.colors.background
    bgHover: Appearance.colors.primary
    colRipple: Appearance.colors.primary

    contentItem: StyledText {
        horizontalAlignment: Text.AlignHCenter
        text: buttonText
        color: Appearance.colors.foreground
    }
}
