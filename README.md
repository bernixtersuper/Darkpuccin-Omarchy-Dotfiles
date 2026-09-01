# Darkpuccin Omarchy Dotfiles

Personal dotfiles for [Omarchy](https://omarchy.org/) — an opinionated Arch Linux setup built on Hyprland.

Includes custom themes, Hyprland config (Lua), Omarchy shell (Quickshell) bar plugins, and more.

Targets **Omarchy 4.x**. Hyprland is configured in Lua (`hypr/*.lua`); the bar and
notifications are the Omarchy shell, not Waybar.

---

## Themes

### Hatsune Miku
Teal and cyan aesthetic inspired by the virtual idol herself.

![Hatsune Miku preview](.config/omarchy/themes/hatsune-miku/preview.png)

**Install:**
```bash
omarchy theme set "Hatsune Miku"
```

---

### Neon Blade Runner
Hot pink and magenta neon vibes. Dark cyberpunk atmosphere.

![Neon Blade Runner preview](.config/omarchy/themes/neon-blade-runner/preview.png)

**Install:**
```bash
omarchy theme set "Neon Blade Runner"
```

---

### Catppuccin Dark
Deep purple Catppuccin Mocha palette with a darker twist.

![Catppuccin Dark preview](.config/omarchy/themes/catppuccin-dark/preview.png)

**Install:**
```bash
omarchy theme set "Catppuccin Dark"
```

---

### Golden Exposure
Warm amber and gold tones. Film photography aesthetic.

![Golden Exposure preview](.config/omarchy/themes/golden-exposure/preview.png)

**Install:**
```bash
omarchy theme set "golden-exposure"
```

---

## Setup

Requires [Omarchy](https://omarchy.org/) to be installed first.

```bash
git clone https://github.com/bernixtersuper/Darkpuccin-Omarchy-Dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script syncs `.config/` (includes all themes and the Omarchy shell plugins),
`.local/` (fonts, personal scripts), `.claude/` (skills, settings) and `.bashrc` to your home
directory, then rebuilds the font cache. Each section prompts before copying so you can skip
what you don't need.

**Claude Code credentials are deliberately not in this repo.** `~/.claude/.credentials.json`
holds a live OAuth token, so it is gitignored. After installing, run `claude` and `/login`.

After installing, apply a theme:

```bash
omarchy theme set "Catppuccin Dark"
```

### Copying to a different machine

Some configs are hardware-specific and should be skipped when installing on a new PC. Use `--skip` to exclude them:

```bash
./install.sh --skip .config/hypr/monitors.lua
```

Then write a fresh `~/.config/hypr/monitors.lua` for the PC's actual monitors. Run with `--dry-run` first to preview what would change.

Files skipped above and why:
- `monitors.lua` — hardcodes monitor names, resolutions, scales and positions

**keyd** also needs manual setup on the new machine. Configs are in `keyd/` in this repo but live in `/etc/keyd/` and require sudo to install:

```bash
sudo cp keyd/keyboard.conf /etc/keyd/keyboard.conf
sudo keyd reload
# ThinkPad only:
sudo cp keyd/thinkpad.conf /etc/keyd/thinkpad.conf
sudo keyd reload
```

- `keyboard.conf` — CapsLock-as-nav-modifier layer (Caps+HJKL = arrows, Caps+;/' = PgUp/PgDn, etc.)
- `thinkpad.conf` — ThinkPad media button remapping (`17aa:5054`)

**Zen browser** config is in `zen/` in this repo and installs into the active Zen profile
(`~/.config/zen/<random>.Default (release)/`). The profile dir name is random per machine, so
`install.sh` resolves it at runtime — just launch Zen once first to create a profile, then:

```bash
./install.sh   # answer y at "Copy zen/ into the active Zen profile?"
```

Restart Zen afterwards so `user.js` is picked up.

The live profile is gitignored — it holds passwords, cookies and keys. Only these travel:
`user.js` (about:config prefs), `zen-themes.json` (Zen Mods), `zen-keyboard-shortcuts.json`,
`containers.json`, `search.json.mozlz4`, and `chrome/` for hand-written CSS.

Bookmarks, extensions, passwords and open tabs are **not** in this repo. Sign into Zen Sync for those.

---

## Screen rotation

Rotating a monitor with a bare `hyprctl keyword monitor` resets its position and scale.
`hypr/bindings.lua` defines a `set_transform()` helper that reads the monitor's current
geometry via `hl.get_monitor()` and re-applies it alongside the new transform, so position
and scale survive.

| Key | Action |
|-----|--------|
| `SUPER [` | Normal (transform 0) |
| `SUPER ]` | Flipped 180 (transform 2) |
| `SUPER SHIFT [` | Rotate left 90 (transform 1) |
| `SUPER SHIFT ]` | Rotate right 90 (transform 3) |

This replaces the pre-4.0 `scripts/set-monitor-transform.sh` and
`scripts/fix-monitors-on-resume.sh`, which are gone — Omarchy 4 restores monitor
state on resume itself.

---

## Syncing

`sync.sh` copies live files back into this repo. It only touches files already tracked
by git, never adds new ones, and never writes to the live system.

```bash
./sync.sh --dry-run   # show what would change, write nothing
./sync.sh             # sync
./sync.sh --commit    # sync and auto-commit
VERBOSE=1 ./sync.sh   # list every tracked file missing on this machine
```

Credential files are blocked by an explicit guard in `sync.sh` even if they somehow
become tracked. Tracked files that are absent on the current machine are reported and
skipped, never auto-untracked — for those, the repo is the only remaining copy.

---

## System

- **OS:** Arch Linux via Omarchy
- **WM:** Hyprland (Wayland)
- **Bar:** Omarchy shell (Quickshell) — custom `berni.*` plugins
- **Launcher:** Omarchy menu (Quickshell)
- **Terminal:** Ghostty
- **Font:** CaskaydiaMono Nerd Font
