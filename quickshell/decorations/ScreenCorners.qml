import qs
import qs.components
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: screenCorners
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    Variants {
        model: Quickshell.screens

        PanelWindow {
            visible: true

            property var modelData

            screen: modelData
            exclusionMode: ExclusionMode.Ignore
            mask: Region {
                item: null
            }
            // HyprlandWindow.visibleMask: Region {
            //     Region {
            //         item: topLeftCorner
            //     }
            //     Region {
            //         item: topRightCorner
            //     }
            //     Region {
            //         item: bottomLeftCorner
            //     }
            //     Region {
            //         item: bottomRightCorner
            //     }
            // }
            WlrLayershell.namespace: "quickshell:screen_corners"
            WlrLayershell.layer: WlrLayer.Overlay
            color: "transparent" // NOTE: do not remove

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            RoundCorner {
                id: botleft_corner
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                corner: RoundCorner.CornerEnum.BottomLeft
            }
            RoundCorner {
                id: botright_corner
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                corner: RoundCorner.CornerEnum.BottomRight
            }

        }

    }

}
