import "root:/"
import "root:/components"
import "root:/services"
import "root:/functions/string_utils.js" as StringUtils
import "root:/functions/color_utils.js" as ColorUtils
import "root:/functions/file_utils.js" as FileUtils
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item { // Player instance
    id: playerController
    required property MprisPlayer player
    property var artUrl: player?.trackArtUrl
    property string artDownloadLocation: Directories.coverArt
    property string artFileName: Qt.md5(artUrl) + ".jpg"
    property string artFilePath: `${artDownloadLocation}/${artFileName}`
    property color artDominantColor: Appearance.colors.primary
    property bool downloaded: false
    property list<real> visualizerPoints: []
    property real maxVisualizerValue: 1000 // Max value in the data points
    property int visualizerSmoothing: 2 // Number of points to average for smoothing

    implicitWidth: widgetWidth
    implicitHeight: widgetHeight

    component TrackChangeButton: RippleButton {
        implicitWidth: 24
        implicitHeight: 24

        property var iconName
        bg: blendedColors.colSecondaryContainer, 1
        bg_hover: blendedColors.colSecondaryContainerHover
        col_ripple: blendedColors.colSecondaryContainerActive

        contentItem: MaterialSymbol {
            iconSize: Appearance.font.pixelSize.huge
            fill: 1
            horizontalAlignment: Text.AlignHCenter
            color: blendedColors.colOnSecondaryContainer
            text: iconName

            Behavior on color {
                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
            }
        }
    }

    Timer { // Force update for prevision
        running: playerController.player?.playbackState == MprisPlaybackState.Playing
        interval: 1000
        repeat: true
        onTriggered: {
            playerController.player.positionChanged()
        }
    }

    onArtUrlChanged: {
        if (playerController.artUrl.length == 0) {
            playerController.artDominantColor = Appearance.colors.layer1
            return;
        }
        // console.log("PlayerControl: Art URL changed to", playerController.artUrl)
        // console.log("Download cmd:", coverArtDownloader.command.join(" "))
        playerController.downloaded = false
        coverArtDownloader.running = true
    }

    Process { // Cover art downloader
        id: coverArtDownloader
        property string targetFile: playerController.artUrl
        command: [ "bash", "-c", `[ -f ${artFilePath} ] || curl -sSL '${targetFile}' -o '${artFilePath}'` ]
        onExited: (exitCode, exitStatus) => {
            playerController.downloaded = true
        }
    }

    ColorQuantizer {
        id: colorQuantizer
        source: playerController.downloaded ? Qt.resolvedUrl(artFilePath) : ""
        depth: 0 // 2^0 = 1 color
        rescaleSize: 1 // Rescale to 1x1 pixel for faster processing
    }

    property bool backgroundIsDark: artDominantColor.hslLightness < 0.5
    property QtObject blendedColors: QtObject {
        property color colLayer0: Appearance.colors.background
        property color colLayer1: Appearance.colors.layer1
        property color colOnLayer0: Appearance.colors.secondary
        property color colOnLayer1: Appearance.colors.foreground
        property color colSubtext: Appearance.colors.hint
        property color colPrimary: Appearance.colors.primary
        property color colPrimaryHover: Appearance.colors.tertiary
        property color colPrimaryActive: Appearance.colors.primary
        property color colSecondaryContainer: Appearance.colors.layer1
        property color colSecondaryContainerHover: Appearance.colors.primary
        property color colSecondaryContainerActive: Appearance.colors.primary
        property color colOnPrimary: Appearance.colors.black
        property color colOnSecondaryContainer: Appearance.colors.foreground

    }

    StyledRectangularShadow {
        target: background
    }
    Rectangle { // Background
        id: background
        anchors.fill: parent
        anchors.margins: Appearance.sizes.elevationMargin
        color: blendedColors.colLayer0
        radius: Appearance?.rounding.corner

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: background.width
                height: background.height
                radius: background.radius
            }
        }

        Image {
            id: blurredArt
            anchors.fill: parent
            source: playerController.downloaded ? Qt.resolvedUrl(artFilePath) : ""
            sourceSize.width: background.width
            sourceSize.height: background.height
            fillMode: Image.PreserveAspectCrop
            cache: false
            antialiasing: true
            asynchronous: true

            layer.enabled: true
            layer.effect: MultiEffect {
                source: blurredArt
                saturation: 0.2
                blurEnabled: true
                blurMax: 100
                blur: 1
            }

            Rectangle {
                anchors.fill: parent
                color: blendedColors.colLayer0
                radius: Appearance?.rounding.corner
            }
        }

        WaveVisualizer {
            id: visualizerCanvas
            anchors.fill: parent
            live: playerController.player?.isPlaying
            points: playerController.visualizerPoints
            maxVisualizerValue: playerController.maxVisualizerValue
            smoothing: playerController.visualizerSmoothing
            color: blendedColors.colPrimary
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: root.contentPadding
            spacing: 15

            Rectangle { // Art background
                id: artBackground
                Layout.fillHeight: true
                implicitWidth: height
                radius: root.artRounding
                color: blendedColors.colLayer1

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: artBackground.width
                        height: artBackground.height
                        radius: artBackground.radius
                    }
                }

                Image { // Art image
                    id: mediaArt
                    property int size: parent.height
                    anchors.fill: parent

                    source: playerController.downloaded ? Qt.resolvedUrl(artFilePath) : ""
                    fillMode: Image.PreserveAspectCrop
                    cache: false
                    antialiasing: true
                    asynchronous: true

                    width: size
                    height: size
                    sourceSize.width: size
                    sourceSize.height: size
                }
            }

            ColumnLayout { // Info & controls
                Layout.fillHeight: true
                spacing: 2

                StyledText {
                    id: trackTitle
                    Layout.fillWidth: true
                    font.pixelSize: Appearance.font.pixelSize.large
                    color: blendedColors.colOnLayer0
                    elide: Text.ElideRight
                    text: StringUtils.cleanMusicTitle(playerController.player?.trackTitle) || "Untitled"
                }
                StyledText {
                    id: trackArtist
                    Layout.fillWidth: true
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: blendedColors.colSubtext
                    elide: Text.ElideRight
                    text: playerController.player?.trackArtist
                }
                Item { Layout.fillHeight: true }
                Item {
                    Layout.fillWidth: true
                    implicitHeight: trackTime.implicitHeight + sliderRow.implicitHeight

                    StyledText {
                        id: trackTime
                        anchors.bottom: sliderRow.top
                        anchors.bottomMargin: 5
                        anchors.left: parent.left
                        font.pixelSize: Appearance.font.pixelSize.small
                        color: blendedColors.colSubtext
                        elide: Text.ElideRight
                        text: `${StringUtils.friendlyTimeForSeconds(playerController.player?.position)} / ${StringUtils.friendlyTimeForSeconds(playerController.player?.length)}`
                    }
                    RowLayout {
                        id: sliderRow
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            right: parent.right
                        }
                        TrackChangeButton {
                            iconName: "skip_previous"
                            onClicked: playerController.player?.previous()
                        }
                        Item {
                            id: progressBarContainer
                            Layout.fillWidth: true
                            implicitHeight: progressBar.implicitHeight

                            StyledProgressBar {
                                id: progressBar
                                anchors.fill: parent
                                highlightColor: blendedColors.colPrimary
                                trackColor: blendedColors.colSecondaryContainer
                                value: playerController.player?.position / playerController.player?.length
                                sperm: playerController.player?.isPlaying
                            }
                        }
                        TrackChangeButton {
                            iconName: "skip_next"
                            onClicked: playerController.player?.next()
                        }
                    }

                    RippleButton {
                        id: playPauseButton
                        anchors.right: parent.right
                        anchors.bottom: sliderRow.top
                        anchors.bottomMargin: 5
                        property real size: 44
                        implicitWidth: size
                        implicitHeight: size
                        onClicked: playerController.player.togglePlaying();

                        radius: playerController.player?.isPlaying ? Appearance?.rounding.corner : size / 2
                        bg: playerController.player?.isPlaying ? blendedColors.colPrimary : blendedColors.colSecondaryContainer
                        bg_hover: playerController.player?.isPlaying ? blendedColors.colPrimaryHover : blendedColors.colSecondaryContainerHover
                        col_ripple: playerController.player?.isPlaying ? blendedColors.colPrimaryActive : blendedColors.colSecondaryContainerActive

                        contentItem: MaterialSymbol {
                            iconSize: Appearance.font.pixelSize.huge
                            fill: 1
                            horizontalAlignment: Text.AlignHCenter
                            color: playerController.player?.isPlaying ? blendedColors.colOnPrimary : blendedColors.colOnSecondaryContainer
                            text: playerController.player?.isPlaying ? "pause" : "play_arrow"

                            Behavior on color {
                                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                            }
                        }
                    }
                }
            }
        }
    }
}
