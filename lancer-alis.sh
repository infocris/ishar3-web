#!/bin/zsh
# Lance Ishar 3 avec ALIS (réimplémentation open source du moteur Silmarils,
# https://github.com/maestun/alis, commit 31b1811), sans DOSBox.
# Options utiles : --2x/--3x/--4x (taille de fenêtre), -f (plein écran), -h (aide).
cd "$(dirname "$0")"
exec ./alis/alis "$@" --4x "$PWD/"
