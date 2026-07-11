import qs
import qs.components
import qs.services
import qs.functions
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Hyprland

Item {
    id: root

    readonly property MprisPlayer trackedPlayer: MprisController.trackedPlayer
    readonly property string cleanedTitle: StringUtils.cleanMusicTitle(trackedPlayer?.trackTitle) || qsTr("No media")
    property color mainColor: trackedPlayer ? Appearance.colors.red : Appearance.colors.hint

    Layout.fillHeight: true
    // Layout.fillWidth: true
    implicitWidth: parent.width * .5
    implicitHeight: Appearance.sizes.bar.height

    Timer {
        running: trackedPlayer?.playbackState == MprisPlaybackState.Playing
        interval: 5000
        repeat: true
        onTriggered: trackedPlayer.positionChanged()
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton | Qt.RightButton | Qt.LeftButton
        onPressed: (event) => {
            if (event.button === Qt.MiddleButton) {
                trackedPlayer?.next();
            } else if (event.button === Qt.BackButton) {
                trackedPlayer?.previous();
            } else if (event.button === Qt.ForwardButton || event.button === Qt.RightButton) {
                Hyprland.dispatch(`hl.dsp.global("quickshell:mediaControlsToggle")`)
            } else if (event.button === Qt.LeftButton) {
                trackedPlayer?.togglePlaying();
                MprisController.updateTrackedPlayer();
            }
        }
    }

    RowLayout { // Real content
        id: rowLayout

        spacing: 2
        anchors.fill: parent

        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            lineWidth: 2
            value: trackedPlayer?.position / trackedPlayer?.length
            size: 26
            secondaryColor: Appearance.colors.gutter
            primaryColor: mainColor

            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: trackedPlayer ? (trackedPlayer.isPlaying ? "music_note" : "pause") : "music_note"
                iconSize: Appearance.font.pixelSize.normal
                color: mainColor
            }

        }

        StyledText {
            width: rowLayout.width - (CircularProgress.size + rowLayout.spacing * 2)
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true // Ensures the text takes up available space
            Layout.rightMargin: rowLayout.spacing
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Appearance.font.pixelSize.small
            elide: Text.ElideRight // Truncates the text on the right
            color: mainColor
            text: `${cleanedTitle}${trackedPlayer?.trackArtist ? ' • ' + trackedPlayer.trackArtist : ''}`
        }

    }

}
