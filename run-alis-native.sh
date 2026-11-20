#!/bin/zsh
# Runs Ishar 3 with native ALIS (open-source reimplementation of the Silmarils engine,
# https://github.com/maestun/alis, commit 31b1811), no DOSBox.
# Useful options: --2x/--3x/--4x (window size), -f (fullscreen), -h (help).
cd "$(dirname "$0")"
exec ./alis/alis "$@" --4x "$PWD/"
