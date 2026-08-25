---
name: omarchy-berni
description: >
  Reference for all personal customizations Bernardo has made on top of stock Omarchy.
  Use this skill when adding new keybindings, scripts, or config changes to Bernardo's
  Omarchy setup, so you know what is already customized and which keys are already rebound.
  Triggers: "add a keybinding", "what key is bound to", "my customizations", "what have I changed",
  "add a script", "what scripts do I have", and any time the omarchy skill is also active.
---

# Bernardo's Omarchy Customizations

This is a living reference of all personal changes on top of stock Omarchy.
**Always read this before adding new keybindings** to avoid conflicts with already-rebound keys.

---

## Custom Scripts

Located in `~/.config/hypr/scripts/`:

| Script | Purpose |
|--------|---------|
| `toggle-dense.sh` | Toggles "dense mode": zero gaps, no border for 1 window, no shadow. Writes/removes `~/.local/state/omarchy/toggles/hypr/window-dense.conf` then calls `hyprctl reload`. |
| `set-monitor-transform.sh` | Applies a transform (0-3) to a named monitor while reading current x/y position from `hyprctl monitors -j` so position is never overwritten. Usage: `set-monitor-transform.sh <monitor> <transform>`. Native resolutions hardcoded per monitor (eDP-1: 2880x1800, DP-3: 1920x1080). |
| `fix-monitors-on-resume.sh` | Re-applies all connected monitors' current transforms after wake/resume to fix position drift. Reads all monitors from `hyprctl monitors -j` and calls `set-monitor-transform.sh` for each. Hooked into `hypridle.conf` via `after_sleep_cmd` and the 152s listener `on-resume`. |
| `toggle-edge-scroll.sh` | Toggles `scroll_method = edge` on/off (baseline: default 2fg). Writes/removes `~/.local/state/omarchy/toggles/hypr/scroll-method.conf`, calls `hyprctl reload`, sends a notification. Bound to `SUPER CTRL M`. |

---

## Keybindings (`~/.config/hypr/bindings.conf`)

### Rebound / Unbound Stock Keys

These Omarchy defaults were explicitly unbound or overridden:

| Key | Stock action removed | New action |
|-----|----------------------|------------|
| `SUPER SHIFT BACKSPACE` | (stock action removed) | Toggle dense mode |
| `SUPER S` | scratchpad | Next workspace (r+1) |
| `SUPER A` | scratchpad alt | Previous workspace (r-1) |
| `SUPER SHIFT A` | (stock) | Move window to prev workspace |
| `SUPER K` | omarchy menu | (unbound, freed for vim-focus) |
| `SUPER J` | toggle split | (unbound, freed for vim-focus) |
| `SUPER CTRL J` | (stock) | Toggle window split |
| `SUPER CTRL K` | (stock) | Show keybindings menu |
| `SUPER L` | (stock lock/focus) | Focus right (vim) |
| `SUPER ALT F` | fullscreen | (unbound) |
| `SUPER CTRL A` | (stock) | wiremix TUI |
| `SUPER B` | (stock) | Bluetooth panel |
| `SUPER CTRL W` | (stock) | Wifi panel |
| `SUPER CTRL B` | (stock) | Battery status notification |
| `SUPER CTRL T` | (stock) | Show time notification |
| `SUPER SHIFT M` | Spotify | cliamp TUI |
| `SUPER SHIFT Y` | YouTube webapp | YouTube in Zen |
| `SUPER SHIFT P` | Google Photos webapp | Perplexity in Firefox |
| `SUPER SHIFT D` | Docker TUI | Discord in Zen |
| `SUPER SHIFT G` | Signal | WhatsApp in Zen |
| `SUPER SHIFT E` | nautilus (file manager) | Yazi (TUI file manager) |

### Custom Keybindings Added

**Window management:**
| Key | Action |
|-----|--------|
| `SUPER H` | Focus left |
| `SUPER J` | Focus down |
| `SUPER K` | Focus up |
| `SUPER L` | Focus right |
| `SUPER SHIFT H` | Move window left |
| `SUPER SHIFT J` | Move window down |
| `SUPER SHIFT K` | Move window up |
| `SUPER SHIFT L` | Move window right |
| `SUPER D` | Full width (fullscreen 1) |
| `SUPER ALT L` | Toggle workspace layout (omarchy script) |
| `SUPER CTRL J` | Toggle window split |

**Workspaces (GlazeWM style):**
| Key | Action |
|-----|--------|
| `SUPER S` | Next workspace |
| `SUPER A` | Previous workspace |
| `SUPER SHIFT S` | Move window to next workspace |
| `SUPER SHIFT A` | Move window to previous workspace |

