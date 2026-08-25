---
name: caelestia
description: >
  Use for configuring Caelestia Shell — the Quickshell-based bar/desktop shell
  that replaces Waybar. Triggers when editing ~/.config/caelestia/shell.json,
  per-monitor configs, fonts, bar entries, widgets, wallpapers, color schemes,
  launching/killing the shell, or asking about Caelestia options and behavior.
---

# Caelestia Shell Skill

Caelestia Shell is a Quickshell/QML-based desktop shell for Hyprland that replaces Waybar.

## System Setup (this machine)

| Component | Detail |
|-----------|--------|
| Quickshell binary | `/usr/local/bin/qs` (also `quickshell`) — built from source with `-DCRASH_HANDLER=OFF` |
| Caelestia QML config | `~/.config/quickshell/caelestia/` (git repo: `github.com/caelestia-dots/shell`) |
| User config | `~/.config/caelestia/shell.json` |
| Per-monitor config | `~/.config/caelestia/monitors/<screen-name>/shell.json` |
| State files | `~/.local/state/caelestia/` |
| Network | **No NetworkManager** — uses iwd + systemd-networkd. Network widgets in the bar will not work. |

## Launch / Kill

```bash
# Start (kill waybar first)
pkill waybar; qs -c caelestia &disown

# Kill caelestia
pkill -f caelestia

# Back to Waybar
pkill -f caelestia && omarchy restart waybar
```

**Note:** `pkill quickshell` does NOT work — the process runs as `qs`. Always use `pkill -f caelestia`.

## Config File: ~/.config/caelestia/shell.json

This file is NOT created by default — create it manually. Omitted options use defaults.
Only put options you want to change. Do NOT copy the entire example config.

### Fonts (important — system uses CaskaydiaMono globally via fontconfig)

Always explicitly set fonts in shell.json or the system monospace font will override everything:

```json
{
    "appearance": {
        "font": {
            "family": {
                "clock": "CaskaydiaCove NF",
                "material": "Material Symbols Rounded",
                "mono": "CaskaydiaCove NF",
                "sans": "CaskaydiaCove NF"
            }
        }
    }
}
```

Verified working font family names on this system:
- `"CaskaydiaCove NF"` — proportional text (from `ttf-cascadia-code-nerd`)
- `"Material Symbols Rounded"` — icons (from `ttf-material-symbols-variable`)
- `"CaskaydiaMono Nerd Font"` — monospace (from `ttf-cascadia-mono-nerd`, already installed)

### Bar entries

Control what appears in the bar and in what order:

```json
{
    "bar": {
        "entries": [
            { "id": "logo",         "enabled": true },
            { "id": "workspaces",   "enabled": true },
            { "id": "spacer",       "enabled": true },
            { "id": "activeWindow", "enabled": true },
            { "id": "spacer",       "enabled": true },
            { "id": "tray",         "enabled": true },
            { "id": "clock",        "enabled": true },
            { "id": "statusIcons",  "enabled": true },
            { "id": "power",        "enabled": true }
        ],
        "status": {
            "showNetwork": false,
            "showWifi": false,
            "showBattery": true,
            "showBluetooth": true,
            "showAudio": false
        }
    }
}
```

### Disable network widgets (recommended — no NetworkManager)

```json
{
    "bar": {
        "status": {
            "showNetwork": false,
            "showWifi": false
        }
    }
}
```

### Per-monitor config

Override options for a specific screen (e.g. disable bar on external monitor):

**`~/.config/caelestia/monitors/DP-1/shell.json`**
```json
{
    "bar": {
        "persistent": false
    }
}
```

Internal display on this machine: `eDP-1`

### Wallpapers

Wallpapers are read from `~/Pictures/Wallpapers` by default.
To change: add `"paths": { "wallpaperDir": "~/your/path" }` to shell.json.

## After any config change

Just restart the shell — no rebuild needed:
```bash
pkill -f caelestia; qs -c caelestia &disown
```

## Updating Caelestia

```bash
cd ~/.config/quickshell/caelestia
git pull
cmake --build build
sudo cmake --install build
pkill -f caelestia; qs -c caelestia &disown
```

## Full example shell.json reference

See `~/.config/quickshell/caelestia/README.md` for the complete list of all options with defaults.
