---
name: qbar
description: Quickshell QML status bar at ~/.config/quickshell/qbar/. Use when editing the bar layout, adding/modifying modules (volume, battery, network, bluetooth, now playing, workspaces, clock), fixing colors, or changing the theme integration. Triggers on mentions of qbar, quickshell bar, waybar replacement, or any of the bar modules.
---

# qbar - Quickshell Status Bar

## Location & Running

```
~/.config/quickshell/qbar/
```

Run with:
```bash
qs -c ~/.config/quickshell/qbar
```

The bar sits at the **bottom** of the screen (anchors.bottom). Height is 28px matching waybar.

## Architecture

```
shell.qml        ← layout skeleton only: PanelWindow + left/center/right sections
Theme.qml        ← pragma Singleton: colors, font, barHeight — shared by all files
qmldir           ← REQUIRED: declares Theme as singleton + registers all custom types
Module.qml       ← base component for right-side widgets (underlined text item)
Workspaces.qml   ← Hyprland workspaces 1-3 persistent + higher if occupied
WindowTitle.qml  ← active window title (Hyprland.activeToplevel)
Clock.qml        ← Japanese format clock: (曜) MM月DD日 HH:MM:SS
NowPlaying.qml   ← extends Module, polls playerctl every 2s
Volume.qml       ← extends Module, polls pamixer every 1s, left/right click
Network.qml      ← extends Module, polls nmcli every 5s
Bluetooth.qml    ← extends Module, polls bluetoothctl every 5s
Battery.qml      ← extends Module, polls /sys/class/power_supply every 30s
```

## shell.qml Layout

Three anchored sections inside a full-fill `Item`:
- **leftBar**: `RowLayout` anchored left → `clockItem.left`; contains `Workspaces` + `WindowTitle`
- **clock**: `Clock` anchored `centerIn: parent`
- **rightBar**: `RowLayout` anchored right → `clockItem.right`, `layoutDirection: Qt.RightToLeft`

Right-side modules in shell.qml go **rightmost-first** because of `RightToLeft` layout:
```qml
Battery {}    // rightmost
Network {}
Bluetooth {}
Volume {}
NowPlaying {} // leftmost (closest to clock)
```

## Theme Singleton

`Theme.qml` has `pragma Singleton` and is declared in `qmldir`. Access from any file as `Theme.fg`, `Theme.accent`, etc. — no import or property passing needed.

Key properties:
- `Theme.fg`, `Theme.bg`, `Theme.accent`, `Theme.inactive` — dynamic, read from omarchy current theme every 2s
- `Theme.net`, `Theme.vol`, `Theme.backlight`, `Theme.warn`, `Theme.crit` — fixed module colors
- `Theme.fontFamily` = `"CaskaydiaMono Nerd Font"`, `Theme.fontSize` = 14, `Theme.barHeight` = 28

Theme colors come from `/home/berni/.config/omarchy/current/theme/waybar.css`. The file is polled via `Process` (not `FileView.watchChanges`) because the `current` path is a symlink and inotify watches inodes, not paths.

## Adding a New Module

1. Create `NewModule.qml` extending `Module`:
```qml
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Module {
    id: root
    color: Theme.someColor
    text: "icon " + value

    property var _value: ...

    Process {
        id: pollProc
        command: ["bash", "-c", "some-command"]
        running: false
        property string _buf: ""
        stdout: SplitParser {
            onRead: data => pollProc._buf = data.trim()
        }
        onRunningChanged: {
            if (!running) {
                root._value = pollProc._buf
                pollProc._buf = ""
            }
        }
    }

    Timer {
        interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: pollProc.running = true
    }
}
```

2. Register in `qmldir`:
```
NewModule 1.0 NewModule.qml
```

3. Add to `rightBar` in `shell.qml` — place it BEFORE the module to its right (RightToLeft order).

## Module.qml API

| Property | Type | Description |
|----------|------|-------------|
| `text` | string | Displayed text (alias to internal Text) |
| `color` | color | Text color AND underline color |
| `hpad` | int | Horizontal padding each side, default 8 |

The underline is 1px, flush to bar bottom, full module width. `implicitHeight` is explicitly set to `Theme.barHeight` to break the circular anchor dependency.

## qmldir — Critical

**Every new `.qml` file must be added to `qmldir`** or it won't be found. With a `qmldir` present, QML switches to explicit module mode — unlisted files are invisible even if in the same directory.

## Waybar Parity Reference

| Element | Value |
|---------|-------|
| Workspace padding | 7px each side (`implicitWidth = label + 14`) |
| Workspace spacing | 2px between items (`spacing: 2`) |
| Window title margin | `Layout.leftMargin: 14` |
| Clock padding | 10px each side (`width = text + 20`) |
| Module padding | 8px each side (`hpad: 8`) |
| Bar height | 28px |

## Omarchy Theme Integration

Active theme: `/home/berni/.config/omarchy/current/theme/waybar.css`

CSS variables mapped:
- `@foreground` → `Theme.fg`
- `@background` → `Theme.bg`
- `@workspace_active` → `Theme.accent`
- `@workspace_inactive` → `Theme.inactive`

Supports both hex (`#rrggbb`) and CSS `rgba()` via `_parseColor()` which converts to `Qt.rgba()`.
