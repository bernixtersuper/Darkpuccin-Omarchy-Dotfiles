#!/bin/bash
# Syncs live dotfiles into this repo.
# Only touches files already tracked by git — never adds new ones, never touches live system.
# Usage: ./sync.sh [--commit]

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve a repo-relative path to its live system counterpart
live_path() {
  local rel="$1"
  case "$rel" in
    .config/*) echo "$HOME/$rel" ;;
    .claude/skills/*) echo "$HOME/$rel" ;;
    .local/bin/*) echo "$HOME/$rel" ;;
    Music/*) echo "$HOME/$rel" ;;
    .bashrc|.bash_profile) echo "$HOME/$rel" ;;
    etc/*) echo "/etc/${rel#etc/}" ;;
    keyd/*) echo "/etc/keyd/${rel#keyd/}" ;;
    *) echo "" ;;
  esac
}

# Regenerate generated manifests (not copied from a live path).
if command -v pacman >/dev/null 2>&1; then
  mkdir -p "$REPO/packages"
  pacman -Qqe > "$REPO/packages/pacman-explicit.txt"
  pacman -Qqm > "$REPO/packages/aur.txt"
fi

changed=0
missing=0

while IFS= read -r file; do
  src="$(live_path "$file")"
  [[ -z "$src" ]] && continue

  if [[ ! -e "$src" ]]; then
    echo "  MISSING on live: $src"
    missing=$((missing + 1))
    continue
  fi

  dst="$REPO/$file"

  if ! cmp -s "$src" "$dst" 2>/dev/null; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  synced: $file"
    changed=$((changed + 1))
  fi
done < <(cd "$REPO" && git ls-files)

echo ""
[[ $missing -gt 0 ]] && echo "  $missing file(s) missing on live system (skipped)"
[[ $changed -eq 0 ]] && echo "  Everything up to date." && exit 0
echo "  $changed file(s) updated."

if [[ "${1:-}" == "--commit" ]]; then
  cd "$REPO"
  git add -u
  git commit -m "sync: update dotfiles from live system"
fi
