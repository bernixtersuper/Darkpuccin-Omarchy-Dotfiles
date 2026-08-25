import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// Workspaces 1-3 persistent + any higher workspace that has windows.
RowLayout {
    spacing: 2  // 1px margin each side, matches waybar margin: 0 1px
    Layout.fillHeight: true

    Repeater {
        model: {
            var ids = [1, 2, 3]
            for (var ws of Hyprland.workspaces.values)
                if (ws.id > 3 && !ids.includes(ws.id)) ids.push(ws.id)
            ids.sort((a, b) => a - b)
            return ids
        }

        Item {
            required property int modelData
            property var  ws:       Hyprland.workspaces.values.find(w => w.id === modelData)
            property bool isActive: Hyprland.focusedWorkspace?.id === modelData

            Layout.fillHeight: true
            implicitWidth:  wsLabel.implicitWidth + 14  // 7px each side, matches waybar padding: 0 7px
            implicitHeight: Theme.barHeight

            Text {
                id: wsLabel
                anchors.centerIn: parent
                text:  parent.modelData
                color: parent.isActive ? Theme.accent : (parent.ws ? Theme.fg : Theme.inactive)
                font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }
            }

            Rectangle {
                visible: parent.isActive
                anchors.bottom: parent.bottom
                anchors.left:   parent.left
                anchors.right:  parent.right
                height: 1
                color:  Theme.accent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + parent.modelData)
            }
        }
    }
}
