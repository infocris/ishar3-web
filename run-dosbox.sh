#!/bin/zsh
# Runs Ishar 3 in DOSBox Staging with dosbox-mac.conf.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "${ISHAR3_GAME:-$ROOT/game}"   # dosbox-mac.conf mounts the current directory as C:

exec dosbox-staging -conf "$ROOT/dosbox-mac.conf" -noconsole
