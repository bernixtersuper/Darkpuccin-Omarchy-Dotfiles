# Darkpuccin Omarchy Dotfiles

Personal dotfiles for [Omarchy](https://omarchy.org/) — an opinionated Arch Linux setup built on Hyprland.

Includes custom themes, hyprland config, waybar, walker, and more.

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

The install script syncs `.config/` (includes all themes), `.local/` (fonts, qalculate data), and `.bashrc` to your home directory, then rebuilds the font cache. Each section prompts before copying so you can skip what you don't need.

After installing, apply a theme:

```bash
omarchy theme set "Catppuccin Dark"
```

---

## Scripts

### Condensed Mode (`omarchy-hyprland-window-condensed-toggle`)

Toggles a compact window layout: removes all gaps and hides borders on single-window workspaces. Useful for focused work or small screens.

This is a [pending PR](https://github.com/basecamp/omarchy/pulls) not yet merged into official Omarchy. The install script patches it in automatically.

**Toggle via keybind** — add to `~/.config/hypr/bindings.conf`:

```
bind = $mod, C, exec, omarchy-hyprland-window-condensed-toggle
```

Or run directly:

```bash
omarchy-hyprland-window-condensed-toggle
```

---

## System

- **OS:** Arch Linux via Omarchy
- **WM:** Hyprland (Wayland)
- **Bar:** Waybar
- **Launcher:** Walker
- **Terminal:** Ghostty
- **Font:** CaskaydiaMono Nerd Font
