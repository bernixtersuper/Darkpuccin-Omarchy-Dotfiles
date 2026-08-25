import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Module {
    id: root

    property int _signal: -1
    property var _icons: ["󰤯","󰤟","󰤢","󰤥","󰤨"]

    color: _signal < 0 ? Theme.inactive : Theme.net
    text: _signal < 0
        ? "󰤮"
        : _icons[Math.min(4, Math.floor(_signal / 20))]

    Process {
        id: pollProc
        // -f without -t gives human-readable columns: ACTIVE SIGNAL
        // first "yes" line is the connected network
        command: ["bash", "-c",
            "nmcli -f active,signal dev wifi 2>/dev/null | awk '/^yes/{print $2; exit}'"]
        running: false
        property string _buf: ""
        stdout: SplitParser {
            onRead: data => pollProc._buf = data.trim()
        }
        onRunningChanged: {
            if (!running) {
                root._signal = pollProc._buf !== "" ? (parseInt(pollProc._buf) || 0) : -1
                pollProc._buf = ""
            }
        }
    }

    Process { id: launchWifi; command: ["bash", "-c", "omarchy launch wifi"] }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: pollProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: launchWifi.running = true
    }
}
