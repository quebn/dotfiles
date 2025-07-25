import qs
import qs.services
import qs.components
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Scope {
  id: root

  Variants {
    id: rootVariant
    model: Quickshell.screens

    PanelWindow {
      id: bar
      property ShellScreen modelData
      screen: modelData

      readonly property int centerSideModuleWidth: Appearance.sizes.bar.centerSideModuleWidth

      WlrLayershell.namespace: "quickshell:bar"
      color: "transparent"

      readonly property Tooltip tooltip: tooltip;
      Tooltip {
        id: tooltip
        bar: bar
      }
      // readonly property TooltipOld tooltip: tooltip;
      // TooltipOld {
      //   id: tooltip
      //   bar: bar
      // }

      readonly property int tooltipYOffset: Appearance.sizes.bar.baseHeight + Appearance.sizes.compositorGaps;

      function boundedX(targetX: real, width: real): real {
        const x = Math.max(
          barContent.anchors.leftMargin + width,
          Math.min(barContent.width + barContent.anchors.leftMargin - width, targetX)
        );
        return x;
      }

      function boundedY(targetY: real, height: real): real {
        return Math.max(
          barContent.anchors.topMargin + height,
          Math.min(barContent.height + barContent.anchors.topMargin - height, targetY)
        );
      }

      anchors {
        top: true
        bottom: false
        left: true
        right: true
      }

      implicitHeight: Appearance.sizes.bar.height + Appearance.rounding.corner
      exclusiveZone: Appearance.sizes.bar.height

      mask: Region {
        item: barContent
      }

      // mask: Region {
      //   height: root.height
      //   width: root.exclusiveZone
      // }

      Item {
        id: barContent
        anchors {
          right: parent.right
          left: parent.left
          top: parent.top
        }
        implicitHeight: Appearance.sizes.bar.height
        height: Appearance.sizes.bar.height

        Rectangle {
          id: background
          anchors {
            fill: parent
            margins: 0
          }
          color: Appearance.colors.background
          radius: 0

        }
        MouseArea {
          id: barLeft
          anchors.left: parent.left
          implicitHeight: Appearance.sizes.bar.baseHeight
          height: Appearance.sizes.bar.height
          width: (bar.width - middleSection.width) / 2

          Item {
            anchors.fill: parent
            implicitHeight: leftSection.implicitHeight
            implicitWidth: leftSection.implicitWidth

            RowLayout {
              id: leftSection
              anchors.fill: parent
              spacing: 10

              RippleButton {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.leftMargin: 10
                Layout.fillWidth: false
                property real buttonPadding: 5
                implicitWidth: distroIcon.width + buttonPadding * 2
                implicitHeight: distroIcon.height + buttonPadding * 2

                radius: Appearance.rounding.full
                toggled: true

                onPressed: {
                  Hyprland.dispatch('exec rofi -show drun -run-command "app2unit {cmd}"');
                }

                CustomIcon {
                  id: distroIcon
                  anchors.centerIn: parent
                  width: 18
                  height: 18
                  source: SystemInfo.distroIcon
                  colorize: true
                  color: Appearance.colors.blue
                }
              }

              ActiveWindow {
                visible: true
                Layout.rightMargin: Appearance.rounding.corners
                Layout.fillWidth: true
                Layout.fillHeight: true
                statusbar: bar
              }
            }
          }
        }
        RowLayout {
          id: middleSection
          anchors.centerIn: parent
          spacing: 8

          BarGroup {
            id: centerLeftGroup
            Layout.preferredWidth: bar.centerSideModuleWidth
            Layout.fillHeight: true

            Resources {
              alwaysShowAllResources: true
              Layout.fillWidth: true
            }

            Media {
              visible: true
              Layout.fillWidth: true
            }
          }

          BarGroup {
            id: centerMiddleGroup
            padding: workspaces.widgetPadding
            Layout.fillHeight: true

            Workspaces {
              id: workspaces
              bar: bar
              Layout.fillHeight: true
              // MouseArea {
              //   anchors.fill: parent
              //   acceptedButtons: Qt.RightButton
              //
              //   onPressed: event => {
              //     if (event.button === Qt.RightButton) {
              //       Hyprland.dispatch('global quickshell:overviewToggle');
              //     }
              //   }
              // }
            }
          }

          MouseArea {
            id: centerRightGroup
            implicitWidth: centerRightGroupContent.implicitWidth
            implicitHeight: centerRightGroupContent.implicitHeight
            Layout.preferredWidth: bar.centerSideModuleWidth
            Layout.fillHeight: true

            BarGroup {
              id: centerRightGroupContent
              anchors.fill: parent

              ClockWidget {
                showDate: (Config.options.bar.verbose && bar.useShortenedForm < 2)
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
              }

              CpuTemperature {
                mainColor: Appearance.colors.magenta
                visible: true
                Layout.alignment: Qt.AlignVCenter
              }

              BatteryIndicator {
                mainColor: Appearance.colors.yellow
                visible: true
                Layout.alignment: Qt.AlignVCenter
              }
            }
          }
        }
        MouseArea {
          id: barRight

          anchors.right: parent.right
          implicitHeight: Appearance.sizes.bar.baseHeight
          height: Appearance.sizes.bar.height
          width: (bar.width - middleSection.width) / 2

          Item {
            anchors.fill: parent
            implicitHeight: rightSection.implicitHeight
            implicitWidth: rightSection.implicitWidth

            RowLayout {
              id: rightSection
              anchors.fill: parent
              spacing: 5
              layoutDirection: Qt.RightToLeft

              // TODO: add onhover color change
              BrightnessControl {
              Layout.rightMargin: Appearance.sizes.compositorGaps
                visible: true
                monitor: Brightness.getMonitorForScreen(modelData)
                Layout.alignment: Qt.AlignVCenter
              }

              // TODO: add onhover color change
              Volume {
                visible: true
                Layout.alignment: Qt.AlignVCenter
              }

              SysTray {
                bar: bar
                visible: true
                Layout.fillWidth: false
                Layout.fillHeight: true
              }


              Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
              }

            }
          }
        }
      }

      Loader {
        id: roundDecorators
        anchors {
          left: parent.left
          right: parent.right
        }
        y: Appearance.sizes.bar.height
        width: parent.width
        height: Appearance.rounding.corner
        active: true

        sourceComponent: Item {
          implicitHeight: Appearance.rounding.corner
          RoundCorner {
            id: cornerLeft
            anchors {
              top: parent.top
              bottom: parent.bottom
              left: parent.left
            }
            color: Appearance.colors.background
            corner: RoundCorner.CornerEnum.TopLeft
          }
          RoundCorner {
            id: cornerRight
            anchors {
              right: parent.right
              top: parent.top
            }
            color: Appearance.colors.background
            corner: RoundCorner.CornerEnum.TopRight
          }
        }
      }
    }
  }
}
