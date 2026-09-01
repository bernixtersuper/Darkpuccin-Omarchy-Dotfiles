import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  function workspaceByName(name) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].name === name) return values[i]
    }

    return null
  }

  // All ten workspaces, always. Stock showed 1-5 plus whatever was occupied,
  // which meant switching to an empty 6-9 had to CREATE a button: the
  // GridLayout's `columns` changed, every sibling reflowed, and the new button
  // faded in through WidgetButton's 140ms `Behavior on opacity`. That read as
  // lag, and only on 6-9 -- exactly the workspaces not already on the bar.
  //
  // A fixed list keeps `columns` constant, so a switch only moves the
  // highlight: no button construction, no reflow, no fade. Unused workspaces
  // are still dimmed via the label's alpha, the way waybar's
  // persistent-workspaces behaved.
  //
  // Slots are keyed by Hyprland's workspace *name*, not its id: the named
  // workspace herdr lives on (see ~/.config/hypr/workspaces.lua) is handed an
  // arbitrary negative id by the compositor -- -1337 here -- so an id-keyed
  // lookup can never match it. Names are stable ("1".."10", "🐑") and are also
  // what `hl.dsp.focus` takes, once the named one is prefixed with `name:`.
  function workspaceSlots() {
    var slots = []
    for (var i = 1; i <= 10; i++) {
      slots.push({ name: String(i), label: String(i), target: String(i) })
    }
    slots.push({ name: "🐑", label: "🐑", target: "name:🐑" })
    return slots
  }

  function focusWorkspace(target) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + target + "\" })"))
  }

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

        readonly property var workspace: root.workspaceByName(modelData.name)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.name === modelData.name

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
        onPressed: function() { root.focusWorkspace(modelData.target) }

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
          renderType: parent.modelData.name === "🐑" ? Text.QtRendering : Text.NativeRendering
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
