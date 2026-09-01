#!/bin/bash
# Syncs live dotfiles into this repo.
# Only touches files already tracked by git — never adds new ones, never touches live system.
# Usage: ./sync.sh [--commit] [--dry-run]

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=0
COMMIT=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --commit)  COMMIT=1 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

# ---------------------------------------------------------------------------
# Secret guard
# ---------------------------------------------------------------------------
# THIS REPO IS PUBLIC. Never let a credential file get copied in, even if it
# somehow ends up tracked. This is a backstop for .gitignore, not a substitute.
is_secret() {
  case "$1" in
    *.credentials.json|.claude.json|.claude.json.backup) return 0 ;;
    */key4.db|*/logins.json|*/cookies.sqlite|*.pem|*.key|*_rsa|*_ed25519) return 0 ;;
    .claude/history.jsonl) return 0 ;;
    */ITBA.8021x|*.8021x) return 0 ;;
  esac
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

# Resolve a repo-relative path to its live system counterpart.
# Returns "" for repo-only files (README, install.sh, packages/, ...).
live_path() {
  local rel="$1"
  # Placeholders that exist only to keep a dir in git; no live counterpart.
  [[ "$(basename "$rel")" == ".gitkeep" ]] && { echo ""; return; }
  case "$rel" in
    .config/*)  echo "$HOME/$rel" ;;
    # All of ~/.claude, not just skills/ — settings.json, themes/, plugins/
    # config are tracked too. Credential files are blocked by is_secret().
    .claude/*)  echo "$HOME/$rel" ;;
    # Was .local/bin/* only, which silently skipped the tracked
    # .local/share/fonts and .local/share/qalculate files on every sync.
    .local/*)   echo "$HOME/$rel" ;;
    Music/*)    echo "$HOME/$rel" ;;
    .bashrc|.bash_profile) echo "$HOME/$rel" ;;
    etc/*)      echo "/etc/${rel#etc/}" ;;
    keyd/*)     echo "/etc/keyd/${rel#keyd/}" ;;
    zen/*)      local zp; zp="$(zen_profile_dir)" || { echo ""; return; }; echo "$zp/${rel#zen/}" ;;
    *) echo "" ;;
  esac
}

# Regenerate generated manifests (not copied from a live path).
if command -v pacman >/dev/null 2>&1; then
  mkdir -p "$REPO/packages"
  if [[ $DRY_RUN -eq 0 ]]; then
    pacman -Qqe > "$REPO/packages/pacman-explicit.txt"
    pacman -Qqm > "$REPO/packages/aur.txt"
  fi
  echo "  packages: $(pacman -Qqe | wc -l) explicit, $(pacman -Qqm | wc -l) AUR"
fi

changed=0
missing=0
blocked=0
missing_list=()

while IFS= read -r file; do
  if is_secret "$file"; then
    echo "  BLOCKED (secret, never synced): $file"
    blocked=$((blocked + 1))
    continue
  fi

  src="$(live_path "$file")"
  [[ -z "$src" ]] && continue

  if [[ ! -e "$src" ]]; then
    # Tracked in the repo but absent on this machine. Usually means the app was
    # removed or superseded (waybar -> Omarchy shell), but it can also just mean
    # this machine never had it. Never auto-untracked: for those files the repo
    # IS the only remaining copy.
    missing_list+=("$file")
    missing=$((missing + 1))
    continue
  fi

  dst="$REPO/$file"

  if ! cmp -s "$src" "$dst" 2>/dev/null; then
    if [[ $DRY_RUN -eq 0 ]]; then
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst"
    fi
    echo "  synced: $file"
    changed=$((changed + 1))
  fi
done < <(cd "$REPO" && git ls-files)

echo ""
[[ $blocked -gt 0 ]] && echo "  $blocked secret file(s) blocked"
if [[ $missing -gt 0 ]]; then
  echo "  $missing tracked file(s) not present on this machine (skipped, still in repo):"
  if [[ "${VERBOSE:-0}" == "1" ]]; then
    printf '      %s\n' "${missing_list[@]}"
  else
    printf '%s\n' "${missing_list[@]}" \
      | awk -F/ '{print ($1==".config"||$1==".local") ? $1"/"$2 : $1}' \
      | sort | uniq -c | sort -rn \
      | awk '{printf "      %-34s %s file(s)\n", $2, $1}'
    echo "      (VERBOSE=1 ./sync.sh to list them individually)"
  fi
fi
if [[ $changed -eq 0 ]]; then
  echo "  Everything up to date."
  exit 0
fi
if [[ $DRY_RUN -eq 1 ]]; then
  echo "  $changed file(s) WOULD be updated (dry run, nothing written)."
  exit 0
fi
echo "  $changed file(s) updated."

if [[ $COMMIT -eq 1 ]]; then
  cd "$REPO"
  git add -u
  git commit -m "sync: update dotfiles from live system"
fi
