#!/bin/bash

# Installs Berni's Omarchy dotfiles to the current user's home directory.
# Requires Omarchy (https://omarchy.org) to be installed first.
#
# Usage: ./install.sh [--dry-run] [--new-machine] [--skip <path> ...]
#   --dry-run        Show what would change without writing anything.
#   --new-machine    Installing onto a DIFFERENT machine: auto-skips the configs
#                    that hardcode this laptop's hardware (currently just
#                    hypr/monitors.lua). Write a fresh monitors.lua afterwards.
#   --skip <path>    Skip a repo-relative path. Can be repeated.
#                    e.g. --skip .config/hypr/monitors.lua
#
# Existing files that would be overwritten are backed up to ~/.dotfiles-backup/
#
# Sections that write outside $HOME (etc/, keyd/) prompt separately and use
# sudo. Run this from a real terminal so sudo can ask for your password.

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
NEW_MACHINE=false
SKIPS=()

# Configs that hardcode this specific laptop's hardware. --new-machine skips
# these; everything else in the repo is portable between Omarchy boxes.
HARDWARE_SPECIFIC=(".config/hypr/monitors.lua")

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --new-machine) NEW_MACHINE=true ;;
    --skip) shift; SKIPS+=("$1") ;;
    *) echo "Unknown flag: $1"; exit 1 ;;
  esac
  shift
done

if $NEW_MACHINE; then
  SKIPS+=("${HARDWARE_SPECIFIC[@]}")
fi

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

