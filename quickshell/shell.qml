//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
import "./status/"
import "./decorations/"
import Quickshell

ShellRoot {
  id: root

  property bool bar: true
  property bool corners: true
  property bool mediaControls: true
  property bool notificationPopup: true
  property bool displayVolume: true
  property bool displayBrightness: true
  // property

  LazyLoader { active: root.bar; component: Bar {} }
  LazyLoader { active: root.corners; component: ScreenCorners {} }
  LazyLoader { active: root.mediaControls; component: MediaControls {} }
  LazyLoader { active: notificationPopup; component: NotificationPopup {} }
  LazyLoader { active: displayVolume; component: ScreenDisplayVolume {} }
  LazyLoader { active: displayBrightness; component: ScreenDisplayBrightness {} }
}
