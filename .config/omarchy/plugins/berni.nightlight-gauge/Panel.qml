import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons
import qs.Commons as Commons

// Night Light bar icon + slider panel, sitting next to omarchy.indicators
// (NightLight was pulled out of that cluster via shell.json's "items"
// override so this is the only night-light control left in the bar).
// Left-click toggles on/off (same script as SUPER+CTRL+N); right-click opens
// the slider panel for fine-grained warmth.
//
// User-owned plugins (this directory) only get a deliberately narrow service
// proxy from bar.shell.firstPartyServiceFor("omarchy.nightlight") -- just
// `enabled` and a binary setter, no `temperature` and no arbitrary-value
// setter (see shell.qml's pluginFirstPartyServiceFor: only first-party
// *packaged* plugins under /usr/share/omarchy get the unrestricted service
// object). So this queries/applies the temperature directly via `hyprctl
// hyprsunset temperature`, same as the shell scripts in
// ~/.config/hypr/scripts/*.sh, which own persistence. Night Light and the
// B&W filter are independent -- both can be on at once.
Panel {
  id: root
  moduleName: "berni.nightlight-gauge"
  ipcTarget: "berni.nightlight-gauge"

  readonly property int minTemp: 1000
  readonly property int maxTemp: 6500
  readonly property int identityTemp: 6000
  property int currentTemp: maxTemp
  readonly property bool nightlightOn: currentTemp < identityTemp
  property bool cursorActive: false

  readonly property string shaderPath: Quickshell.env("HOME") + "/.config/hypr/shaders/bw-filter.frag"
  property bool bwOn: false

  // Without this the bar host sees a zero-size widget (Panel's base Item
  // declares no implicit size of its own) and gives it no space at all.
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function clampTemp(t) {
    return Math.max(root.minTemp, Math.min(root.maxTemp, Math.round(t)))
  }

  function queryTemp() {
    if (!queryProcess.running) queryProcess.running = true
  }

  function queryBw() {
    if (!bwQueryProcess.running) bwQueryProcess.running = true
  }

  function applyLive(temp) {
    var t = root.clampTemp(temp)
    root.currentTemp = t
    applyProcess.command = ["hyprctl", "hyprsunset", "temperature", String(t)]
    applyProcess.running = true
  }

  function commitWarmth(temp) {
    var script = Quickshell.env("HOME") + "/.config/hypr/scripts/set-nightlight-warmth.sh"
    root.bar.run(script + " " + root.clampTemp(temp))
    refreshTimer.restart()
  }

  function runToggle() {
    var script = Quickshell.env("HOME") + "/.config/hypr/scripts/toggle-nightlight-warmth.sh"
    root.bar.run(script)
    refreshTimer.restart()
  }

  function toggleBw() {
    var script = Quickshell.env("HOME") + "/.config/hypr/scripts/toggle-bw-filter.sh"
    root.bar.run(script)
    root.bwOn = !root.bwOn
    refreshTimer.restart()
  }

  Process {
    id: queryProcess
    command: ["hyprctl", "hyprsunset", "temperature"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var match = String(text || "").match(/[0-9]+/)
        if (match) root.currentTemp = root.clampTemp(Number(match[0]))
      }
    }
  }

  Process { id: applyProcess }

  Process {
    id: bwQueryProcess
    command: ["hyprctl", "-j", "getoption", "decoration:screen_shader"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        try {
          var data = JSON.parse(text)
          root.bwOn = data.str === root.shaderPath
        } catch (e) {
          root.bwOn = false
        }
      }
    }
  }

  // The bar scripts run async (fire-and-forget via bar.run), so give the
  // toggle/commit a moment to land before re-querying actual state.
  Timer {
    id: refreshTimer
    interval: 300
    onTriggered: { root.queryTemp(); root.queryBw() }
  }

  // Catches external changes (SUPER+CTRL+N, the B&W filter) while the panel
  // is open; cheap and only runs while visible.
  Timer {
    interval: 1000
    running: root.opened
    repeat: true
    onTriggered: { root.queryTemp(); root.queryBw() }
  }

  Component.onCompleted: { root.queryTemp(); root.queryBw() }
  onOpenedChanged: if (root.opened) { root.queryTemp(); root.queryBw() }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰔎"
    opacity: root.nightlightOn ? 1 : 0.5
    tooltipText: (root.nightlightOn ? ("Night Light " + root.currentTemp + "K") : "Night Light off")
      + " · left-click toggles, right-click opens warmth slider"
    onPressed: function(b) {
      if (b === Qt.RightButton) root.toggle()
      else root.runToggle()
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: panel.loadedContent
    contentWidth: panel.fittedContentWidth(Style.space(260))
    contentHeight: panel.fittedContentHeight(panel.loadedContentHeight)

    content: PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      implicitHeight: column.implicitHeight
      onMoveRequested: function(dx, dy) {
        if (!root.cursorActive) { root.cursorActive = true; return }
        var delta = (dx !== 0 ? dx : dy) * 100
        var next = root.clampTemp(root.currentTemp + delta)
        root.applyLive(next)
        root.commitWarmth(next)
      }
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Style.space(14)

        Item {
          width: parent.width
          implicitHeight: heroLabel.implicitHeight

          Text {
            id: heroLabel
            textFormat: Text.PlainText
            text: Commons.I18n.t("nightlight.title", "Night Light")
            color: root.barForeground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.title
            font.bold: true
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            textFormat: Text.PlainText
            text: root.nightlightOn ? (Commons.I18n.formatNumber(root.currentTemp) + "K") : "Off"
            color: root.barForeground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.display
            font.bold: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
          }
        }

        PanelSlider {
          id: slider
          bar: root.bar
          width: parent.width
          minimum: root.minTemp
          maximum: root.maxTemp
          step: 100
          integer: true
          value: root.currentTemp
          onMoved: function(v) { root.applyLive(v) }
          onReleased: function(v) { root.commitWarmth(v) }
        }

        Toggle {
          id: bwToggle
          width: parent.width
          label: Commons.I18n.t("nightlight.bwFilter", "B&W Filter")
          description: Commons.I18n.t("nightlight.bwFilterDesc", "Whole-screen grayscale")
          checked: root.bwOn
          foreground: root.barForeground
          onClicked: root.toggleBw()
        }
      }
    }
  }
}
