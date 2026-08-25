import Quickshell.Hyprland
import QtQuick

Text {
    text:  Hyprland.activeToplevel?.title ?? ""
    color: Theme.fg
    elide: Text.ElideRight
    font { family: Theme.fontFamily; pixelSize: Theme.fontSize }
}