**Screen rotation (eDP-1 only, position-preserving):**
| Key | Action |
|-----|--------|
| `SUPER [` | Normal (transform 0) |
| `SUPER ]` | Flipped 180 (transform 2) |
| `SUPER SHIFT [` | Rotate left 90 (transform 1) |
| `SUPER SHIFT ]` | Rotate right 90 (transform 3) |

**Apps & tools:**
| Key | Action |
|-----|--------|
| `SUPER SHIFT BACKSPACE` | Toggle dense mode |
| `SUPER CTRL K` | Show keybindings |
| `SUPER CTRL A` | wiremix (audio mixer TUI) |
| `SUPER CTRL W` | Wifi panel |
| `SUPER CTRL B` | Battery status notification |
| `SUPER CTRL T` | Show time notification |
| `SUPER CTRL M` | Toggle edge scrolling (scroll_method = edge) with notification |
| `SUPER CTRL D` | lazydocker TUI |
| `SUPER B` | Bluetooth panel |
| `SUPER ALT V` | Fix clipboard newlines (strips hard-wraps) |
| `SUPER SHIFT M` | cliamp (music player TUI) |
| `SUPER SHIFT Y` | YouTube in Zen |
| `SUPER SHIFT P` | Perplexity in Firefox |
| `SUPER SHIFT D` | Discord in Zen |
| `SUPER SHIFT G` | WhatsApp in Zen |
| `SUPER SHIFT Q` | Qutebrowser |
| `SUPER SHIFT E` | Yazi (TUI file manager) |
| `SUPER Q` | Force kill active window |

**Already used by stock Omarchy (do not rebind without unbinding first):**
`SUPER RETURN`, `SUPER ALT RETURN`, `SUPER SHIFT RETURN`, `SUPER SHIFT N`,
`SUPER SHIFT T`, `SUPER SHIFT SLASH`, `SUPER SHIFT B`, `SUPER SHIFT F`, `SUPER SHIFT O`,
`SUPER SHIFT W`, `SUPER SHIFT X`, `SUPER SHIFT ALT B`, `SUPER SHIFT ALT A`, `SUPER SHIFT ALT G`,
`SUPER SHIFT ALT X`, `SUPER SHIFT A` (now custom), `SUPER SHIFT S` (now custom).

---

## Look & Feel (`~/.config/hypr/looknfeel.conf`)

| Setting | Value | Note |
|---------|-------|------|
| `gaps_in` | 3 | Tighter than Omarchy default |
| `gaps_out` | 5 | Tighter than Omarchy default |
| `border_size` | 2 | Explicit |
| Workspace animation | slide | Replaces default |
| Window in/out/move animation | gnomed, duration 2 | Replaces default |
| Layer animation | slide, duration 2 | Replaces default |

Dense mode (via toggle script) overrides these to 0 gaps, no border, no shadow.

---

## Input (`~/.config/hypr/input.conf`)

| Setting | Value |
|---------|-------|
| `kb_layout` | us |
| `kb_options` | `compose:caps` (Caps Lock as Compose key) |
| `sensitivity` | 0.5 |
| `repeat_rate` | 40 |
| `repeat_delay` | 600 |
| `numlock_by_default` | true |
| `natural_scroll` | true |
| `scroll_factor` | 0.4 |
| `drag_3fg` | 1 (3-finger drag) |
| Alacritty/kitty/foot scroll | 1.5x touchpad multiplier |
| Ghostty scroll | 0.2x touchpad multiplier |
| Wacom tablet | Mapped to HDMI-A-1, region 0x240 size 1920x1200 |

---

## Monitors (`~/.config/hypr/monitors.conf`)

| Monitor | Resolution | Position | Scale | Transform |
|---------|-----------|----------|-------|-----------|
| eDP-1 (laptop) | 2880x1800@120 | 1274x1696 | 1.33 | 0 (normal) |
| DP-3 (external) | 1920x1080@100 | 0x0 | 1.0 | 1 (portrait, 90 CCW) |
| HDMI-A-1 | 2560x1440@100 | 1080x256 | 1.0 | - |
| fallback | preferred | auto | 1 | - |

Layout: DP-3 is in portrait on the left (effective 1080x1920), laptop screen sits to the right and below.
File is manually maintained. nwg-displays was removed. Edit directly.

Static config (`monitors.conf`):
```
monitor=DP-3,1920x1080@100,0x0,1.0,transform,1
monitor=eDP-1,2880x1800@120,1274x1696,1.33
monitor=HDMI-A-1,2560x1440@100.0,1080x256,1.0
monitor=,preferred,auto,1
```

