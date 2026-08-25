---
name: dotfiles-sync
description: >
  Manage Berni's Darkpuccin Omarchy Dotfiles repo. Use when syncing live configs
  back to the repo, installing dotfiles on a new machine, adding new config files
  to the repo, committing dotfile changes, or explaining the repo structure.
  Triggers: "sync my dotfiles", "commit my configs", "update the dotfiles repo",
  "add this config to my dotfiles", "install dotfiles", "push my config changes".
---

# Dotfiles Sync Skill

Manages Berni's personal Omarchy dotfiles repo.

**Repo:** `/home/berni/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles`
**Remote:** `https://github.com/bernixtersuper/Darkpuccin-Omarchy-Dotfiles`

## Repo Structure

The repo mirrors the home directory layout plus top-level theme dirs:

```
~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles/
├── .config/                  # mirrors ~/.config/
├── .local/                   # mirrors ~/.local/
│   └── share/
│       ├── fonts/            # CaskaydiaMono, Yu Mincho
│       └── omarchy/
│           ├── bin/          # omarchy bin patches (not yet upstream)
│           └── default/hypr/toggles/   # hyprland toggle configs
├── .bashrc
├── install.sh                # home <- repo  (apply on a new machine)
├── commit.sh                 # repo <- home  (save live changes back)
├── hatsune-miku/             # theme source (also in .config/omarchy/themes/)
├── catppuccin-dark/          # theme source
├── neon-blade-runner/        # theme source
└── README.md
```

## Key Scripts

### `install.sh` -- new machine setup
Syncs repo into `$HOME`. Prompts before each section (`.config/`, `.local/`, `.bashrc`).
Also makes omarchy bin scripts executable and rebuilds font cache.

```bash
cd ~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles
./install.sh
```

### `commit.sh` -- save live changes back to repo
Syncs `$HOME` back into the repo using `rsync --existing` (only updates already-tracked files,
safe against accidentally leaking new sensitive configs). Shows `git status`, then
prompts for a commit message.

```bash
cd ~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles
./commit.sh
```

## Common Tasks

### Sync live configs to repo and commit

```bash
cd ~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles && ./commit.sh
```

After committing, push:

```bash
git -C ~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles push
```

### Add a new config file to the repo

1. Identify the file path under `$HOME` (e.g. `~/.config/foo/bar.conf`)
2. Create the mirrored path in the repo: `.config/foo/bar.conf`
3. Copy the live file in: `cp ~/.config/foo/bar.conf ~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles/.config/foo/bar.conf`
4. Run `commit.sh` to commit it (it will be picked up by `rsync --existing` on future syncs)

### Add an omarchy bin patch (script not yet merged upstream)

Scripts go in `.local/share/omarchy/bin/` in the repo. The lua toggle config (if any) goes in
`.local/share/omarchy/default/hypr/toggles/`.

After adding, mark executable:

```bash
chmod +x ~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles/.local/share/omarchy/bin/<script-name>
```

`install.sh` will automatically mark all bin scripts executable when deploying.

### Apply dotfiles to a fresh machine

```bash
git clone https://github.com/bernixtersuper/Darkpuccin-Omarchy-Dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
# then apply a theme:
omarchy theme set "Catppuccin Dark"
```

### Check what would change before syncing

```bash
cd ~/Desktop/Dev/Darkpuccin-Omarchy-Dotfiles
rsync -a --existing --no-perms --dry-run "$HOME/.config/" .config/
rsync -a --existing --no-perms --dry-run "$HOME/.local/" .local/
```

## What Lives Where

| Config | Repo path | Live path |
|--------|-----------|-----------|
| Hyprland | `.config/hypr/` | `~/.config/hypr/` |
| Waybar | `.config/waybar/` | `~/.config/waybar/` |
| Ghostty | `.config/ghostty/config` | `~/.config/ghostty/config` |
| Neovim | `.config/nvim/` | `~/.config/nvim/` |
| Omarchy themes | `.config/omarchy/themes/` | `~/.config/omarchy/themes/` |
| uwsm env | `.config/uwsm/` | `~/.config/uwsm/` |
| Fonts | `.local/share/fonts/` | `~/.local/share/fonts/` |
| Omarchy bin patches | `.local/share/omarchy/bin/` | `~/.local/share/omarchy/bin/` |
| Hyprland toggles | `.local/share/omarchy/default/hypr/toggles/` | `~/.local/share/omarchy/default/hypr/toggles/` |
| bashrc | `.bashrc` | `~/.bashrc` |

## Theme Color Conventions

These themes use a consistent color role convention. When editing any theme file, follow this:

| Role | Value | Where it appears |
|------|-------|-----------------|
| **Regular text / foreground** | `#ffffff` | waybar.css `@define-color foreground`, walker.css `@define-color text` + `foreground`, ghostty.conf `foreground`, alacritty.toml `foreground` + `bright_foreground` + `bright.white`, kitty.conf `foreground` + `color15`, mako.ini `text-color`, swayosd.css label/image, starship.toml `text`, btop `main_fg` + `title` + `graph_text` |
| **Dimmed text** | dim variant (e.g. `#758494`) | `dim_foreground`, `inactive_tab_foreground`, btop `inactive_fg` |
| **Accent / primary** | theme accent (e.g. `#e8609a` for neon pink) | cursors, selections, borders, active tabs, highlights |
| **On-accent text** | `#000000` | `text = "#000000"` entries (text on colored cursor/selection backgrounds -- keeps contrast) |

**Key rule:** `#000000` entries in `[colors.cursor]`, `[colors.selection]`, `[colors.search.*]`, etc. are text drawn ON TOP of colored backgrounds for contrast -- do NOT change these to white.

### Waybar text color chain

```
~/.config/waybar/style.css
  └─ @import "../omarchy/current/theme/waybar.css"   <- sets @define-color foreground
  └─ @import "style/00-vars.css"                     <- aliases: @fg_main = @foreground
  └─ @import "style/10-base.css"                     <- window#waybar { color: @foreground }
```

All waybar item text inherits from `window#waybar { color: @foreground }` in `10-base.css`.
The value of `@foreground` comes from the active theme's `waybar.css`.

### Files to update when changing text color in a theme

All of these must be consistent:
- `waybar.css` -- `@define-color foreground`
- `walker.css` -- `@define-color text` and `@define-color foreground`
- `ghostty.conf` -- `foreground =`
- `alacritty.toml` -- `foreground =`, `bright_foreground =`, `[colors.bright] white =`
- `kitty.conf` -- `foreground`, `color15`
- `mako.ini` -- `text-color=`
- `swayosd.css` -- `@define-color label`, `@define-color image`
- `starship.toml` -- `text =`
- `btop.theme` -- `theme[main_fg]`, `theme[title]`, `theme[graph_text]`

After changing a theme, apply it live: `omarchy theme set "Theme Name"`

### Current theme text colors

| Theme | Foreground | Accent |
|-------|-----------|--------|
| Hatsune Miku | `#ffffff` | `#39c5bb` (teal) |
| Neon Blade Runner | `#ffffff` | `#e8609a` (hot pink) |
| Catppuccin Dark | `#cdd6f4` | Catppuccin Mocha palette |

## Omarchy Bin Patches (scripts pending upstream merge)

| Script | What it does |
|--------|-------------|
| `omarchy-hyprland-window-condensed-toggle` | Toggles condensed mode: no gaps, borders hidden on single-window workspaces |

The lua toggle for condensed mode is at `.local/share/omarchy/default/hypr/toggles/window-condensed.lua`.
Both files are installed to `~/.local/share/omarchy/` by `install.sh`.
