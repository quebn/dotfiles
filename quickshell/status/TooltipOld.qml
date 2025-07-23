import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

Scope {
    id: root
    required property var bar;

    property TooltipItem activeTooltip: null;
    property TooltipItem activeMenu: null;

    readonly property TooltipItem activeItem: activeMenu ?? activeTooltip;
    property TooltipItem lastActiveItem: null;
    readonly property TooltipItem shownItem: activeItem ?? lastActiveItem;
    property real hangTime: lastActiveItem?.hangTime ?? 0;

    property Item tooltipItem: null;

    onActiveItemChanged: {
        if (activeItem != null) {
            hangTimer.stop();
            activeItem.targetVisible = true;

            if (tooltipItem) {
                activeItem.parent = tooltipItem;
            }
        }

        if (lastActiveItem != null && lastActiveItem != activeItem) {
            if (activeItem != null) lastActiveItem.targetVisible = false;
            else if (root.hangTime == 0) doLastHide();
            else hangTimer.start();
        }

        if (activeItem != null) lastActiveItem = activeItem;
    }

    function setItem(item: TooltipItem) {
        if (item.isMenu) {
            activeMenu = item;
        } else {
            activeTooltip = item;
        }
    }

    function removeItem(item: TooltipItem) {
        if (item.isMenu && activeMenu == item) {
            activeMenu = null
        } else if (!item.isMenu && activeTooltip == item) {
            activeTooltip = null
        }
    }

    function doLastHide() {
        lastActiveItem.targetVisible = false;
    }

    function onHidden(item: TooltipItem) {
        if (item == lastActiveItem) {
            lastActiveItem = null;
        }
    }

    Timer {
        id: hangTimer
        interval: root.hangTime
        onTriggered: doLastHide();
    }

    property real scaleMul: lastActiveItem && lastActiveItem.targetVisible ? 1 : 0;
    Behavior on scaleMul { SmoothedAnimation { velocity: 5 } }

    LazyLoader {
        id: popupLoader
        activeAsync: shownItem != null

        PopupWindow {
            id: popup

            anchor {
				window: bar
				rect.x: tooltipItem.leftmostAnimX
				rect.y: bar.tooltipYOffset
				adjustment: PopupAdjustment.None
            }

            // HyprlandWindow.opacity: root.scaleMul

            HyprlandWindow.visibleMask: Region {
                id: visibleMask
                item: tooltipItem
            }

            Connections {
                target: root

                function onScaleMulChanged() {
                    visibleMask.changed();
                }
            }

            implicitWidth: Math.max(700, tooltipItem.largestAnimWidth)
            implicitHeight: Math.max(700, tooltipItem.largestAnimHeight)
			// height: {
			// 	const h = tooltipItem.lowestAnimY - tooltipItem.highestAnimY
			// 	//console.log(`seth ${h} ${tooltipItem.highestAnimY} ${tooltipItem.lowestAnimY}; ${tooltipItem.y1} ${tooltipItem.y2}`)
			// 	return h
			// }
            visible: true
            // color: "transparent"
            color: Appearance.colors.background

            mask: Region {
                item: (shownItem?.hoverable ?? false) ? tooltipItem : null
            }

            HyprlandFocusGrab {
                active: activeItem?.isMenu ?? false
                windows: [ popup, bar, ...(activeItem?.grabWindows ?? []) ]
                onActiveChanged: {
                    if (!active && activeItem?.isMenu) {
                        activeMenu.close()
                    }
                }
            }

            /*Rectangle {
                 color: "#10ff0000"
                 //y: tooltipItem.highestAnimY
                 height: tooltipItem.lowestAnimY - tooltipItem.highestAnimY
                 width: parent.width
             }

             Rectangle {
                 color: "#1000ff00"
                 //y: tooltipItem.highestAnimY
                 height: popup.height
                 width: parent.width
             }*/

             Item {
                 id: tooltipItem
                 Component.onCompleted: {
                     root.tooltipItem = this;
                     if (root.shownItem) {
                         root.shownItem.parent = this;
                     }

                     //highestAnimY = targetY - targetHeight / 2;
                     //lowestAnimY = targetY + targetHeight / 2;
                 }

				transform: Scale {
					origin.x: tooltipItem.width / 2
					origin.y: 0
					xScale: xScale
					yScale: xScale
				}

                 clip: width != targetWidth || height != targetHeight

                 Rectangle {
                     color: Appearance.colors.background
                     radius: 5
                     border.color: Appearance.colors.border
                     border.width: 1
                 }

                 readonly property var targetWidth: shownItem?.implicitWidth ?? 0
                 readonly property var targetHeight: shownItem?.implicitHeight ?? 0

                 property var largestAnimWidth: 0
                 property var largestAnimHeight: 0
                 property var leftmostAnimX: 0
                 property var rightmostAnimX: bar.width

                 onTargetWidthChanged: {
                     if (targetWidth > largestAnimWidth) {
                         largestAnimWidth = targetWidth;
                     }
                 }

                 readonly property real targetX: {
                     if (shownItem == null) return 0;
                     const target = bar.contentItem.mapFromItem(shownItem.owner, shownItem.targetRelativeX, 0).x;
                     const targetX = bar.boundedX(target, shownItem.implicitWidth / 2);
                     console.log(`targetX: ${targetX}`);
                     return targetX
                 }

                 property var h: -1
                 height: Math.max(1, h)
                 property var x1: -1
                 property var x2: -1
                 x: x1 - popup.anchor.rect.x
                 width: x2 - x1

                 readonly property bool anyAnimsRunning: x1Anim.running || x2Anim.running || heightAnim.running

                 onAnyAnimsRunningChanged: {
                     if (!anyAnimsRunning) {
                         largestAnimWidth = targetWidth
                         //highestAnimY = y1;
                         //lowestAnimY = y2;
                     }
                 }

                 SmoothedAnimation on x1 {
                     id: x1Anim
                     to: tooltipItem.targetX - tooltipItem.targetWidth / 2;
                     onToChanged: {
                         if (tooltipItem.x1 == -1 || !(shownItem?.animateSize ?? true)) {
                             stop();
                             tooltipItem.x1 = to;
                         } else {
                             velocity = (Math.max(tooltipItem.x1, to) - Math.min(tooltipItem.x1, to)) * 5;
                             restart();
                         }
                     }
                 }

                 SmoothedAnimation on x2 {
                     id: x2Anim
                     to: tooltipItem.targetX + tooltipItem.targetWidth / 2;
                     onToChanged: {
                         if (tooltipItem.x2 == -1 || !(shownItem?.animateSize ?? true)) {
                             stop();
                             tooltipItem.x2 = to;
                         } else {
                             velocity = (Math.max(tooltipItem.x2, to) - Math.min(tooltipItem.x2, to)) * 5;
                             restart();
                         }
                     }
                 }

                 SmoothedAnimation on h {
                     id: heightAnim
                     to: tooltipItem.targetHeight;
                     onToChanged: {
                         if (tooltipItem.h == -1 || !(shownItem?.animateSize ?? true)) {
                             stop();
                             tooltipItem.h = to;
                         } else {
                             velocity = (Math.max(tooltipItem.height, to) - Math.min(tooltipItem.height, to)) * 5;
                             restart();
                         }
                     }
                 }
             }
         }
     }
}
