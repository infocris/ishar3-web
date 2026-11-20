#!/bin/zsh
# Runs Ishar 3 in the browser with ALIS compiled to WebAssembly (no DOSBox).
# Engine: https://github.com/maestun/alis (commit 31b1811) + web/alis/alis-emscripten.patch,
# built by web/alis/build-wasm.sh (Emscripten). Saves: web/saves/alis/.
set -euo pipefail
WEB="$(cd "$(dirname "$0")" && pwd)/web"
PORT="${PORT:-8333}"
URL="http://localhost:$PORT/alis/"
if lsof -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then open "$URL"; exit 0; fi
(sleep 1 && open "$URL") &
echo "Ishar 3 (ALIS): $URL  (Ctrl+C to stop)"
cd "$WEB" && exec python3 serve.py "$PORT"
