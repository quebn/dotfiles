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

  LazyLoader { active: root.bar; component: Bar {} }
  LazyLoader { active: root.corners; component: ScreenCorners {} }
  LazyLoader { active: root.mediaControls; component: MediaControls {} }
}
