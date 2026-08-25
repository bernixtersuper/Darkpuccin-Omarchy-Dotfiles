import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Module {
    id: root

    property int    _capacity: 100
    property string _status:   "Unknown"
    property var    _icons:    ["󰂎","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"]

    // Green always except critical (<20%) which turns red, matching waybar bat_good as default
    color: _capacity < 20 ? Theme.crit : "#00ff6a"

    text: {
        if (_status === "Charging")                  return "󰂄 " + _capacity
        if (_status === "Full" || _capacity >= 100)  return "󰁹 " + _capacity
        return _icons[Math.min(9, Math.floor(_capacity / 10))] + " " + _capacity
    }

    Process {
        id: pollProc
        command: ["bash", "-c",
            "bat=$(ls /sys/class/power_supply/ 2>/dev/null | grep -iE '^bat' | head -1); " +
            "[ -n \"$bat\" ] && echo $(cat /sys/class/power_supply/$bat/capacity) $(cat /sys/class/power_supply/$bat/status)"]
        running: false
        property string _buf: ""
        stdout: SplitParser {
            onRead: data => pollProc._buf = data.trim()
        }
        onRunningChanged: {
            if (!running && pollProc._buf !== "") {
                var p = pollProc._buf.split(" ")
                root._capacity = parseInt(p[0]) || 0
                root._status   = p[1] || "Unknown"
                pollProc._buf  = ""
            }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: pollProc.running = true
    }
}
