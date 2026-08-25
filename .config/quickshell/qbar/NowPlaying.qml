import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Module {
    id: root

    color: Theme.fg
    text:  "󰝚 " + _title.substring(0, 50)

    visible: _title !== ""
    Layout.preferredWidth: visible ? implicitWidth : 0

    property string _title: ""
    property string _buf:   ""

    Process {
        id: proc
        command: ["playerctl", "metadata", "--format", "{{title}}"]
        running: false
        stdout: SplitParser {
            onRead: data => root._buf = data.replace(/\s*\[[^\]]*\]/g, "").trim()
        }
        onRunningChanged: {
            if (!running) {
                root._title = root._buf
                root._buf = ""
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }
}