Transforms are re-applied on resume via `fix-monitors-on-resume.sh` (see Autostart). Without this hook, eDP-1 drifts on wake.

---

## Autostart (`~/.config/hypr/autostart.conf`)

- `fcitx5` -- Japanese/Chinese input method
- `hyprctl setcursor Breeze_Dark 30` -- cursor theme and size
- `rfkill unblock bluetooth` -- ensure BT is unblocked on boot
- `sleep 3 && ~/.config/hypr/scripts/fix-monitors-on-resume.sh` -- re-applies transforms on first boot to fix initial position drift

Also hooked in `hypridle.conf`:
- `after_sleep_cmd = sleep 1 && omarchy-system-wake && sleep 2 && ~/.config/hypr/scripts/fix-monitors-on-resume.sh`
- `on-resume` listener: `omarchy-system-wake && sleep 2 && ~/.config/hypr/scripts/fix-monitors-on-resume.sh`

---

## Window Rules (`~/.config/hypr/hyprland.conf`)

- Emoji picker (`class:emoji-picker`): float, 600x500, centered

---

## GTK4 / Nautilus (`~/.config/gtk-4.0/gtk.css`)

Nautilus has a pure black background via libadwaita CSS variables, scoped to `window.nautilus-window` so other GTK4 apps are unaffected:

```css
window.nautilus-window {
  --window-bg-color: #000000;
  --view-bg-color: #000000;
  --sidebar-bg-color: #000000;
  --sidebar-backdrop-color: #000000;
  --headerbar-bg-color: #000000;
  --headerbar-backdrop-color: #000000;
}
```

Requires libadwaita >= 1.6 (CSS variables). Changes apply on next Nautilus launch (`nautilus -q` to quit running instances). Not theme-dependent: applies regardless of active omarchy theme.

---

## Mako Notifications (`~/.config/mako/config`)

Mako requires a config file to exist or it runs with zero styling. The file just includes the theme:

```ini
include=~/.config/omarchy/current/theme/mako.ini
```

Each theme's `mako.ini` is at `~/.config/omarchy/themes/<theme>/mako.ini` and includes:
```ini
include=~/.local/share/omarchy/default/mako/core.ini
text-color=...
border-color=...    # matches the theme's hypr border color exactly
background-color=...#40  # semi-transparent (40 = ~25% opacity hex)
padding=20,16
border-size=2
border-radius=0
outer-margin=8
```

Border colors per theme:
| Theme | border-color |
|-------|-------------|
| catppuccin-dark | `#EAB3FA` |
| golden-exposure | `#f0a010` |
| hatsune-miku | `#39c5bb` |
| neon-blade-runner | `#e8609a` |

After editing a theme's mako.ini, run `makoctl reload` or switch themes to pick up changes.

---

## Custom Themes (`~/.config/omarchy/themes/`)

