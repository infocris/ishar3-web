#!/bin/zsh
# Lance Ishar 3 dans le navigateur (js-dos / WebAssembly).
set -euo pipefail
WEB="$(cd "$(dirname "$0")" && pwd)/web"
PORT="${PORT:-8333}"
[[ -f "$WEB/ishar3.jsdos" ]] || "$WEB/build-bundle.sh"
[[ -d "$WEB/node_modules/js-dos" ]] || (cd "$WEB" && npm install)
(sleep 1 && open "http://localhost:$PORT/") &
echo "Ishar 3 : http://localhost:$PORT/  (Ctrl+C pour arrêter)"
cd "$WEB" && exec python3 serve.py "$PORT"
