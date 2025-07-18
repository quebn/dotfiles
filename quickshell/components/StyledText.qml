
import qs
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Text {
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    font {
        hintingPreference: Font.PreferFullHinting
        family: Appearance?.font.family.main ?? "sans-serif"
        pixelSize: Appearance?.font.pixelSize.small ?? 16
    }
    color: Appearance?.colors.foreground ?? "white"
    linkColor: Appearance?.colors.magenta
}
