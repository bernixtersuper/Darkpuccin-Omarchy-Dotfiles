#!/bin/bash

# Installs Berni's Omarchy dotfiles to the current user's home directory.
# Requires Omarchy (https://omarchy.org) to be installed first.

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

confirm() {
  read -r -p "$1 [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

echo "Dotfiles: $DOTFILES"
echo "Target:   $HOME"
echo ""

# .config
if confirm "Copy .config/ to ~/.config/?"; then
  rsync -a --no-perms "$DOTFILES/.config/" "$HOME/.config/"
  echo "  -> .config/ synced"
fi

# .local (includes omarchy bin patches and fonts)
if confirm "Copy .local/ to ~/.local/?"; then
  rsync -a --no-perms "$DOTFILES/.local/" "$HOME/.local/"
  chmod +x "$HOME/.local/share/omarchy/bin/"* 2>/dev/null || true
  echo "  -> .local/ synced"
  echo "  -> omarchy bin scripts marked executable"
fi

# .bashrc
if confirm "Copy .bashrc to ~/.bashrc?"; then
  cp "$DOTFILES/.bashrc" "$HOME/.bashrc"
  echo "  -> .bashrc copied"
fi

# Font cache
if command -v fc-cache &>/dev/null; then
  fc-cache -f
  echo "  -> font cache rebuilt"
fi

echo ""
echo "Done. Open a new terminal or run: source ~/.bashrc"
echo "To apply a theme: omarchy theme set \"Catppuccin Dark\""
