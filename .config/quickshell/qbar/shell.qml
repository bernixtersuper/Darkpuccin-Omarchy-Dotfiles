import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    anchors.bottom: true
    anchors.left:   true
    anchors.right:  true
    implicitHeight: Theme.barHeight
    color: Theme.bg

    Item {
        anchors.fill: parent

        // Left: workspaces + active window title
        RowLayout {
            id: leftBar
            anchors.left:   parent.left
            anchors.top:    parent.top
            anchors.bottom: parent.bottom
            anchors.right:  clock.left
            spacing: 2

            Workspaces {}

            WindowTitle {
                Layout.fillWidth:  true
                Layout.leftMargin: 14
                Layout.alignment:  Qt.AlignVCenter
            }
        }

        // Center: clock
        Clock {
            id: clock
            anchors.centerIn: parent
        }

        // Right: modules pack inward from the right edge
        RowLayout {
            id: rightBar
            anchors.right:  parent.right
            anchors.left:   clock.right
            anchors.top:    parent.top
            anchors.bottom: parent.bottom
            spacing: 0
            layoutDirection: Qt.RightToLeft

            Battery    {}
            Network    {}
            Bluetooth  {}
            Volume     {}
            NowPlaying {}
        }
    }
}
