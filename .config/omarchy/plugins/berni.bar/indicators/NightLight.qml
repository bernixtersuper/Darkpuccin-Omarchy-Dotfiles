import QtQuick
import Quickshell
import qs.Ui

BarIndicator {
  id: root

  readonly property var nightlightService: bar?.shell?.firstPartyServiceFor("omarchy.nightlight")

  active: nightlightService ? nightlightService.enabled : false
  activeText: "󰔎"
  inactiveText: "󰔎"
  activeTooltipText: "Day Light"
  inactiveTooltipText: "Night Light"

  // Runs the same script as the SUPER+CTRL+N shortcut (see
  // ~/.config/hypr/scripts/toggle-nightlight-warmth.sh) instead of calling
  // nightlightService.setNightlight() directly, which snaps to a hardcoded
  // 4000K. This way the indicator click and the shortcut always agree on
  // what "on" means -- the last warmth set via berni.nightlight-gauge's
  // slider -- and both clear the B&W filter the same way if it's active.
  function toggle() {
    root.bar?.run(Quickshell.env("HOME") + "/.config/hypr/scripts/toggle-nightlight-warmth.sh")
  }

  onPressed: function() { root.toggle() }
}
