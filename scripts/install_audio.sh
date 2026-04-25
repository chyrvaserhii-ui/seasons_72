#!/usr/bin/env bash
#
# install_audio.sh — convert four downloaded ambient MP3s into m4a
# loops in `assets/audio/`, ready for the iOS widget to play.
#
# Usage:
#   ./scripts/install_audio.sh \
#       ~/Downloads/spring.mp3 \
#       ~/Downloads/summer.mp3 \
#       ~/Downloads/autumn.mp3 \
#       ~/Downloads/winter.mp3
#
# Or interactive — call with no args, the script will prompt for each.

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/assets/audio"
mkdir -p "$OUT"

# Verify ffmpeg is available
if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "✗ ffmpeg not installed. Run: brew install ffmpeg"
  exit 1
fi

convert() {
  local src="$1"
  local target="$2"
  local out="$OUT/$target.m4a"

  if [[ ! -f "$src" ]]; then
    echo "  ! $src not found — skipping $target"
    return
  fi

  echo "→ $target ← $src"
  # mono, AAC 96kbps, trim to 25s, fade out last 0.5s for clean loop
  ffmpeg -y -loglevel error \
    -i "$src" \
    -ac 1 -b:a 96k \
    -t 25 \
    -af "afade=out:st=24.5:d=0.5" \
    "$out"
  echo "  ✓ $(du -h "$out" | cut -f1) — $out"
}

if [[ $# -eq 4 ]]; then
  convert "$1" spring
  convert "$2" summer
  convert "$3" autumn
  convert "$4" winter
else
  for season in spring summer autumn winter; do
    read -r -p "Path to ${season}.mp3 (or empty to skip): " path
    [[ -n "$path" ]] && convert "$path" "$season"
  done
fi

echo
echo "Done. Now:"
echo "  flutter pub get"
echo "  flutter run --release -d \"SC (2)\""
