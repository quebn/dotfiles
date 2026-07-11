pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root;
    property MprisPlayer trackedPlayer: null;
    property list<MprisPlayer> players: Mpris.players.values.filter(player => isRealPlayer(player));
    readonly property MprisPlayer activePlayer: trackedPlayer ?? Mpris.players.values[0] ?? null;
    signal trackChanged(reverse: bool);

    property bool __reverse: false;

    property var activeTrack;

    function isActivePlayer(player) {
        const isInvalid = (player.identity.startsWith("Mozilla") && !player.lengthSupported && player.length == 0);
        const isOnlyOne = !player.isPlaying && players.length > 0;
        if (player === undefined || isInvalid || isOnlyOne) {
            return null;
        }
        return player;
    }

    function isRealPlayer(player) {
        const isReal = (
            !(player.length == 0 && player.identity.startsWith("Mozilla"))
            && !(player.trackTitle == "Unknown" && player.identity == "Chromium")
            // Remove native browser buses only if plasma-browser-integration is actually active on D-Bus
            // && !(hasActivePlasmaIntegration && player.dbusName.startsWith("org.mpris.MediaPlayer2.firefox")) && !(hasActivePlasmaIntegration && player.dbusName.startsWith("org.mpris.MediaPlayer2.chromium"))
            // playerctld just copies other buses and we don't need duplicates
            && !player.dbusName?.startsWith("org.mpris.MediaPlayer2.playerctld")
            && !(player.dbusName?.endsWith(".mpd") && !player.dbusName.endsWith("MediaPlayer2.mpd")) // Non-instance mpd bus
        );
        return isReal;
    }

    Instantiator {
        model: Mpris.players;

        Connections {
            required property MprisPlayer modelData;
            target: modelData;

            Component.onCompleted: {
                if (root.trackedPlayer == null || modelData.isPlaying) {
                    root.trackedPlayer = modelData;
                }
            }

            Component.onDestruction: {
                if (root.trackedPlayer == null || !root.trackedPlayer.isPlaying) {
                    for (const player of Mpris.players.values) {
                        if (player.playbackState.isPlaying) {
                            root.trackedPlayer = player;
                            break;
                        }
                    }

                    if (trackedPlayer == null && Mpris.players.values.length != 0) {
                        trackedPlayer = Mpris.players.values[0];
                    }
                }
            }

            function onPlaybackStateChanged() {
                if (root.trackedPlayer !== modelData) root.trackedPlayer = modelData;
            }
        }
    }

    Connections {
        target: activePlayer

        function onPostTrackChanged() {
            root.updateTrack();
        }

        function onTrackArtUrlChanged() {
            console.log("arturl:", activePlayer.trackArtUrl)
            //root.updateTrack();
            if (root.activePlayer.uniqueId == root.activeTrack.uniqueId && root.activePlayer.trackArtUrl != root.activeTrack.artUrl) {
                // cantata likes to send cover updates *BEFORE* updating the track info.
                // as such, art url changes shouldn't be able to break the reverse animation
                const r = root.__reverse;
                root.updateTrack();
                root.__reverse = r;

            }
        }
    }

    onActivePlayerChanged: root.updateTrack();

    function updateTrackedPlayer() {
        console.log(`Updating Tracked Player!! ${root.trackedPlayer.isPlaying}`);
        if (root.activePlayer?.isPlaying) {
            return;
        }

        for (const player of Mpris.players.values) {
            if (player.playbackState.isPlaying) {
                root.trackedPlayer = player;
                break;
            }
        }
    }

    function updateTrack() {
        //console.log(`update: ${this.activePlayer?.trackTitle ?? ""} : ${this.activePlayer?.trackArtists}`)
        root.activeTrack = {
            uniqueId: root.activePlayer?.uniqueId ?? 0,
            artUrl: root.activePlayer?.trackArtUrl ?? "",
            title: root.activePlayer?.trackTitle || "Unknown Title",
            artist: root.activePlayer?.trackArtist || "Unknown Artist",
            album: root.activePlayer?.trackAlbum || "Unknown Album",
        };

        root.trackChanged(__reverse);
        root.__reverse = false;
    }

    property bool isPlaying: root.activePlayer && root.activePlayer.isPlaying;
    property bool canTogglePlaying: root.activePlayer?.canTogglePlaying ?? false;
    function togglePlaying() {
        if (root.canTogglePlaying) {
            root.activePlayer.togglePlaying();
        }
    }

    property bool canGoPrevious: root.activePlayer?.canGoPrevious ?? false;
    function previous() {
        if (root.canGoPrevious) {
            root.__reverse = true;
            root.activePlayer.previous();
        }
    }

    property bool canGoNext: root.activePlayer?.canGoNext ?? false;
    function next() {
        if (root.canGoNext) {
            root.__reverse = false;
            root.activePlayer.next();
        }
    }

    property bool canChangeVolume: root.activePlayer && root.activePlayer.volumeSupported && root.activePlayer.canControl;

    property bool loopSupported: root.activePlayer && root.activePlayer.loopSupported && root.activePlayer.canControl;
    property var loopState: root.activePlayer?.loopState ?? MprisLoopState.None;
    function setLoopState(loopState: var) {
        if (root.loopSupported) {
            root.activePlayer.loopState = loopState;
        }
    }

    property bool shuffleSupported: root.activePlayer && root.activePlayer.shuffleSupported && root.activePlayer.canControl;
    property bool hasShuffle: root.activePlayer?.shuffle ?? false;
    function setShuffle(shuffle: bool) {
        if (root.shuffleSupported) {
            root.activePlayer.shuffle = shuffle;
        }
    }

    function setActivePlayer(player: MprisPlayer) {
        const targetPlayer = player ?? Mpris.players[0];
        console.log(`setactive: ${targetPlayer} from ${activePlayer}`)

        if (targetPlayer && root.activePlayer) {
            root.__reverse = Mpris.players.indexOf(targetPlayer) < Mpris.players.indexOf(root.activePlayer);
        } else {
            // always animate forward if going to null
            root.__reverse = false;
        }

        root.trackedPlayer = targetPlayer;
    }

    IpcHandler {
        target: "mpris"

        function pauseAll(): void {
            for (const player of Mpris.players.values) {
                if (player.canPause) player.pause();
            }
        }

        function playPause(): void { root.togglePlaying(); }
        function previous(): void { root.previous(); }
        function next(): void { root.next(); }
    }
}
