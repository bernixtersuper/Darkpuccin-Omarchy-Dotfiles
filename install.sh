#!/bin/bash

# Installs Berni's Omarchy dotfiles to the current user's home directory.
# Requires Omarchy (https://omarchy.org) to be installed first.
#
# Usage: ./install.sh [--dry-run]
#   --dry-run   Show what would change without writing anything.
#
# Existing files that would be overwritten are backed up to ~/.dotfiles-backup/

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

confirm() {
  $DRY_RUN && { echo "$1 [dry-run, skipping prompt]"; return 0; }
  read -r -p "$1 [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

rsync_install() {
  local src="$1" dst="$2"
  if $DRY_RUN; then
    rsync -a --no-perms --dry-run --itemize-changes "$src" "$dst" | grep '^>' || echo "  (no changes)"
  else
    rsync -a --no-perms --backup --backup-dir="$BACKUP_DIR" "$src" "$dst"
  fi
}

$DRY_RUN && echo "[DRY RUN — nothing will be written]" && echo ""

echo "Dotfiles: $DOTFILES"
echo "Target:   $HOME"
$DRY_RUN || echo "Backups:  $BACKUP_DIR"
echo ""

# .config
if confirm "Copy .config/ to ~/.config/?"; then
  rsync_install "$DOTFILES/.config/" "$HOME/.config/"
  $DRY_RUN || echo "  -> .config/ synced"
fi

# .local (fonts: omarchy.ttf, yumin.ttf; qalculate exchange rate data)
if confirm "Copy .local/ to ~/.local/?"; then
  rsync_install "$DOTFILES/.local/" "$HOME/.local/"
  $DRY_RUN || echo "  -> .local/ synced"
fi

# .bashrc
if confirm "Copy .bashrc to ~/.bashrc?"; then
  if $DRY_RUN; then
    diff "$DOTFILES/.bashrc" "$HOME/.bashrc" 2>/dev/null && echo "  (no changes)" || true
  else
    cp --backup=simple --suffix=".bak-$(date +%Y%m%d)" "$DOTFILES/.bashrc" "$HOME/.bashrc"
    echo "  -> .bashrc copied"
  fi
fi

if ! $DRY_RUN; then
  # Font cache
  if command -v fc-cache &>/dev/null; then
    fc-cache -f
    echo "  -> font cache rebuilt"
  fi

  echo ""
  echo "Done. Open a new terminal or run: source ~/.bashrc"
  echo "To apply a theme: omarchy theme set \"Catppuccin Dark\""
  [[ -d "$BACKUP_DIR" ]] && echo "Overwritten files backed up to: $BACKUP_DIR"
fi
