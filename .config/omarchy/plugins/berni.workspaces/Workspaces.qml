import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  // Every monitor owns a block of ten global workspace ids (1-10, 11-20, ...;
  // see default/hypr/monitor-workspaces.lua). This bar shows ITS OWN monitor's
  // block, numbered 1-10/0 like a keyboard row, and highlights whichever slot
  // that monitor itself is showing -- not whatever is focused elsewhere.
  readonly property int slots: 10

  readonly property var monitor: {
    var window = root.QsWindow.window
    var screen = window ? window.screen : null
    return screen ? Hyprland.monitorFor(screen) : Hyprland.focusedMonitor
  }
  readonly property string monitorName: root.monitor ? root.monitor.name : ""

  // Connector -> block, from the file Hyprland keeps them in (keyed by
  // physical monitor identity, so a block survives unplug/replug).
  property var blocks: ({})

  function readBlocks(text) {
    var next = {}
    var lines = String(text || "").split("\n")
    for (var i = 0; i < lines.length; i++) {
      var fields = lines[i].split("\t")
      if (fields.length >= 3 && fields[1] !== "") next[fields[1]] = parseInt(fields[0], 10)
    }
    root.blocks = next
  }

  FileView {
    path: (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/omarchy/monitor-workspaces"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: root.readBlocks(text())
    onLoadFailed: root.readBlocks("")
  }

  function blockOf(id) {
    return Math.floor((id - 1) / root.slots)
  }

  function activeWorkspaceId() {
    return root.monitor && root.monitor.activeWorkspace ? root.monitor.activeWorkspace.id : -1
  }

  // Until Hyprland has written the file, fall back to the block the
  // currently-shown workspace already belongs to.
  readonly property int block: {
    var block = root.blocks[root.monitorName]
    if (block !== undefined) return block
    var active = root.activeWorkspaceId()
    return active > 0 ? root.blockOf(active) : 0
  }

  function workspaceById(id) {
    if (id === null) return null
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }
    return null
  }

  function workspaceByName(name) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].name === name) return values[i]
    }
    return null
  }

  // All ten slots of THIS monitor's own block, always -- see the sizing note
  // below. Labelled 1-9 then 0 like a keyboard row. The sheep keeps its own
  // entry: it lives outside the block scheme on a fixed negative id (see
  // ~/.config/hypr/workspaces.lua), so it's resolved by name instead.
  function workspaceSlots() {
    var base = root.block * root.slots
    var out = []
    for (var i = 1; i <= root.slots; i++) {
      out.push({ id: base + i, slot: i, label: String(i === root.slots ? 0 : i), sheep: false })
    }
    var sheep = root.workspaceByName("🐑")
    out.push({ id: sheep ? sheep.id : null, slot: 0, label: "🐑", sheep: true })
    return out
  }

  // A slot's own block goes through the per-monitor dispatcher with this
  // monitor named explicitly, so a click always targets the monitor the
  // button is drawn on -- never whichever monitor last had focus or the mouse
  // happens to be sitting over. The sheep has no slot, just its name.
  function focusWorkspace(entry) {
    if (!root.bar) return
    var expression = entry.sheep
      ? "hl.dsp.focus({ workspace = \"name:🐑\" })"
      : "o.workspaces.focus(" + entry.slot + ", \"" + root.monitorName + "\")"
    root.bar.run("hyprctl dispatch " + Util.shellQuote(expression))
  }

  // Keeping a fixed-length model (ten slots, always) rather than only the
  // occupied ones avoids a layout bug: a dynamic list changes `columns` on
  // every switch to a workspace not already shown, which reflows every
  // sibling and fades the new button in through WidgetButton's 140ms
  // `Behavior on opacity`. A fixed list keeps `columns` constant, so a switch
  // only moves the highlight. Unused workspaces are dimmed via the label's
  // alpha instead, the way waybar's persistent-workspaces behaved.
  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  // The focused workspace is marked in Hyprland's active border colour rather
  // than the bar's own "active" role. WidgetButton.activeColor resolves to
  // bar.urgent -> Color.bar.active -> the theme's urgent red (#f38ba8 under
  // catppuccin-dark), while the border Hyprland actually draws around the
  // focused window comes from the theme accent: each theme's hyprland.lua sets
  // col.active_border from it (rgba(fab3e5ee) here, against accent #fab3e5).
  //
  // Color.accent is that same value and re-resolves on a theme switch, so this
  // stays in step without polling hyprctl. The border's ee alpha is dropped --
  // 93% on a two-pixel rule and a digit is a difference you cannot see, and
  // full opacity keeps the digit as legible as its neighbours.
  readonly property color activeColor: Color.accent

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      var name = event ? String(event.name) : ""
      // Quickshell credits every workspace switch to the focused monitor, as
      // the event doesn't say which one switched, and misses the workspace a
      // monitor falls back to when its own is moved away. Moving workspaces
      // between monitors switches the others too. Every bar shares what
      // Hyprland answers, so one asks after any of these.
      if (name === "workspacev2" || name === "moveworkspacev2" || name === "changeworkspaceid" || name === "configreloaded") {
        Hyprland.refreshMonitors()
        Hyprland.refreshWorkspaces()
      }
    }
  }

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceSlots().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceSlots()

      WidgetButton {
        required property var modelData

        readonly property var workspace: root.workspaceById(modelData.id)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: root.monitor !== null && root.monitor.activeWorkspace !== null
                                         && modelData.id !== null && root.monitor.activeWorkspace.id === modelData.id

        bar: root.bar

        // NOTE ON ANIMATIONS -- this widget is deliberately instant.
        //
        // WidgetButton animates two things: `Behavior on opacity` (140ms,
        // WidgetButton.qml:71) and the label's `Behavior on color` (160ms,
        // :88). Both fire on every workspace switch, so the bar visibly trails
        // the compositor. Neither Behavior can be switched off from outside the
        // component, so instead this avoids *triggering* them:
        //
        //   * `opacity` is never bound, so it stays 1 and the fade never runs.
        //     Dimming for unoccupied workspaces moves onto the label color's
        //     alpha channel instead.
        //   * the built-in label is hidden (`labelVisible: false`) and replaced
        //     with the plain Text below, which has no Behavior of its own.
        //
        // `text` is still set: WidgetButton derives hasVisualContent and its
        // width from it, so clearing it would collapse the button.
        text: modelData.label
        labelVisible: false

        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }

        // Unanimated stand-in for WidgetButton's label. Focused digit takes the
        // theme accent so it matches the underline (waybar drew that border in
        // currentColor); unoccupied workspaces dim via alpha rather than the
        // parent's opacity.
        Text {
          anchors.centerIn: parent
          text: parent.modelData.label
          color: parent.focused
                   ? root.activeColor
                   : (parent.occupied ? parent.foreground : Util.alpha(parent.foreground, 0.5))
          font.family: parent.fontFamily
          font.pixelSize: parent.fontSize
          // NativeRendering keeps the digits crisp, but it rasterises through a
          // path that drops the colour layers of an emoji font, so the sheep
          // would come out as a grey glyph. Only that slot pays the switch.
          renderType: parent.modelData.sheep ? Text.QtRendering : Text.NativeRendering
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        // Underline under the active workspace, matching waybar's
        // `#workspaces button.active { border-bottom: 2px solid currentColor }`.
        //
        // Spans the full button, not just the digits: in waybar the border ran
        // across the padding box (`padding: 0 7px`), so it always read wider
        // than the number itself.
        //
        // No bottom margin -- the button is fixedHeight: barSize and the bar
        // sits flush at the bottom of the screen, so anchoring straight to
        // parent.bottom puts the rule on the screen edge the way the CSS
        // border did. Any margin here makes it float.
        Rectangle {
          visible: parent.focused
          width: parent.width
          height: Style.space(2)
          color: root.activeColor
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom
        }
      }
    }
  }
}
