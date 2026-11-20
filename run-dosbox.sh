#!/bin/zsh
# Runs Ishar 3 in DOSBox Staging with dosbox-mac.conf.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

exec dosbox-staging -conf "$ROOT/dosbox-mac.conf" -noconsole