confirm() {
  $DRY_RUN && { echo "$1 [dry-run, skipping prompt]"; return 0; }
  read -r -p "$1 [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

# Build rsync --exclude flags for paths under a given prefix (e.g. ".config/")
# Strips the prefix so the exclude is relative to the rsync source dir.
exclude_flags() {
  local prefix="$1"
  for skip in "${SKIPS[@]}"; do
    if [[ "$skip" == "$prefix"* ]]; then
      echo "--exclude=${skip#$prefix}"
    elif [[ "$skip" == "${prefix%/}" ]]; then
      echo "--exclude=."
    fi
  done
}

# Install ONLY files git tracks, never whole directory trees.
#
# The repo working tree also contains gitignored files -- omarchy regenerates
# .config/nvim/lua/plugins/theme.lua and .config/btop/themes/ on every theme
# switch, plus fcitx5 caches, mozc state and .local/share/omarchy/. Those are
# ignored precisely because they must not travel to another machine, and an
# rsync of the directory would have carried them along.

# Emit tracked files under $1, relative to it, NUL-delimited.
# NOTE: this must be piped straight into rsync -- a bash variable cannot hold
# NUL bytes, so capturing it with $(...) would splice every path into one.
tracked_rel() {
  local prefix="$1"
  (cd "$DOTFILES" && git ls-files -z -- "$prefix") \
    | while IFS= read -r -d '' f; do
        local rel="${f#"$prefix"}"
        [[ "$(basename "$rel")" == ".gitkeep" ]] && continue
        printf '%s\0' "$rel"
      done
}

rsync_install() {
  local src="$1" dst="$2" prefix="$3"
  local excludes
  mapfile -t excludes < <(exclude_flags "$prefix")

  if [[ -z "$(tracked_rel "$prefix" | tr -d '\0')" ]]; then
    echo "  (nothing tracked under $prefix)"
    return 0
  fi

  if $DRY_RUN; then
    tracked_rel "$prefix" | rsync -a --no-perms --dry-run --itemize-changes \
      --from0 --files-from=- "${excludes[@]}" "$src" "$dst" | grep '^>' || echo "  (no changes)"
  else
    tracked_rel "$prefix" | rsync -a --no-perms --backup --backup-dir="$BACKUP_DIR" \
      --from0 --files-from=- "${excludes[@]}" "$src" "$dst"
  fi
}

skipped_file() {
  local path="$1"
  for skip in "${SKIPS[@]}"; do
    [[ "$skip" == "$path" ]] && return 0
  done
  return 1
}

# Resolve the active Zen profile directory. The dir name has a random prefix
# generated at install time, so it differs per machine and cannot be hardcoded.
# installs.ini records which profile the browser actually opens; profiles.ini's
# Default=1 can point elsewhere, so prefer installs.ini.
zen_profile_dir() {
  local base="$HOME/.config/zen" name=""
  [[ -d "$base" ]] || return 1
  if [[ -f "$base/installs.ini" ]]; then
    name="$(sed -n 's/^Default=//p' "$base/installs.ini" | head -1)"
  fi
  if [[ -z "$name" && -f "$base/profiles.ini" ]]; then
    name="$(awk -F= '/^Path=/{p=$2} /^Default=1/{print p; exit}' "$base/profiles.ini")"
  fi
  if [[ -z "$name" && -f "$base/profiles.ini" ]]; then
    name="$(sed -n 's/^Path=//p' "$base/profiles.ini" | head -1)"
  fi
  [[ -n "$name" && -d "$base/$name" ]] || return 1
  echo "$base/$name"
}

$DRY_RUN && echo "[DRY RUN — nothing will be written]" && echo ""
[[ ${#SKIPS[@]} -gt 0 ]] && echo "Skipping: ${SKIPS[*]}" && echo ""

echo "Dotfiles: $DOTFILES"
echo "Target:   $HOME"
$DRY_RUN || echo "Backups:  $BACKUP_DIR"
echo ""

# .config
if confirm "Copy .config/ to ~/.config/?"; then
  rsync_install "$DOTFILES/.config/" "$HOME/.config/" ".config/"
  $DRY_RUN || echo "  -> .config/ synced"
fi

# hyprland.lua does `require("hypr.monitors")`, so that file has to exist even
# when --new-machine skipped ours. A stock Omarchy install already ships one
# (generic preferred/auto), but if it is missing for any reason, drop the
# packaged default in rather than leaving Hyprland with a broken require.
if $NEW_MACHINE && ! $DRY_RUN; then
  if [[ ! -f "$HOME/.config/hypr/monitors.lua" ]]; then
    default_monitors="${OMARCHY_PATH:-/usr/share/omarchy}/config/hypr/monitors.lua"
    if [[ -f "$default_monitors" ]]; then
      mkdir -p "$HOME/.config/hypr"
      cp "$default_monitors" "$HOME/.config/hypr/monitors.lua"
      echo "  -> monitors.lua: installed Omarchy's auto-detect default (yours was skipped)"
    else
      echo "  WARNING: no ~/.config/hypr/monitors.lua and no packaged default;"
      echo "           hyprland.lua will fail on require(\"hypr.monitors\")."
    fi
  else
    echo "  -> monitors.lua: kept the one already on this machine (yours was skipped)"
  fi
fi

# .local (fonts: yumin.ttf; personal scripts in .local/bin)
if confirm "Copy .local/ to ~/.local/?"; then
  rsync_install "$DOTFILES/.local/" "$HOME/.local/" ".local/"
  $DRY_RUN || echo "  -> .local/ synced"
fi

# .bashrc
if skipped_file ".bashrc"; then
  echo "  skipped: .bashrc"
elif confirm "Copy .bashrc to ~/.bashrc?"; then
  if $DRY_RUN; then
    diff "$DOTFILES/.bashrc" "$HOME/.bashrc" 2>/dev/null && echo "  (no changes)" || true
  else
    cp --backup=simple --suffix=".bak-$(date +%Y%m%d)" "$DOTFILES/.bashrc" "$HOME/.bashrc"
    echo "  -> .bashrc copied"
  fi
fi

# .bash_profile
if skipped_file ".bash_profile"; then
  echo "  skipped: .bash_profile"
elif [[ -f "$DOTFILES/.bash_profile" ]] && confirm "Copy .bash_profile to ~/.bash_profile?"; then
  if $DRY_RUN; then
    echo "  would copy .bash_profile"
  else
    cp --backup=simple --suffix=".bak-$(date +%Y%m%d)" "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
    echo "  -> .bash_profile copied"
  fi
fi

# .claude (personal skills, settings, theme, plugin registry)
#
# NOTE: this deliberately never carries credentials. ~/.claude/.credentials.json
# holds a live OAuth access + refresh token and is gitignored, so it is not in
# this repo to copy. After installing, authenticate on the new machine with:
#   claude   (then /login)
if [[ -d "$DOTFILES/.claude" ]] && confirm "Copy .claude/ to ~/.claude/ (skills, settings, theme)?"; then
  mkdir -p "$HOME/.claude"
  rsync_install "$DOTFILES/.claude/" "$HOME/.claude/" ".claude/"
  $DRY_RUN || echo "  -> .claude/ synced (log in separately with: claude /login)"
fi

# Zen browser profile config (user.js, mods, shortcuts, containers, chrome/)
if [[ -d "$DOTFILES/zen" ]] && confirm "Copy zen/ into the active Zen profile?"; then
  if ZEN_PROFILE="$(zen_profile_dir)"; then
    echo "  profile: $ZEN_PROFILE"
    rsync_install "$DOTFILES/zen/" "$ZEN_PROFILE/" "zen/"
    $DRY_RUN || echo "  -> zen/ synced (restart Zen to apply user.js)"
  else
    echo "  SKIPPED: no Zen profile found. Launch Zen once to create one, then rerun."
  fi
fi

# Music playlist updater script
if [[ -f "$DOTFILES/Music/update-playlists.sh" ]] && confirm "Copy Music/update-playlists.sh to ~/Music/?"; then
  if $DRY_RUN; then
    echo "  would copy Music/update-playlists.sh -> $HOME/Music/"
  else
    mkdir -p "$HOME/Music"
    cp --backup=simple --suffix=".bak-$(date +%Y%m%d)" \
      "$DOTFILES/Music/update-playlists.sh" "$HOME/Music/update-playlists.sh"
    chmod +x "$HOME/Music/update-playlists.sh"
    echo "  -> Music/update-playlists.sh copied"
  fi
fi

# ---------------------------------------------------------------------------
# keyd (/etc/keyd) — needs root
# ---------------------------------------------------------------------------
# keyd intercepts input before Hyprland sees it, so this is what provides the
# CapsLock nav layer. Without it, Caps+HJKL does nothing.
#   keyboard.conf  CapsLock-as-nav layer, applied to all keyboards via `*`
#   thinkpad.conf  ThinkPad media buttons (17aa:5054) — harmless elsewhere,
#                  the device id simply never matches
#   mouse.conf     X3-5.4 mouse side buttons
if [[ -d "$DOTFILES/keyd" ]] && confirm "Install keyd configs to /etc/keyd/ (needs sudo)?"; then
  if $DRY_RUN; then
    for f in "$DOTFILES"/keyd/*.conf; do echo "  would install $(basename "$f") -> /etc/keyd/"; done
  elif ! command -v keyd &>/dev/null; then
    echo "  SKIPPED: keyd is not installed. Run: omarchy pkg add keyd"
  else
    sudo mkdir -p /etc/keyd
    for f in "$DOTFILES"/keyd/*.conf; do
      sudo install -o root -g root -m 644 "$f" "/etc/keyd/$(basename "$f")"
      echo "  -> /etc/keyd/$(basename "$f")"
    done
    sudo systemctl enable --now keyd 2>/dev/null || true
    sudo keyd reload && echo "  -> keyd reloaded"
  fi
fi

# ---------------------------------------------------------------------------
# etc/ — hardware tweaks, needs root
# ---------------------------------------------------------------------------
# These are tuned for a ThinkPad E14 Gen 7: rtw89 wifi, supergfxd, power-profile
# and wifi-powersave udev rules, usb autosuspend. On different hardware they are
# usually harmless but pointless — and a wrong modprobe option can keep a driver
# from loading, so this is opt-in and separate from everything else.
if [[ -d "$DOTFILES/etc" ]] && confirm "Install etc/ hardware tweaks to /etc/ (needs sudo; ThinkPad-specific)?"; then
  if $DRY_RUN; then
    (cd "$DOTFILES/etc" && find . -type f | sed 's|^\./|  would install -> /etc/|')
  else
    (cd "$DOTFILES/etc" && find . -type f -printf '%P\n') | while read -r rel; do
      sudo install -D -o root -g root -m 644 "$DOTFILES/etc/$rel" "/etc/$rel"
      echo "  -> /etc/$rel"
    done
    sudo udevadm control --reload-rules 2>/dev/null || true
    echo "  -> udev rules reloaded (modprobe/sysctl changes need a reboot)"
  fi
fi

# ---------------------------------------------------------------------------
# Packages
# ---------------------------------------------------------------------------
# pacman-explicit.txt is every explicitly-installed package; aur.txt is the AUR
# subset. --needed means already-installed packages are left alone. Omarchy's
# own packages are in this list too, so on a fresh Omarchy box most of it is
# already satisfied and this just fills in the extras.
if [[ -f "$DOTFILES/packages/pacman-explicit.txt" ]] && confirm "Install packages from packages/ (needs sudo + AUR helper)?"; then
  if $DRY_RUN; then
    echo "  would install $(wc -l < "$DOTFILES/packages/pacman-explicit.txt") explicit packages"
    echo "  ($(wc -l < "$DOTFILES/packages/aur.txt") of them from the AUR)"
  else
    # Repo packages first, then AUR — yay handles both but is slower, so only
    # hand it what pacman could not resolve.
    sudo pacman -S --needed --noconfirm - < "$DOTFILES/packages/pacman-explicit.txt" 2>/dev/null || \
      echo "  some packages are not in the repos; trying the AUR helper for the rest"
    if command -v yay &>/dev/null; then
      yay -S --needed --noconfirm - < "$DOTFILES/packages/aur.txt" || true
    else
      echo "  no yay found; install AUR packages manually from packages/aur.txt"
    fi
    echo "  -> packages installed"
  fi
fi

if ! $DRY_RUN; then
  if command -v fc-cache &>/dev/null; then
    fc-cache -f
    echo "  -> font cache rebuilt"
  fi

  echo ""
  echo "──────────────────────────────────────────────────────────────"
  echo "Done. Next steps:"
  echo ""
  echo "  1. Reload the shell:      source ~/.bashrc"
  echo "  2. Reload Hyprland:       hyprctl reload"
  echo "     then check for errors: hyprctl configerrors"
  echo "  3. Restart the bar:       omarchy restart shell"
  echo "  4. Apply a theme:         omarchy theme set catppuccin-dark"
  echo "  5. Log Claude Code in:    claude   then /login"
  echo "     (credentials are deliberately not in this repo)"
  echo "  6. Re-point the gh credential helper:  gh auth login && gh auth setup-git"
  echo "     .config/git/config hardcodes this machine's mise gh path, which"
  echo "     will not exist on the new box; git push fails until you rerun it."
  if $NEW_MACHINE; then
    echo ""
    echo "  7. WRITE A NEW MONITORS CONFIG — it was skipped on purpose:"
    echo "       hyprctl monitors all        # see what this machine has"
    echo "       \$EDITOR ~/.config/hypr/monitors.lua"
    echo "     Until you do, Hyprland falls back to the generic"
    echo "     preferred/auto rule, which works but ignores scale/position."
  fi
  echo ""
  [[ -d "$BACKUP_DIR" ]] && echo "Overwritten files backed up to: $BACKUP_DIR"
fi
