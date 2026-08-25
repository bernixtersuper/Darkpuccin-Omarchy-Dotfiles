import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Module {
    id: root

    property int  _vol:   0
    property bool _muted: false

    color: _muted ? Theme.inactive : Theme.vol
    text: {
        if (_muted)       return "󰖁"
        if (_vol < 34)    return "󰕿"
        if (_vol < 67)    return "󰖀"
        return "󰕾"
    }

    Process {
        id: pollProc
        command: ["bash", "-c", "echo $(pamixer --get-volume) $(pamixer --get-mute)"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split(" ")
                root._vol   = parseInt(p[0]) || 0
                root._muted = p[1] === "true"
            }
        }
    }

    Process { id: toggleMute;  command: ["pamixer", "-t"] }
    Process { id: launchAudio; command: ["bash", "-c", "omarchy launch audio"] }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: pollProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) toggleMute.running  = true
            else                                 launchAudio.running = true
        }
    }
}
