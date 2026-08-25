import QtQuick

Item {
    id: root

    height: Theme.barHeight
    width:  lbl.implicitWidth + 20  // 10px each side, matches waybar #clock padding

    function _format(d) {
        var dow = ["日","月","火","水","木","金","土"][d.getDay()]
        return "(" + dow + ") "
            + String(d.getMonth() + 1).padStart(2, "0") + "月"
            + String(d.getDate()).padStart(2, "0") + "日 "
            + String(d.getHours()).padStart(2, "0") + ":"
            + String(d.getMinutes()).padStart(2, "0") + ":"
            + String(d.getSeconds()).padStart(2, "0")
    }

    Text {
        id: lbl
        anchors.centerIn: parent
        color: Theme.fg
        font { family: Theme.fontFamily; pixelSize: Theme.fontSize }
        text: root._format(new Date())

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: lbl.text = root._format(new Date())
        }
    }
}
