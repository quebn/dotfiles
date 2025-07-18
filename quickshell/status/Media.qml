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

    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property string cleanedTitle: StringUtils.cleanMusicTitle(activePlayer?.trackTitle) || qsTr("No media")
    property color mainColor: activePlayer ? Appearance.colors.foreground : Appearance.colors.hint

    Layout.fillHeight: true
    // Layout.fillWidth: true
    implicitWidth: parent.width * .5
    implicitHeight: Appearance.sizes.bar.height

    Timer {
        running: activePlayer?.playbackState == MprisPlaybackState.Playing
        interval: 5000
        repeat: true
        onTriggered: activePlayer.positionChanged()
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton | Qt.RightButton | Qt.LeftButton
        onPressed: (event) => {
            if (event.button === Qt.MiddleButton) {
                activePlayer?.next();
            } else if (event.button === Qt.BackButton) {
                activePlayer?.previous();
            } else if (event.button === Qt.ForwardButton || event.button === Qt.RightButton) {
                Hyprland.dispatch("global quickshell:mediaControlsToggle")
            } else if (event.button === Qt.LeftButton) {
                activePlayer?.togglePlaying();
            }
        }
    }

    RowLayout { // Real content
        id: rowLayout

        spacing: 4
        anchors.fill: parent

        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            lineWidth: 2
            value: activePlayer?.position / activePlayer?.length
            size: 26
            secondaryColor: Appearance.colors.gutter
            primaryColor: mainColor

            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: activePlayer ? activePlayer.isPlaying ? "music_note" : "pause" : "music_note"
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
            elide: Text.ElideRight // Truncates the text on the right
            color: mainColor
            text: `${cleanedTitle}${activePlayer?.trackArtist ? ' • ' + activePlayer.trackArtist : ''}`
        }

    }

}
