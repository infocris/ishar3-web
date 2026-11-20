# Ishar 3 dans le navigateur

Ishar 3 (Silmarils, version DOS GOG en français) jouable dans un navigateur grâce à
[ALIS](https://github.com/maestun/alis), réimplémentation open source du moteur Silmarils,
compilée en WebAssembly. La page ajoute une carte, la marche automatique, la téléportation,
l'état de l'équipe, des boutiques et auberges, l'attaque automatique, etc.

**Les fichiers du jeu ne sont pas fournis** : il faut posséder Ishar 3 (GOG) et placer ce
dépôt dans le dossier du jeu (à côté de `MAIN.IO`, `*.IO`, `*.FIC`, `*.DAT`…).

## Lancer

```sh
./lancer-web-alis.sh      # ALIS en WebAssembly : http://localhost:8333/alis/
```

Le serveur `web/serve.py` sert les fichiers du jeu et enregistre les sauvegardes dans
`web/saves/alis/` (non versionné).

Autres lanceurs : `lancer-web.sh` (js-dos), `lancer-alis.sh` (ALIS natif, binaire dans
`alis/`), `lancer.sh` (DOSBox Staging).

## Moteur

`web/alis/alis.js` et `alis.wasm` sont compilés depuis ALIS (commit `31b1811`) avec
`web/alis/alis-emscripten.patch` :

```sh
git clone https://github.com/maestun/alis alis-src && cd alis-src
git checkout 31b1811 && git apply ../web/alis/alis-emscripten.patch
../web/alis/build-wasm.sh && cp build-wasm/alis.{js,wasm} ../web/alis/
```

ALIS est sous licence MIT (Olivier Huguenot, Vadim Kindl). Ishar 3 et ses graphismes
appartiennent à leurs ayants droit.
