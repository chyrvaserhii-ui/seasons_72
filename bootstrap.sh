#!/usr/bin/env bash
#
# Bootstrap script: generates native platform folders, pub get, gen-l10n,
# analyze, and test. Phase 1 uses system fonts so no font download is needed.
#
# Usage:
#   ./bootstrap.sh           # normal run (idempotent)
#   ./bootstrap.sh --fresh   # nuke generated l10n files + pub cache first
#
# Requires: Flutter 3.27+ on PATH.

set -euo pipefail

fresh=0
for arg in "$@"; do
  case "$arg" in
    --fresh) fresh=1 ;;
    *) echo "Unknown arg: $arg" >&2; exit 2 ;;
  esac
done

echo "==> Using Flutter at: $(command -v flutter)"
flutter --version | head -1

if [ "$fresh" -eq 1 ]; then
  echo ""
  echo "==> Cleaning build artifacts (--fresh)"
  flutter clean || true
  rm -f lib/l10n/app_localizations*.dart
fi

echo ""
echo "==> Step 1/5: flutter create (generate ios/ and android/ folders)"
flutter create \
  --platforms=ios,android \
  --org com.seasons72 \
  --project-name seasons_72 \
  --no-overwrite \
  .

# flutter create generates a default counter-app widget_test.dart — kill it.
rm -f test/widget_test.dart

echo ""
echo "==> Step 2/5: flutter pub get"
flutter pub get

echo ""
echo "==> Step 3/5: flutter gen-l10n"
flutter gen-l10n

echo ""
echo "==> Step 4/5: flutter analyze"
flutter analyze || echo "[analyze reported issues — not failing bootstrap]"

echo ""
echo "==> Step 5/5: flutter test"
flutter test || echo "[tests reported failures — not failing bootstrap]"

echo ""
echo "========================================================================"
echo "✅  Bootstrap done."
echo ""
echo "Next steps:"
echo "  flutter devices                          # list available devices"
echo "  open -a Simulator                        # launch iOS Simulator (macOS)"
echo "  flutter run                              # run on first available device"
echo "  flutter run -d <device_id>               # run on a specific device"
echo "========================================================================"
