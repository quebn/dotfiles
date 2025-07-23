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

    LazyLoader {
        id: popupLoader
        // active: shownItem
        activeAsync: shownItem

        PopupWindow {
            id: popup

            anchor {
                window: root.bar
                rect.x: tooltipItem.targetX
                rect.y: root.bar.tooltipYOffset
                adjustment: PopupAdjustment.None
            }

            HyprlandWindow.opacity: root.scaleMul

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

            implicitWidth: tooltipItem.targetWidth
            // TODO: heigth is like outfoxxed because animation
            implicitHeight: tooltipItem.targetHeight

            visible: true
            color: "transparent"

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

                clip: width != targetWidth || height != targetHeight
                // implicitWidth: parent.implicitWidth
                // implicitHeight: parent.implicitHeight
                anchors.fill: parent
                opacity: root.scaleMul

                Rectangle {
                    color: Appearance.colors.background
                    radius: Appearance.rounding.corner
                    border.color: Appearance.colors.border
                    anchors.fill: parent
                }

                readonly property var targetWidth: shownItem?.implicitWidth ?? 1
                readonly property var targetHeight: shownItem?.implicitHeight ?? 1

                property var largestAnimWidth: 0
                property var largestAnimHeight: 0

                readonly property real targetX: {
                    if (shownItem == null) return 0;
                    const target = bar.contentItem.mapFromItem(shownItem.owner, shownItem.targetRelativeX, 0).x;
                    return bar.boundedX(target - (popup.implicitWidth * 0.5), popup.implicitWidth);
                }
            }
        }
    }
}
