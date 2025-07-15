// Bar.qml
import "root:/"
import "root:/services"
import "root:/components"
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Scope {
  id: bar

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar_root
      property var modelData
      screen: modelData

      readonly property int center_side_module_width: Appearance.sizes.bar_center_side_module_width

      WlrLayershell.namespace: "quickshell:statusbar"
      color: "transparent"

      anchors {
        top: true
        bottom: false
        left: true
        right: true
      }

      implicitHeight: Appearance.sizes.bar_height + Appearance.rounding.corner
      exclusiveZone: Appearance.sizes.bar_base_height
      mask: Region {
        item: bar_content
      }

      Item {
        id: bar_content
        anchors {
          right: parent.right
          left: parent.left
          top: parent.top
          bottom: undefined
        }
        implicitHeight: Appearance.sizes.bar_height
        height: Appearance.sizes.bar_height

        Rectangle {
          id: background
          anchors {
            fill: parent
            margins: 0
          }
          color: Appearance.colors.background
          radius: 0

        }
        // MARK: left section
        MouseArea {
          id: bar_left
          anchors.left: parent.left
          implicitHeight: Appearance.sizes.bar_base_height
          height: Appearance.sizes.bar_height
          width: (bar_root.width - middle_section.width) / 2

          Item {
            anchors.fill: parent
            implicitHeight: left_section.implicitHeight
            implicitWidth: left_section.implicitWidth

            // ScrollHint {
            //   reveal: barLeftSideMouseArea.hovered
            //   icon: "light_mode"
            //   tooltipText: qsTr("Scroll to change brightness")
            //   side: "left"
            //   anchors.left: parent.left
            //   anchors.verticalCenter: parent.verticalCenter
            // }

            RowLayout {
              id: left_section
              anchors.fill: parent
              spacing: 10

              RippleButton {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.leftMargin: 10
                Layout.fillWidth: false
                property real button_padding: 5
                implicitWidth: distro_icon.width + button_padding * 2
                implicitHeight: distro_icon.height + button_padding * 2

                radius: Appearance.rounding.full
                toggled: true

                onPressed: {
                  Hyprland.dispatch('exec rofi -show drun');
                }

                CustomIcon {
                  id: distro_icon
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
                statusbar: bar_root
              }
            }
          }
        }
        // MARK: Middle section
        RowLayout {
          id: middle_section
          anchors.centerIn: parent
          spacing: 8

          BarGroup {
            id: center_left_group
            Layout.preferredWidth: bar_root.center_side_module_width
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
            id: center_middle_group
            padding: workspaces.widgetPadding
            Layout.fillHeight: true

            Workspaces {
              id: workspaces
              bar: bar_root
              Layout.fillHeight: true
              MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton

                onPressed: event => {
                  if (event.button === Qt.RightButton) {
                    Hyprland.dispatch('global quickshell:overviewToggle');
                  }
                }
              }
            }
          }

          MouseArea {
            id: center_right_group
            implicitWidth: center_right_group_content.implicitWidth
            implicitHeight: center_right_group_content.implicitHeight
            Layout.preferredWidth: bar_root.center_side_module_width
            Layout.fillHeight: true

            // onPressed: {
            //   Hyprland.dispatch('global quickshell:sidebarRightToggle');
            // }

            BarGroup {
              id: center_right_group_content
              anchors.fill: parent

              ClockWidget {
                showDate: (Config.options.bar.verbose && bar_root.useShortenedForm < 2)
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
              }

              // UtilButtons {
              //   visible: (Config.options.bar.verbose && barRoot.useShortenedForm === 0)
              //   Layout.alignment: Qt.AlignVCenter
              // }
              //
              NetworkSignal {
                visible: true
                Layout.alignment: Qt.AlignVCenter
              }

              BatteryIndicator {
                visible: true
                Layout.alignment: Qt.AlignVCenter
              }
            }
          }
        }
        // TODO: right
        MouseArea { // Right side | scroll to change volume
          id: bar_right

          anchors.right: parent.right
          implicitHeight: Appearance.sizes.bar_base_height
          height: Appearance.sizes.bar_height
          width: (bar_root.width - middle_section.width) / 2

          property bool hovered: false
          // property real lastScrollX: 0
          // property real lastScrollY: 0
          // property bool trackingScroll: false
          //
          //   acceptedButtons: Qt.LeftButton
          //   hoverEnabled: true
          //   propagateComposedEvents: true
          //   onEntered: event => {
          //     barRightSideMouseArea.hovered = true;
          //   }
          //   onExited: event => {
          //     barRightSideMouseArea.hovered = false;
          //     barRightSideMouseArea.trackingScroll = false;
          //   }
          //   onPressed: event => {
          //     if (event.button === Qt.LeftButton) {
          //       Hyprland.dispatch('global quickshell:sidebarRightOpen');
          //     } else if (event.button === Qt.RightButton) {
          //       MprisController.activePlayer.next();
          //     }
          //   }
          //   // Scroll to change volume
          //   WheelHandler {
          //     onWheel: event => {
          //       const currentVolume = Audio.value;
          //       const step = currentVolume < 0.1 ? 0.01 : 0.02 || 0.2;
          //       if (event.angleDelta.y < 0)
          //       Audio.sink.audio.volume -= step;
          //       else if (event.angleDelta.y > 0)
          //       Audio.sink.audio.volume = Math.min(1, Audio.sink.audio.volume + step);
          //       // Store the mouse position and start tracking
          //       barRightSideMouseArea.lastScrollX = event.x;
          //       barRightSideMouseArea.lastScrollY = event.y;
          //       barRightSideMouseArea.trackingScroll = true;
          //     }
          //     acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
          //   }
          //   onPositionChanged: mouse => {
          //     if (barRightSideMouseArea.trackingScroll) {
          //       const dx = mouse.x - barRightSideMouseArea.lastScrollX;
          //       const dy = mouse.y - barRightSideMouseArea.lastScrollY;
          //       if (Math.sqrt(dx * dx + dy * dy) > osdHideMouseMoveThreshold) {
          //         Hyprland.dispatch('global quickshell:osdVolumeHide');
          //         barRightSideMouseArea.trackingScroll = false;
          //       }
          //     }
          //   }
          //
          Item {
            anchors.fill: parent
            implicitHeight: right_section.implicitHeight
            implicitWidth: right_section.implicitWidth

            // ScrollHint {
            //   reveal: barRightSideMouseArea.hovered
            //   icon: "volume_up"
            //   tooltipText: qsTr("Scroll to change volume")
            //   side: "right"
            //   anchors.right: parent.right
            //   anchors.verticalCenter: parent.verticalCenter
            // }

            RowLayout {
              id: right_section
              anchors.fill: parent
              spacing: 5
              layoutDirection: Qt.RightToLeft

              // RippleButton { // Right sidebar button
              //   id: right_button
              //
              //   Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
              //   Layout.rightMargin: Appearance.rounding.corner
              //   Layout.fillWidth: false
              //
              //   implicitWidth: indicatorsRowLayout.implicitWidth + 10 * 2
              //   implicitHeight: indicatorsRowLayout.implicitHeight + 5 * 2
              //
              //   buttonRadius: Appearance.rounding.full
              //   colBackground: barRightSideMouseArea.hovered ? Appearance.colors.colLayer1Hover : ColorUtils.transparentize(Appearance.colors.colLayer1Hover, 1)
              //   colBackgroundHover: Appearance.colors.colLayer1Hover
              //   colRipple: Appearance.colors.colLayer1Active
              //   colBackgroundToggled: Appearance.colors.colSecondaryContainer
              //   colBackgroundToggledHover: Appearance.colors.colSecondaryContainerHover
              //   colRippleToggled: Appearance.colors.colSecondaryContainerActive
              //   toggled: GlobalStates.sidebarRightOpen
              //   property color colText: toggled ? Appearance.m3colors.m3onSecondaryContainer : Appearance.colors.colOnLayer0
              //
              //   Behavior on colText {
              //     animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
              //   }
              //
              //   onPressed: {
              //     Hyprland.dispatch('global quickshell:sidebarRightToggle');
              //   }
              //
              //   RowLayout {
              //     id: indicatorsRowLayout
              //     anchors.centerIn: parent
              //     property real realSpacing: 15
              //     spacing: 0
              //
              //     Revealer {
              //       reveal: Audio.sink?.audio?.muted ?? false
              //       Layout.fillHeight: true
              //       Layout.rightMargin: reveal ? indicatorsRowLayout.realSpacing : 0
              //       Behavior on Layout.rightMargin {
              //         NumberAnimation {
              //           duration: Appearance.animation.elementMoveFast.duration
              //           easing.type: Appearance.animation.elementMoveFast.type
              //           easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
              //         }
              //       }
              //       MaterialSymbol {
              //         text: "volume_off"
              //         iconSize: Appearance.font.pixelSize.larger
              //         color: rightSidebarButton.colText
              //       }
              //     }
              //     Revealer {
              //       reveal: Audio.source?.audio?.muted ?? false
              //       Layout.fillHeight: true
              //       Layout.rightMargin: reveal ? indicatorsRowLayout.realSpacing : 0
              //       Behavior on Layout.rightMargin {
              //         NumberAnimation {
              //           duration: Appearance.animation.elementMoveFast.duration
              //           easing.type: Appearance.animation.elementMoveFast.type
              //           easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
              //         }
              //       }
              //       MaterialSymbol {
              //         text: "mic_off"
              //         iconSize: Appearance.font.pixelSize.larger
              //         color: rightSidebarButton.colText
              //       }
              //     }
              //     MaterialSymbol {
              //       Layout.rightMargin: indicatorsRowLayout.realSpacing
              //       text: Network.materialSymbol
              //       iconSize: Appearance.font.pixelSize.larger
              //       color: rightSidebarButton.colText
              //     }
              //     MaterialSymbol {
              //       text: Bluetooth.bluetoothConnected ? "bluetooth_connected" : Bluetooth.bluetoothEnabled ? "bluetooth" : "bluetooth_disabled"
              //       iconSize: Appearance.font.pixelSize.larger
              //       color: rightSidebarButton.colText
              //     }
              //   }
              // }


              SysTray {
                bar: bar_root
                visible: true
                Layout.fillWidth: false
                Layout.fillHeight: true
              }

              MaterialSymbol {
                text: Bluetooth.bluetoothConnected ? "bluetooth_connected" : Bluetooth.bluetoothEnabled ? "bluetooth" : "bluetooth_disabled"
                iconSize: Appearance.font.pixelSize.larger
                color: Appearance.colors.foreground
              }

              // TODO: when scrolling should display a small window with value of the volume
              Volume {
                visible: true
                Layout.alignment: Qt.AlignVCenter
              }

              Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
              }


              // Weather
              // Loader {
              //   Layout.leftMargin: 8
              //   Layout.fillHeight: true
              //   active: Config.options.bar.weather.enable
              //   sourceComponent: BarGroup {
              //     implicitHeight: Appearance.sizes.bar_base_height
              //     WeatherBar {}
              //   }
              // }
            }
          }
        }
      }

      Loader {
        id: round_decorators
        anchors {
          left: parent.left
          right: parent.right
        }
        y: Appearance.sizes.bar_height
        width: parent.width
        height: Appearance.rounding.corner
        active: true

        sourceComponent: Item {
          implicitHeight: Appearance.rounding.corner
          RoundCorner {
            id: left_corner
            anchors {
              top: parent.top
              bottom: parent.bottom
              left: parent.left
            }
            color: Appearance.colors.background
            corner: RoundCorner.CornerEnum.TopLeft
          }
          RoundCorner {
            id: right_corner
            anchors {
              right: parent.right
              top: parent.top
              bottom: undefined
            }
            color: Appearance.colors.background
            corner: RoundCorner.CornerEnum.TopRight
          }
        }
      }
    }
  }
}
