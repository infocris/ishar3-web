#!/bin/zsh
# Builds web/ishar3.jsdos: game files + web/dosbox.conf (as .jsdos/dosbox.conf)
set -euo pipefail
WEB="$(cd "$(dirname "$0")" && pwd)"
GAME="${ISHAR3_GAME:-$(dirname "$WEB")/game}"
OUT="$WEB/ishar3.jsdos"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/.jsdos" && cp "$WEB/dosbox.conf" "$TMP/.jsdos/dosbox.conf"
rm -f "$OUT"
cd "$GAME" && zip -q -9 "$OUT" *.IO *.FIC *.DAT *.EXE *.STP *.TST
cd "$TMP" && zip -q -9 -r "$OUT" .jsdos
echo "Bundle: $OUT ($(du -h "$OUT" | cut -f1))"
