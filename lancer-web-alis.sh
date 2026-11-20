#!/bin/zsh
# Lance Ishar 3 dans le navigateur avec ALIS compilé en WebAssembly (sans DOSBox).
# Moteur : https://github.com/maestun/alis (commit 31b1811) + web/alis/alis-emscripten.patch,
# compilé par web/alis/build-wasm.sh (Emscripten). Sauvegardes : web/saves/alis/.
set -euo pipefail
WEB="$(cd "$(dirname "$0")" && pwd)/web"
PORT="${PORT:-8333}"
URL="http://localhost:$PORT/alis/"
if lsof -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then open "$URL"; exit 0; fi
(sleep 1 && open "$URL") &
echo "Ishar 3 (ALIS) : $URL  (Ctrl+C pour arrêter)"
cd "$WEB" && exec python3 serve.py "$PORT"
