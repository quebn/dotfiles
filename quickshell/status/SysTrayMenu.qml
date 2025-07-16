pragma ComponentBehavior: Bound

import "root:/"
import "root:/components"
import "root:/services"
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls

StackView {
    id: root

    // required property Item popouts
    required property QsMenuHandle trayItem

    implicitWidth: currentItem.implicitWidth
    implicitHeight: currentItem.implicitHeight

    initialItem: SubMenu {
        handle: root.trayItem
    }

    pushEnter: Anim {}
    pushExit: Anim {}
    popEnter: Anim {}
    popExit: Anim {}

    component Anim: Transition {
        NumberAnimation {
            duration: 0
        }
    }

    component SubMenu: Column {
        id: menu

        required property QsMenuHandle handle
        property bool isSubMenu
        property bool shown

        padding: 7
        spacing: 5

        opacity: shown ? 1 : 0
        scale: 0

        Component.onCompleted: shown = true
        StackView.onActivating: shown = true
        StackView.onDeactivating: shown = false
        StackView.onRemoved: destroy()

        Behavior on opacity {
            NumberAnimation {
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
            }
        }

        QsMenuOpener {
            id: menuOpener

            menu: menu.handle
        }

        Repeater {
            model: menuOpener.children

            StyledRect {
                id: item

                required property QsMenuEntry modelData

                implicitWidth: 300
                implicitHeight: modelData.isSeparator ? 1 : children.implicitHeight

                radius: Appearance.rounding.full
                color: "transparent"

                Loader {
                    id: children

                    anchors.left: parent.left
                    anchors.right: parent.right

                    active: !item.modelData.isSeparator
                    asynchronous: true

                    sourceComponent: Item {
                        implicitHeight: label.implicitHeight

                        StateLayer {
                            anchors.margins: -5 / 2
                            anchors.leftMargin: -7
                            anchors.rightMargin: -7

                            radius: item.radius
                            disabled: !item.modelData.enabled

                            function onClicked(): void {
                                const entry = item.modelData;
                                if (entry.hasChildren)
                                    root.push(subMenuComp.createObject(null, {
                                        handle: entry,
                                        isSubMenu: true
                                    }));
                                else {
                                    item.modelData.triggered();
                                    // root.popouts.hasCurrent = false;
                                }
                            }
                        }

                        Loader {
                            id: icon

                            anchors.left: parent.left

                            active: item.modelData.icon !== ""
                            asynchronous: true

                            sourceComponent: IconImage {
                                implicitSize: label.implicitHeight

                                source: item.modelData.icon
                            }
                        }

                        StyledText {
                            id: label

                            anchors.left: icon.right
                            anchors.leftMargin: icon.active ? 7 : 0

                            text: labelMetrics.elidedText
                            color: Appearance.colors.foreground
                        }

                        TextMetrics {
                            id: labelMetrics

                            text: item.modelData.text
                            font.pointSize: label.font.pointSize
                            font.family: label.font.family

                            elide: Text.ElideRight
                            elideWidth: 300 - (icon.active ? icon.implicitWidth + label.anchors.leftMargin : 0) - (expand.active ? expand.implicitWidth + 12 : 0)
                        }

                        Loader {
                            id: expand

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            active: item.modelData.hasChildren
                            asynchronous: true

                            sourceComponent: MaterialSymbol {
                                text: "chevron_right"
                                color: item.modelData.enabled ? Colours.palette.m3onSurface : Colours.palette.m3outline
                            }
                        }
                    }
                }
            }
        }

        Loader {
            active: menu.isSubMenu
            asynchronous: true

            sourceComponent: Item {
                implicitWidth: back.implicitWidth
                implicitHeight: back.implicitHeight + 7 / 2

                Item {
                    anchors.bottom: parent.bottom
                    implicitWidth: back.implicitWidth
                    implicitHeight: back.implicitHeight

                    StyledRect {
                        anchors.fill: parent
                        anchors.margins: -5 / 2
                        anchors.leftMargin: -7
                        anchors.rightMargin: -7 * 2

                        radius: Appearance.rounding.full
                        color: Colours.palette.m3secondaryContainer

                        StateLayer {
                            radius: parent.radius
                            color: Colours.palette.m3onSecondaryContainer

                            function onClicked(): void {
                                root.pop();
                            }
                        }
                    }

                    Row {
                        id: back

                        anchors.verticalCenter: parent.verticalCenter

                        MaterialSymbol {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "chevron_left"
                            color: Colours.color.foreground
                        }

                        StyledText {
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Back")
                            color: Colours.color.foreground
                        }
                    }
                }
            }
        }
    }

    Component {
        id: subMenuComp

        SubMenu {}
    }
}
