#!/bin/bash
set -euo pipefail

# Zen browser profile holding the logged-in YouTube (Premium) session.
# Cookies from this profile unlock the high-bitrate audio and avoid throttling.
ZEN_PROFILE="$HOME/.zen/myxd9ao0.Default (release)"

# Playlist definitions: "cliamp-name|youtube-playlist-id|local-dir"
PLAYLISTS=(
  "1-勝つさ|PL94D6yDWeigA4AkHwqdiLXAsbyvVe2eUY|$HOME/Music/勝つさ"
  "2-zhongwen|PL94D6yDWeigCKMRwpkkdVEe2zeD8zAnqG|$HOME/Music/中文"
  "3-dj|PL94D6yDWeigCVfbkZ8fvdUD2GoTP9cuwp|$HOME/Music/dj"
)

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

  cliamp playlist delete "$name" 2>/dev/null || true
  cliamp playlist create "$name" "$dir"
  echo "✓ $name done"
done

echo ""
echo "All playlists updated."
