#!/bin/bash

# Installs Berni's Omarchy dotfiles to the current user's home directory.
# Requires Omarchy (https://omarchy.org) to be installed first.
#
# Usage: ./install.sh [--dry-run] [--skip <path> ...]
#   --dry-run        Show what would change without writing anything.
#   --skip <path>    Skip a repo-relative path. Can be repeated.
#                    e.g. --skip .config/hypr/monitors.conf
#
# Existing files that would be overwritten are backed up to ~/.dotfiles-backup/

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
SKIPS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --skip) shift; SKIPS+=("$1") ;;
    *) echo "Unknown flag: $1"; exit 1 ;;
  esac
  shift
done

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

rsync_install() {
  local src="$1" dst="$2" prefix="$3"
  local excludes
  mapfile -t excludes < <(exclude_flags "$prefix")
  if $DRY_RUN; then
    rsync -a --no-perms --dry-run --itemize-changes "${excludes[@]}" "$src" "$dst" | grep '^>' || echo "  (no changes)"
  else
    rsync -a --no-perms --backup --backup-dir="$BACKUP_DIR" "${excludes[@]}" "$src" "$dst"
  fi
}

skipped_file() {
  local path="$1"
  for skip in "${SKIPS[@]}"; do
    [[ "$skip" == "$path" ]] && return 0
  done
  return 1
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

# .local (fonts: omarchy.ttf, yumin.ttf; qalculate exchange rate data)
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

# .claude/skills (personal Claude Code skills)
if [[ -d "$DOTFILES/.claude/skills" ]] && confirm "Copy .claude/skills/ to ~/.claude/skills/?"; then
  mkdir -p "$HOME/.claude/skills"
  rsync_install "$DOTFILES/.claude/skills/" "$HOME/.claude/skills/" ".claude/skills/"
  $DRY_RUN || echo "  -> .claude/skills/ synced"
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

if ! $DRY_RUN; then
  if command -v fc-cache &>/dev/null; then
    fc-cache -f
    echo "  -> font cache rebuilt"
  fi

  echo ""
  echo "Done. Open a new terminal or run: source ~/.bashrc"
  echo "To apply a theme: omarchy theme set \"Catppuccin Dark\""
  [[ -d "$BACKUP_DIR" ]] && echo "Overwritten files backed up to: $BACKUP_DIR"
fi