| Theme | Notes |
|-------|-------|
| `golden-exposure` | Personal theme, warm golden tones |
| `catppuccin-dark` | Catppuccin Mocha palette, darker background (#010101) |
| `hatsune-miku` | Miku-themed, cyan/teal |
| `neon-blade-runner` | Neon/cyberpunk, Kasane Teto backgrounds |

`catppuccin-dark-og` also exists on live (stock omarchy theme) but is gitignored -- do not add it to the repo.

Current active theme: see `~/.config/omarchy/current/theme.name`.

---

## keyd (`/etc/keyd/`)

keyd intercepts input **before** Hyprland sees it. Single C daemon, ~1 MB RAM. Replaced input-remapper.
Modifier combos (Ctrl+Caps+H, Shift+Caps+H, etc.) are **automatic** via layer passthrough -- not explicitly configured.

To reload after editing: `sudo keyd reload`
To debug: `sudo keyd monitor`

### `/etc/keyd/keyboard.conf` -- nav layer (all keyboards via `*`)

CapsLock activates the `nav` layer while held. CapsLock alone produces nothing.
Applies to: laptop keyboard (AT Translated Set 2), BT 5.0 keyboard, Compx 2.4G receiver -- all automatically.

| Chord | Output |
|-------|--------|
| Caps + H / A | Left arrow |
| Caps + J / S | Down arrow |
| Caps + K / W | Up arrow |
| Caps + L / D | Right arrow |
| Caps + [ | Home |
| Caps + ] | End |
| Caps + ; | PageUp |
| Caps + ' | PageDown |
| Caps + / | Delete |
| Caps + Ctrl + any above | Ctrl + that arrow/nav key (word jump, go to top/bottom, tab switch) |
| Caps + Shift + any above | Shift + that key (selection) |
| Caps + Ctrl + Shift + any above | Ctrl+Shift + that key (select word) |

**Important for Hyprland bindings**: CapsLock never reaches Hyprland. Do not use Caps as a Hyprland modifier.

### `/etc/keyd/thinkpad.conf` -- ThinkPad media buttons (`17aa:5054`)

keyd names for the 3 physical media buttons (discovered via `keyd monitor`):

| keyd key name | Action |
|---------------|--------|
| `f16` | previoussong |
| `f23` | pausecd |
| `favorites` | nextsong |

### X3-5.4 Mouse (pending -- not yet migrated to keyd)

Mouse isn't always connected. When ready to configure: connect it, run `sudo keyd monitor`, get its vendor:product ID, and write `/etc/keyd/mouse.conf`.
Desired mappings (from old input-remapper presets):
- Anime: BTN_EXTRA=Ctrl, BTN_SIDE=A, BTN_MIDDLE=D
- Study: BTN_EXTRA=Ctrl, BTN_SIDE=Shift

---

## KDE Connect Remote Input (`hypr-kdeconnect-fix`)

Package `hypr-kdeconnect-fix` (AUR) bridges the `org.freedesktop.portal.RemoteDesktop` portal interface so KDE Connect remote mouse/keyboard input works on Hyprland.

**Portal config** at `~/.config/xdg-desktop-portal/portals.conf`:
```
[preferred]
default=gtk
org.freedesktop.impl.portal.ScreenCast=hyprland
org.freedesktop.impl.portal.Screenshot=hyprland
org.freedesktop.impl.portal.GlobalShortcuts=hyprland
org.freedesktop.impl.portal.RemoteDesktop=hypr-kdeconnect
```

**Service**: `hypr-kdeconnect-portal.service` (user systemd unit, binary at `/usr/bin/hypr-kdeconnect-portal`).

After changing portals.conf or reinstalling:
```bash
systemctl --user daemon-reload
systemctl --user restart xdg-desktop-portal
```

**Scroll speed**: the virtual pointer shows up as `hl-virtual-pointer-hypr-kdeconnect-portal` in `hyprctl devices`. Control scroll speed via a `device {}` block in `input.conf`:
```
device {
  name = hl-virtual-pointer-hypr-kdeconnect-portal
  scroll_factor = 0.15
}
```
Confirm the exact device name with `hyprctl devices | grep -i kdeconnect` while KDE Connect is actively sending input.

---

## Dotfiles Repo (`~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles`)

### Structure

All files live under `.config/` in the repo and map 1:1 to `~/.config/` on the live system. Theme files live at `.config/omarchy/themes/<theme>/` in the repo, mapping to `~/.config/omarchy/themes/<theme>/` on live.

**Never track (all in `.gitignore`):**
- `.config/omarchy/current/` -- autogenerated by omarchy on theme switch, not source of truth
- `.config/omarchy/themes/catppuccin-dark-og/` -- stock omarchy theme that exists on live, not a custom one
- `.config/mise/` -- mise treats any `config.toml` inside a directory as a project-level config and errors
- `.config/mozc/` -- session state, not config
- `.config/btop/themes/` -- symlinked, changes on theme switch
- `.config/nvim/lua/plugins/theme.lua` -- autogenerated by omarchy on theme switch
- `.config/fcitx5/conf/cached_layouts` -- autogenerated cache, changes constantly

### Syncing

`sync.sh` at repo root copies live files into the repo. It only touches files already tracked by git -- never adds new ones.

```bash
./sync.sh           # dry-run style: shows what changed, no commit
./sync.sh --commit  # sync and auto-commit
```

To add a new file to tracking: `git add <path>` once, then `sync.sh` handles future updates.

### Hypr scripts

`~/.config/hypr/scripts/` is tracked in the repo. Scripts live there, not in a separate scripts/ dir at root.

### Ghostty colors

All 4 themes have fully declarative `ghostty.conf` -- no `theme = ...` imports. Colors are explicit using `palette = INDEX=COLOR` (0-7 normal, 8-15 bright, 16-17 accent). Source of truth is each theme's `alacritty.toml` -- translate manually when updating. Do NOT use alacritty-format colors in ghostty.conf.

catppuccin-dark specifics: cursor/selection = rosewater `#f5e0dc`, palette 16 = peach `#fab387`, palette 17 = rosewater `#f5e0dc`.

### Waybar

Full waybar config is tracked -- `config.jsonc`, `style.css`, and three subdirs that must all be present:
- `modules/` -- per-module JSON definitions (25+ files, `hypr/`, `custom/`, root-level)
- `style/` -- CSS split into numbered layers (`00-vars.css` through `60-animations.css`)
- `scripts/` -- shell scripts called by modules

`style.css` imports from `style/` and `../omarchy/current/theme/waybar.css` (autogenerated, not tracked). If any of these subdirs are missing on live, waybar fails to start silently.

Waybar picks up theme colors from `~/.config/omarchy/current/theme/waybar.css`. Themes must define:
```css
@define-color workspace_active rgba(...);
@define-color workspace_inactive #...;
```
Without these variables the active workspace gets no highlight color.

### keyd

Configs stored in `keyd/` at repo root (not under `.config/`). `sync.sh` maps `keyd/*` -> `/etc/keyd/*` so it stays in sync automatically (read-only, doesn't need sudo). To install on a new machine:
```bash
sudo cp keyd/keyboard.conf /etc/keyd/keyboard.conf && sudo keyd reload
# ThinkPad only:
sudo cp keyd/thinkpad.conf /etc/keyd/thinkpad.conf && sudo keyd reload
```

### Fastfetch

Custom logo in `~/.config/fastfetch/logo.txt` (tracked). Uses `$1` color placeholder -- fastfetch replaces `$1` with the color defined in `"color": {"1": "#hex"}` in `config.jsonc`. Do NOT use ANSI escape codes directly in the logo file -- fastfetch strips the ESC byte and renders them as literal text.

### install.sh

Installs from repo to live. Prompts per section. Safe to run repeatedly -- reruns overwrite with the latest repo version (rsync without --delete, so nothing on live is removed).
- `--dry-run` shows what would change without writing anything
- `--skip <path>` excludes specific files (repeatable)
- All overwritten files backed up to `~/.dotfiles-backup/YYYYMMDD-HHMMSS/`

For copying to a new PC:
```bash
./install.sh --skip .config/hypr/monitors.conf \
             --skip .config/hypr/scripts/set-monitor-transform.sh
# then manually write monitors.conf and set up /etc/keyd/
```

Update workflow on existing machine after repo changes:
```bash
git pull && ./install.sh
```

---

## ITBA Enterprise WiFi (iwd / 802.1X)

The `ITBA` SSID is **WPA2-Enterprise (8021x, PEAP/MSCHAPv2)**, not a plain PSK. Impala (the iwd TUI) and the `iwctl connect` password prompt **cannot** configure it, they only handle PSK. You must drop an iwd 802.1X config file by hand.

> **Credential warning:** the file below contains Berni's ITBA password in plaintext. Never commit it to the dotfiles repo or anywhere public. It belongs only in `/var/lib/iwd/` (root-owned, `600`).

Create `/var/lib/iwd/ITBA.8021x`:
```ini
[Security]
EAP-Method=PEAP
EAP-Identity=bortiz
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=bortiz
EAP-PEAP-Phase2-Password=<REDACTED - rotate this credential>

[Settings]
AutoConnect=true
```

Install with correct ownership/perms (iwd refuses world-readable secret files):
```bash
sudo install -o root -g root -m 600 ITBA.8021x /var/lib/iwd/ITBA.8021x
iwctl station wlan0 connect ITBA
```

The filename **must** be `<SSID>.8021x` (here `ITBA.8021x`). Wifi device is `wlan0`.

**If the login is rejected**, try in this order:
1. Add the domain to both identities: `EAP-Identity=bortiz@itba.edu.ar` and `EAP-PEAP-Phase2-Identity=bortiz@itba.edu.ar`.
2. Skip server-cert validation (fine on the known campus network): add `EAP-PEAP-ServerDomainMask=*` under `[Security]`.

`ITBA-Libre` is the open captive-portal network as a fallback. After editing the config, `iwctl station wlan0 disconnect` then reconnect to force iwd to re-read it.

---

## How to Add New Customizations

1. **New keybinding**: check the "Already used" list above AND run `omarchy menu keybindings --print`. Add `unbind` before `bind` if the key was previously bound. Update this skill.
2. **New script**: add to `~/.config/hypr/scripts/`, make executable, update this skill.
3. **Monitor changes**: edit `monitors.conf` directly (no nwg-displays). Update the table above.
4. **New window rule**: add to `~/.config/hypr/hyprland.conf` under the emoji picker rule. Check current wiki syntax first (it changes between versions).
5. **New keyd mapping**: edit `/etc/keyd/<device>.conf`, run `sudo keyd reload`, update this skill.
6. **New dotfile to track**: `git add <path>` once in the repo, then `./sync.sh` handles future syncs.
7. **New background**: copy image to `~/.config/omarchy/themes/<theme>/backgrounds/`, then `git add` it in the repo.
