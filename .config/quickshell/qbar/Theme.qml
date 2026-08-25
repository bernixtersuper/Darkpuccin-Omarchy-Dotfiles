pragma Singleton
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    // Visual constants
    property string fontFamily: "CaskaydiaMono Nerd Font"
    property int    fontSize:   14
    property int    barHeight:  28

    // Dynamic colors (from omarchy current theme)
    property color fg:       "#ffffff"
    property color bg:       "#000000"
    property color accent:   "#ffffff"
    property color inactive: "#333333"

    // Fixed module colors (from waybar 00-vars.css)
    property color net:       "#00e5ff"
    property color vol:       "#ffe066"
    property color backlight: "#7c86ff"
    property color warn:      "#FF9F00"
    property color crit:      "#FF2A1A"

    property string _buf: ""

    property Process _proc: Process {
        command: ["cat", "/home/berni/.config/omarchy/current/theme/waybar.css"]
        stdout: SplitParser {
            onRead: data => root._buf += data + "\n"
        }
        onRunningChanged: {
            if (!running && root._buf !== "") {
                root._parse(root._buf)
                root._buf = ""
            }
        }
    }

    property Timer _poll: Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root._proc.running = true
    }

    function _parseColor(val) {
        var m = val.match(/rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)/)
        if (m) return Qt.rgba(m[1] / 255, m[2] / 255, m[3] / 255, parseFloat(m[4]))
        return Qt.color(val)
    }

    function _parse(css) {
        var re = /@define-color\s+(\w+)\s+([^;]+)/g
        var m
        while ((m = re.exec(css)) !== null) {
            var name = m[1].trim()
            var val  = m[2].trim()
            if      (name === "foreground")         fg       = _parseColor(val)
            else if (name === "background")         bg       = _parseColor(val)
            else if (name === "workspace_active")   accent   = _parseColor(val)
            else if (name === "workspace_inactive") inactive = _parseColor(val)
        }
    }
}
