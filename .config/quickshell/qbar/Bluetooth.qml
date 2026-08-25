import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Module {
    id: root

    property bool _on:        false
    property bool _connected: false

    // Same color for all states, matches waybar @bt_on/#bt_connected/#bt_off all being #1E8BFF
    color: _on ? "#1E8BFF" : Theme.inactive

    text: _connected ? "󰂱" : (_on ? "" : "󰂲")

    Process {
        id: pollProc
        command: ["bash", "-c",
            "powered=$(bluetoothctl show 2>/dev/null | awk '/Powered:/{print $2}'); " +
            "connected=$(bluetoothctl info 2>/dev/null | grep -c 'Connected: yes'); " +
            "echo $powered $connected"]
        running: false
        property string _buf: ""
        stdout: SplitParser {
            onRead: data => pollProc._buf = data.trim()
        }
        onRunningChanged: {
            if (!running) {
                var p = pollProc._buf.split(" ")
                root._on        = p[0] === "yes"
                root._connected = parseInt(p[1]) > 0
                pollProc._buf   = ""
            }
        }
    }

    Process { id: launchBt; command: ["bash", "-c", "omarchy launch bluetooth"] }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: pollProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: launchBt.running = true
    }
}
