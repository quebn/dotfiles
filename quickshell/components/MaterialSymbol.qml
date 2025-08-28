import qs
import QtQuick
import QtQuick.Layouts

Text {
    id: root
    property real iconSize: Appearance?.font.pixelSize.small ?? 16
    property real fill: 0
    property real truncatedFill: Math.round(fill * 100) / 100 // Reduce memory consumption spikes from constant font remapping
    property string iconFont: "Material Symbols Rounded"
    renderType: Text.NativeRendering
    font {
        hintingPreference: Font.PreferFullHinting
        family: root.iconFont
        pixelSize: iconSize
        weight: Font.Normal + (Font.DemiBold - Font.Normal) * fill
        variableAxes: {
            "FILL": truncatedFill,
            // "wght": font.weight,
            // "GRAD": 0,
            "opsz": iconSize,
        }
    }
    verticalAlignment: Text.AlignVCenter
    color: Appearance.colors.foreground
}
