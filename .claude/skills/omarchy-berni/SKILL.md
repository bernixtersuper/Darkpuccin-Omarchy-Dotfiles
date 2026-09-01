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

Living reference of everything layered on top of stock Omarchy.
**Read this before adding keybindings** so you don't collide with an already-rebound key.

> **Omarchy 4.x.** Hyprland is configured in **Lua** (`~/.config/hypr/*.lua`), not hyprlang.
> The bar and notifications are the **Omarchy shell** (Quickshell), not Waybar/Mako.
> Anything in this file that mentions a `.conf` for Hyprland, a `scripts/` directory,
> Waybar, Mako, Walker or Swayosd is gone — see [What no longer exists](#what-no-longer-exists).

Verify against live before trusting a detail: `omarchy version`, `hyprctl configerrors`.

---

## Hyprland config layout

`~/.config/hypr/hyprland.lua` is the entrypoint. It sources Omarchy's defaults first, then
these personal overrides in order:

| File | Holds |
|------|-------|
| `monitors.lua` | Monitor geometry — **the only hardware-specific file** |
| `input.lua` | Pointer/touchpad/keyboard, gestures, Wacom mapping |
| `bindings.lua` | All key rebinds |
| `looknfeel.lua` | Gaps, rounding, animations |
| `workspaces.lua` | Workspace rules, app→workspace pinning |
| `autostart.lua` | Extra startup commands |

Still `.conf` because Omarchy hasn't moved them: `hyprsunset.conf`, `xdph.conf`.
There is also a `.luarc.json` for editor LSP support.

**Two helper globals** (provided by Omarchy's bootstrap):
- `o.bind(keys, description, action)` — add a binding; `hl.unbind(keys)` — release a stock one
- `hl.config{}`, `hl.monitor{}`, `hl.animation{}`, `hl.device{}`, `hl.workspace_rule{}`,
  `hl.gesture{}`, `hl.env()`, `hl.on(event, fn)`, `hl.get_monitor(name)`

Apply changes with `hyprctl reload`, then **always** check `hyprctl configerrors`.

---

## Keybindings (`bindings.lua`)

Anything rebound must be `hl.unbind()`-ed first or Hyprland keeps both.

### Vim-style focus & movement

| Key | Action |
|-----|--------|
| `SUPER H/J/K/L` | Focus left / down / up / right |
| `SUPER SHIFT H/J/K/L` | Move window left / down / up / right |

`SUPER J`, `SUPER K`, `SUPER L` are unbound from stock first (they were toggle-split,
keybindings menu, and workspace-layout). Their replacements:

| Key | Action |
|-----|--------|
| `SUPER CTRL J` | Toggle window split |
| `SUPER CTRL K` | Show keybindings menu |
| `SUPER ALT L` | Toggle workspace layout |

### Workspaces (GlazeWM style)

| Key | Action |
|-----|--------|
| `SUPER S` / `SUPER A` | Next / previous workspace |
| `SUPER SHIFT S` / `SUPER SHIFT A` | Move window to next / previous workspace |

Unbound to free these: `SUPER S` (scratchpad), `SUPER ALT S` (move-to-scratchpad,
dropped deliberately), `SUPER SHIFT S` (Google Maps), `SUPER SHIFT A` (ChatGPT).

### Window management

| Key | Action |
|-----|--------|
| `SUPER D` | Full width (`fullscreen` maximized) — replaces stock `SUPER ALT F` |

### Applications

| Key | Action | Replaced |
|-----|--------|----------|
| `SUPER SHIFT E` | Yazi (TUI file manager) | Email webapp |
| `SUPER SHIFT T` | btop | — |
| `SUPER CTRL D` | lazydocker | Display panel |
| `SUPER SHIFT P` | Perplexity in Firefox | Google Photos |
| `SUPER SHIFT X` | tuxedo | X webapp |
| `SUPER SHIFT M` | cliamp (music, launch-or-focus) | Spotify |
| `SUPER SHIFT C` | Chromium | Calendar webapp |
| `SUPER ALT H` | herdr (launch-or-focus, pinned to `🐑`) | — |
| `SUPER SHIFT ALT H` | Move window to `🐑` workspace | — |

`{ tui = "x" }` opens in a terminal; `focus = true` focuses an existing window instead of
launching a second copy. `🐑` has no digit, so `SUPER SHIFT <n>` can't reach it — hence the
dedicated move bind.

### Hardware panels & notifications

| Key | Action | Replaced |
|-----|--------|----------|
| `SUPER B` | Bluetooth panel | — |
| `SUPER CTRL B` | Battery/power panel | Bluetooth (moved to `SUPER B`) |
| `SUPER CTRL T` | Show time notification | btop (moved to `SUPER SHIFT T`) |

`SUPER CTRL P` (stock) also opens the power panel — both keys work.

### Screen rotation (eDP-1)

| Key | Transform |
|-----|-----------|
| `SUPER [` | 0 — normal |
| `SUPER ]` | 2 — flipped 180 |
| `SUPER SHIFT [` | 1 — rotate left 90 |
| `SUPER SHIFT ]` | 3 — rotate right 90 |

A bare `hyprctl keyword monitor` resets position and scale. The local `set_transform()`
helper reads current geometry via `hl.get_monitor()` and re-applies mode/position/scale
alongside the new transform. Pure Lua — no shell, no jq.

### Utilities

| Key | Action |
|-----|--------|
| `SUPER ALT V` | Fix clipboard newlines (strips hard wraps via perl) |
| `HOME` | Push-to-talk dictation (voxtype), press and release |

Dictation is guarded by `o.cmd_present("voxtype")`, so it no-ops if voxtype isn't installed.
Omarchy's stock `F9` dictation binding is left alone.

### Commented out — do not assume these work

- `SUPER Q` force-kill: the old config shelled out to a nonexistent `forcekillactive`
  binary, so it never worked. A native `hl.dsp.window.kill()` line sits commented out.
- `SUPER CTRL M` edge-scroll toggle: needs `scripts/toggle-edge-scroll.sh`, which was lost
  in the 4.0 migration and is not in the dotfiles repo. Restore the script to re-enable.

### Stock keys still in use — unbind before reusing

`SUPER RETURN`, `SUPER ALT RETURN`, `SUPER SHIFT RETURN`, `SUPER SHIFT N`, `SUPER SHIFT O`,
`SUPER SHIFT SLASH`, `SUPER SHIFT ALT B`, `SUPER SHIFT ALT A`, `SUPER SHIFT CTRL G`,
`SUPER SHIFT ALT X`, `SUPER CTRL W`, `SUPER CTRL P`.

Authoritative check: `omarchy menu keybindings --print`.

---

## Look & feel (`looknfeel.lua`)

Only settings that **differ** from Omarchy 4 defaults live here.

| Setting | Value | Why |
|---------|-------|-----|
| `gaps_in` / `gaps_out` | `0` / `0` | Windows sit flush; only the 2px border separates them |
| `decoration.rounding` | `0` | Pinned — **themes override rounding** (Solitude sets 6) and load *before* this file |

`rounding` also propagates to the bar: the Omarchy shell reads `decoration:rounding` via
`hyprctl` into `Style.cornerRadius`, so pinning 0 squares the bar widgets too.

Already matching defaults, deliberately not repeated: `border_size 2`,
`decoration.shadow.enabled false`, layout `dwindle`.

**Animations** (all replace Omarchy defaults, speed 2, bezier `default`):

| Leaf | Style |
|------|-------|
| `workspaces` | `slide` — Omarchy disables this by default |
| `windowsIn` / `windowsOut` | `gnomed` |
| `windowsMove` | (no style) |
| `layers` | `slide` |

Kept as commented reference: per-app opacity (firefox, youtube-music) and
`single_window_aspect_ratio`.

---

## Input (`input.lua`)

| Setting | Value | Default |
|---------|-------|---------|
| `sensitivity` | `0.5` | 0 |
| `repeat_delay` | `600` | 250 |
| `touchpad.natural_scroll` | `true` | false |
| `touchpad.clickfinger_behavior` | `false` | **true in 4.0** — kept off on purpose; delete the line to adopt two-finger click |

Matching defaults, not repeated: `kb_layout us`, `repeat_rate 40`, `numlock_by_default true`,
`touchpad scroll_factor 0.4`, terminal `scroll_touchpad` window rules.

**Gesture:** 3-finger horizontal swipe → switch workspace (Omarchy ships no gestures).

**Wacom Intuos PT S** (`wacom-intuos-pt-s-2-pen`) remaps *dynamically*:
- HDMI-A-1 present → mapped to the bottom-left `1920x1200` region of the 2560x1440 panel.
  That region is 16:10 like the tablet, so circles stay round; the full panel would squash
  the vertical axis ~10%.
- Otherwise → whole of eDP-1 (natively 16:10, so 1:1). `region_size {0,0}` clears the
  previous region — without it the old one lingers.

Re-evaluated via `hl.on("monitor.added"/"monitor.removed", map_tablet)`.

> **Caps Lock is not available as a Hyprland modifier** — keyd consumes it. See [keyd](#keyd).

---

## Monitors (`monitors.lua`)

**The only hardware-specific file.** Skip it when installing elsewhere.

| Monitor | Mode | Position | Scale | Transform |
|---------|------|----------|-------|-----------|
| `DP-3` | 1920x1080@100 | 0x0 | 1 | 1 (portrait, 90° CCW) |
| `eDP-1` | 2880x1800@120 | 1280x1696 | 1.333333 | — |
| `HDMI-A-1` | 2560x1440@120 | 1080x256 | 1 | **currently commented out** |
| fallback | preferred | auto | 1.6 | — |

`GDK_SCALE=2`. Logical layout after scale/transform is drawn as ASCII art at the top of
the file — update it when geometry changes.

Maintained by hand; nwg-displays was removed. `hl.get_monitor()` is how bindings read
current geometry.

---

## Workspaces (`workspaces.lua`)

- **Smart gaps**: `w[tv1]` (single tiled window) and `f[1]` (single fullscreen) get
  `gaps_in/out = 0`, and that lone window gets `border_size 0`, `rounding 0`.
  Scoped to `float = false` so floating windows keep their border.
  Currently no-ops since global gaps are already 0 — kept so they work if gaps return.
- `org.omarchy.cliamp` → workspace `10`
- `org.omarchy.herdr` → workspace `name:🐑`

---

## Autostart (`autostart.lua`)

- `hyprctl setcursor breeze-dark 30` — note the theme is **`breeze-dark`** on this machine;
  the pre-4.0 `Breeze_Dark` silently failed.
- `rfkill unblock bluetooth` — the ThinkPad hardware switch sometimes comes up soft-blocked.

**fcitx5 is deliberately NOT started here** — Omarchy 4 runs it via the
`omarchy-fcitx5.service` user unit plus an XDG autostart entry. Adding it back duplicates
the daemon.

---

## Omarchy shell (`~/.config/omarchy/shell.json`)

Bar at the **bottom**, not transparent, centred on `berni.clock`.

| Section | Widgets |
|---------|---------|
| left | `berni.workspaces`, `berni.active-window` |
| center | `omarchy.keyboard-layout`, `omarchy.system-update`, `omarchy.indicators`, `berni.clock`, `omarchy.weather` |
| right | `omarchy.tray`, `omarchy.tailscale`, `omarchy.agents`, `omarchy.bluetooth`, `omarchy.network`, `omarchy.audio`, `omarchy.monitor`, `omarchy.power` |

**Idle:** screensaver `150`s, lock `300`s.

**Clock** is Japanese-locale (`ja_JP`), default format `(ddd) MM月dd日 HH:mm:ss`,
vertical format `HH\n—\nmm`, with four cycle-through formats.

### Custom plugins (`~/.config/omarchy/plugins/`)

| Plugin | Notes |
|--------|-------|
| `berni.bar` | The bar itself — `Bar.qml`, `BarModel.js`, plus `widgets/` (ActiveWindow, Indicators, KeyboardLayout, Microphone, Spacer, SystemUpdate, Tray, Workspaces) and `indicators/` (Dictation, Dnd, NightLight, Reminder, ScreenRecording, StayAwake) |
| `berni.clock` | `BarWidget.qml`, `Panel.qml`, `Model.js` |
| `berni.workspaces` | `Workspaces.qml` |
| `berni.active-window` | `ActiveWindow.qml` |

These are **clones** of the `omarchy.*` originals (`omarchy plugin clone <id>` renames the
prefix to the username). Never edit the packaged copies under `/usr/share/omarchy/`.

`shell.json` and plugin QML hot-reload on save. Otherwise: `omarchy restart shell`.
`shell.toml` holds only `[font] base-size = 12`.

---

## Hooks (`~/.config/omarchy/hooks/`)

Event dirs: `battery-low.d`, `font-set.d`, `post-boot.d`, `post-update.d`,
`pre-refresh-pacman.d`, `theme-set.d`. Files ending `.sample` are inert examples.

Active, in `post-update.d/`:

| Hook | Purpose |
|------|---------|
| `install-voxtype.hook` | Installs voxtype (dictation) if absent |
| `setup-agent.hook` | Invites agent setup once; no-ops if one is already chosen |
| `setup-fingerprint.hook` | Invites fingerprint setup only when a reader exists and the lock PAM file isn't written yet |

Install new ones with `omarchy hook install <event> <script>`.

---

## Menu extension

`~/.config/omarchy/extensions/omarchy-menu.jsonc` — hot-reloads on save.

---

## keyd (`/etc/keyd/`)

keyd intercepts input **before Hyprland sees it**. Single C daemon, ~1 MB.
Replaced input-remapper. Reload: `sudo keyd reload`. Debug: `sudo keyd monitor`.

Modifier combos (Ctrl/Shift + a nav chord) work **automatically** via layer passthrough —
they are not configured explicitly.

### `keyboard.conf` — nav layer

Applies to all keyboards (`*`) **except** the mouse and ThinkPad media device, which are
excluded by id (`-045e:0040`, `-17aa:5054`) so their own configs win.

`capslock = layer(nav)` — held, it activates the layer; alone it produces nothing.

| Chord | Output |
|-------|--------|
| Caps + `H`/`J`/`K`/`L` | Left / Down / Up / Right |
| Caps + `A`/`S`/`W`/`D` | Left / Down / Up / Right (same layer) |
| Caps + `[` / `]` | Home / End |
| Caps + `;` / `'` | PageUp / PageDown |
| Caps + `/` | Delete |

Add Ctrl for word-jump/document-ends, Shift for selection, both for select-word.

> **Never use Caps as a Hyprland modifier** — it never reaches the compositor.

### `thinkpad.conf` — media buttons (`17aa:5054`)

keyd names discovered via `keyd monitor`:

| keyd name | Action |
|-----------|--------|
| `f16` | previoussong |
| `f23` | pausecd |
| `favorites` | nextsong |

### `mouse.conf` — X3-5.4 (`045e:0040`)

Thumb buttons held as modifiers: `mouse2 = layer(alt)`, `mouse1 = layer(control)`.

---

## Themes

Four custom themes in `~/.config/omarchy/themes/`: `catppuccin-dark` (Mocha, `#010101` bg,
accent `#fab3e5`), `golden-exposure`, `hatsune-miku`, `neon-blade-runner`.

**Omarchy 4 theme format.** A theme is now `colors.toml` plus a few app files —
Omarchy *generates* the per-app configs from it via templates in
`/usr/share/omarchy/default/themed/`.

```
<theme>/
  colors.toml     <- source of truth: accent, selection, muted, background,
                     foreground, red/yellow/orange/green/cyan/blue/magenta/brown,
                     bright_* variants, mode = "dark"
  hyprland.lua    btop.theme   icons.theme   neovim.lua   vscode.json
  preview.png     backgrounds/
```

To recolour something, edit `colors.toml` and re-apply the theme. Do **not** hand-write
`alacritty.toml` / `ghostty.conf` / `mako.ini` / `waybar.css` — 4.0 does not read them.

Active theme: `cat ~/.local/state/omarchy/current/theme.name`
(**moved** from `~/.config/omarchy/current/`, which no longer exists).

`catppuccin-dark-og` exists on live (stock) but is gitignored — never add it to the repo.

---

## Obsidian (`~/Desktop/Facultad_Obsidian`)

Two relevant themes in `.obsidian/themes/`:

| Theme | Behaviour |
|-------|-----------|
| `Omarchy` | **Auto-generated** from `/usr/share/omarchy/default/themed/obsidian.css.tpl` using the *active* system theme's `colors.toml`. Regenerated on every `omarchy theme set` — editing it is pointless. |
| `Omarchy Tokyo Night` | **Static.** Same template, rendered once with the stock `tokyo-night` palette, so it matches Omarchy's tokyo-night exactly. Not affected by theme switches. |
| `Tokyo Night` | Community theme (tcmmichaelb139), ~2100 lines. **Currently active.** Much richer styling than the 99-line palette swap above, but its colours are its own, not Omarchy's. |

Template quirk: `{{ selection_background }}` reads the `selection` key from `colors.toml`;
every other placeholder maps by name.

Switch with `cssTheme` in `.obsidian/appearance.json` (Obsidian rewrites this file itself,
so check it rather than assuming). To pin Obsidian to another palette, render the template
with that theme's `colors.toml` into a new theme dir rather than editing the `Omarchy` one.

---

## fastfetch

`~/.config/fastfetch/config.jsonc` + `miku.txt` (ASCII logo).

- Logo is referenced as `~/.config/fastfetch/miku.txt` — **the config is useless without it**,
  so both are tracked in the dotfiles repo.
- Colour comes from `"color": {"1": "#E0B2D4"}`, applied where the logo contains `$1`.
  `miku.txt` currently has **no** `$1`, so it renders in the terminal default colour.
- Box borders use `[90m` inside `custom` module formats — that *is* interpreted.
  Do **not** put raw ANSI escapes in the logo file; fastfetch strips the ESC byte there
  and renders them literally.
- Calls `omarchy-version`, `omarchy-version-branch`, `omarchy-version-channel`,
  `omarchy-theme-current` — all still on PATH in 4.0.

System-wide default lives at `/etc/fastfetch/config.jsonc`; the user file overrides it.

---

## Dotfiles repo (`~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles`)

**PUBLIC repo** (github.com/bernixtersuper/Darkpuccin-Omarchy-Dotfiles). Treat everything
committed as world-readable.

Layout maps 1:1 to live: `.config/`, `.claude/`, `.local/`, `Music/`, `.bashrc`,
`.bash_profile`. Plus `etc/` → `/etc/`, `keyd/` → `/etc/keyd/`, `zen/` → the active Zen
profile, and `packages/` (generated manifests).

### Never commit

`~/.claude/.credentials.json` (live OAuth access + refresh token), `~/.claude.json`,
`.claude/history.jsonl` (verbatim prompts), Zen profile DBs, `/var/lib/iwd/*.8021x`.
Gitignored **and** blocked by an `is_secret()` guard in `sync.sh`.

### `sync.sh` — live → repo

Only touches files git already tracks; never adds new ones, never writes to live.

```bash
./sync.sh --dry-run     # show changes, write nothing
./sync.sh               # sync
./sync.sh --commit      # sync + auto-commit
VERBOSE=1 ./sync.sh     # itemise files missing on this machine
```

Regenerates `packages/*.txt` from pacman. Tracked files absent on the current machine are
reported and skipped — **never auto-untracked**, because for those the repo is the only
remaining copy.

To track something new: `git add <path>` once, then `sync.sh` maintains it.

### `install.sh` — repo → live

Installs **only tracked files** (not directory trees), so gitignored regenerated files
like `nvim/lua/plugins/theme.lua` and `btop/themes/` never travel. Prompts per section;
overwritten files back up to `~/.dotfiles-backup/<timestamp>/`.

```bash
./install.sh --dry-run                  # preview
./install.sh --new-machine              # skips monitors.lua automatically
./install.sh --skip <repo-relative-path>
```

`--new-machine` skips `HARDWARE_SPECIFIC` (currently just `.config/hypr/monitors.lua`) and,
if the target has no `monitors.lua`, drops in Omarchy's auto-detect default — otherwise
`hyprland.lua`'s `require("hypr.monitors")` would fail.

Sections that write outside `$HOME` (`keyd/`, `etc/`) prompt separately and use `sudo`, so
run it from a real terminal. `etc/` is ThinkPad E14 Gen 7-specific (rtw89, supergfxd,
power-profile/wifi-powersave udev rules) — opt in only on similar hardware.

Post-install: `source ~/.bashrc` → `hyprctl reload` → `hyprctl configerrors` →
`omarchy restart shell` → `omarchy theme set catppuccin-dark` → `claude` then `/login`.

---

## ITBA enterprise WiFi (iwd / 802.1X)

`ITBA` is **WPA2-Enterprise (PEAP/MSCHAPv2)**, not PSK. Impala and `iwctl connect` only
handle PSK — you must write the config by hand.

> ⚠️ **The old password leaked.** It was committed to the public dotfiles repo and, although
> history was rewritten, GitHub still served the orphaned blob. **Rotate it and never commit
> the replacement.** This file stores no password.

`/var/lib/iwd/ITBA.8021x` (filename must be `<SSID>.8021x`; device is `wlan0`):

```ini
[Security]
EAP-Method=PEAP
EAP-Identity=bortiz
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=bortiz
EAP-PEAP-Phase2-Password=<from password manager>

[Settings]
AutoConnect=true
```

iwd refuses world-readable secret files:

```bash
sudo install -o root -g root -m 600 ITBA.8021x /var/lib/iwd/ITBA.8021x
iwctl station wlan0 connect ITBA
```

If rejected: (1) append `@itba.edu.ar` to both identities; (2) add
`EAP-PEAP-ServerDomainMask=*` under `[Security]`. After editing, disconnect and reconnect
to force a re-read. `ITBA-Libre` is the open captive-portal fallback.

---

## What no longer exists

Do not go looking for these — Omarchy 4 replaced them.

| Gone | Now |
|------|-----|
| `hypr/*.conf` (bindings, monitors, input, looknfeel, autostart, workspaces, hyprland) | `hypr/*.lua` |
| `hypr/hypridle.conf`, `hypr/hyprlock.conf` | `shell.json` → `idle` |
| `hypr/scripts/` (all four scripts) | `set-monitor-transform.sh` → inline `set_transform()` in `bindings.lua`; resume-fix handled by Omarchy; dense-mode superseded by 0 gaps + `workspaces.lua`; edge-scroll toggle **lost** |
| Waybar (`~/.config/waybar/`) | Omarchy shell + `berni.*` plugins |
| Standalone Quickshell bar (`~/.config/quickshell/qbar/`) | same |
| Mako | Omarchy shell notifications |
| Walker + Elephant | Omarchy menu (Quickshell) |
| Swayosd | Omarchy OSD |
| gnome-calculator / qalculate | dropped upstream |
| nwg-displays | edit `monitors.lua` by hand |
| input-remapper | keyd |
| Satty | Tensaku |
| Per-theme `alacritty.toml`/`ghostty.conf`/`kitty.conf`/`mako.ini`/`waybar.css`/`walker.css`/`swayosd.css`/`starship.toml`/`chromium.theme`/`hyprland.conf`/`hyprlock.conf`/`looknfeel.conf` | generated from `colors.toml` |
| `~/.config/omarchy/current/` | `~/.local/state/omarchy/current/` |
| `~/.config/gtk-4.0/gtk.css` (Nautilus black) | gone; `SUPER SHIFT E` is Yazi now |
| Typora, cava, `omarchy.ttf` in `~/.local/share/fonts/` | uninstalled / now shipped by the package |

---

## Adding new customizations

1. **Keybinding** — check the tables above **and** `omarchy menu keybindings --print`.
   `hl.unbind()` first if the key is taken, then `o.bind()`. Update this file.
2. **Monitor change** — edit `monitors.lua` by hand and refresh the ASCII layout comment.
3. **Window rule** — `o.window(class, {...})` in `workspaces.lua` or `hyprland.lua`.
4. **Bar widget** — edit `shell.json`; clone a packaged plugin with
   `omarchy plugin clone omarchy.<id>` before modifying it.
5. **Hook** — `omarchy hook install <event> <script>`.
6. **keyd** — edit `/etc/keyd/<device>.conf`, `sudo keyd reload`, update this file.
7. **Theme colour** — edit the theme's `colors.toml`, re-apply the theme.
8. **New dotfile** — `git add <path>` once in the repo; `sync.sh` handles it after that.
9. **Package** — `omarchy pkg add <pkgs>`; rerun `sync.sh` to refresh `packages/`.

After any Hyprland edit: `hyprctl reload && hyprctl configerrors`.
