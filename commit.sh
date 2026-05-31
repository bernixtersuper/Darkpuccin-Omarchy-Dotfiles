#!/bin/bash

# Sync live configs from $HOME back into the dotfiles repo, then optionally commit.
# Only updates files already tracked in the repo (safe -- won't leak new sensitive files).

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Syncing $HOME -> $DOTFILES"
echo ""

rsync -a --existing --no-perms "$HOME/.config/" "$DOTFILES/.config/"
echo "  .config/ synced"

rsync -a --existing --no-perms "$HOME/.local/" "$DOTFILES/.local/"
echo "  .local/ synced"

if [[ -f "$HOME/.bashrc" ]]; then
  cp "$HOME/.bashrc" "$DOTFILES/.bashrc"
  echo "  .bashrc synced"
fi

echo ""
git -C "$DOTFILES" status --short
echo ""

read -r -p "Commit message (empty to skip): " msg
if [[ -n "$msg" ]]; then
  git -C "$DOTFILES" add -A
  git -C "$DOTFILES" commit -m "$msg"
  echo "Done."
fi
