import QtQuick
import QtQuick.Layouts

// Underlined bar widget. Use as base for right-side modules.
Item {
    id: mod
    property alias text:  lbl.text
    property alias color: lbl.color
    property int   hpad:  8

    Layout.fillHeight: true
    implicitWidth:  lbl.implicitWidth + hpad * 2
    implicitHeight: Theme.barHeight

    Text {
        id: lbl
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter:   parent.verticalCenter
        font { family: Theme.fontFamily; pixelSize: Theme.fontSize }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left:   parent.left
        anchors.right:  parent.right
        height: 1
        color: lbl.color
    }
}
