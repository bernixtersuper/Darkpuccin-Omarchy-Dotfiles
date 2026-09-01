#!/bin/bash
set -uo pipefail

# Browser profile holding the logged-in YouTube (Premium) session.
# Cookies from this profile unlock the high-bitrate audio and avoid throttling.
# Zen is Firefox-based, so yt-dlp reads it with the "firefox:<path>" backend.
find_zen_profile() {
  local root ini path
  for root in "$HOME/.config/zen" "$HOME/.zen" "$HOME/.var/app/app.zen_browser.zen/.zen"; do
    ini="$root/profiles.ini"
    [[ -f "$ini" ]] || continue

    # Prefer the profile the [InstallXXXX] section marks as default.
    path=$(awk -F= '/^\[Install/{ok=1;next} /^\[/{ok=0} ok && $1=="Default"{print $2;exit}' "$ini")
    if [[ -n "$path" && -f "$root/$path/cookies.sqlite" ]]; then
      echo "$root/$path"
      return 0
    fi

    # Otherwise take any profile that actually has a cookie database.
    while IFS= read -r path; do
      [[ -f "$root/$path/cookies.sqlite" ]] && { echo "$root/$path"; return 0; }
    done < <(awk -F= '$1=="Path"{print $2}' "$ini")
  done
  return 1
}

if ! ZEN_PROFILE=$(find_zen_profile); then
  echo "✗ could not locate a Zen profile with cookies.sqlite" >&2
  echo "  looked in ~/.config/zen, ~/.zen and the flatpak path" >&2
  exit 1
fi
echo "Using browser profile: $ZEN_PROFILE"

# Playlist definitions: "cliamp-name|youtube-playlist-id|local-dir"
PLAYLISTS=(
  "1-勝つさ|PL94D6yDWeigA4AkHwqdiLXAsbyvVe2eUY|$HOME/Music/勝つさ"
  "2-zhongwen|PL94D6yDWeigCKMRwpkkdVEe2zeD8zAnqG|$HOME/Music/中文"
  "3-dj|PL94D6yDWeigCVfbkZ8fvdUD2GoTP9cuwp|$HOME/Music/dj"
)

failed=0

for entry in "${PLAYLISTS[@]}"; do
  name="${entry%%|*}"
  rest="${entry#*|}"
  playlist_id="${rest%%|*}"
  dir="${rest#*|}"

  echo ""
  echo "▶ Updating: $name"
  mkdir -p "$dir"

  yt-dlp \
    -x \
    --audio-format mp3 \
    --audio-quality 0 \
    --cookies-from-browser "firefox:$ZEN_PROFILE" \
    --ignore-errors \
    --download-archive "$dir/archive.txt" \
    -o "$dir/%(title)s [%(id)s].%(ext)s" \
    "https://music.youtube.com/playlist?list=$playlist_id" || true

  # cliamp refuses to create an empty playlist, and that must not abort the run.
  if ! compgen -G "$dir/*.mp3" >/dev/null; then
    echo "⚠ $name skipped: no audio files in $dir"
    failed=1
    continue
  fi

  cliamp playlist delete "$name" 2>/dev/null || true
  if cliamp playlist create "$name" "$dir"; then
    echo "✓ $name done"
  else
    echo "⚠ $name: cliamp failed to create the playlist"
    failed=1
  fi
done

echo ""
if (( failed )); then
  echo "Finished with warnings."
  exit 1
fi
echo "All playlists updated."
