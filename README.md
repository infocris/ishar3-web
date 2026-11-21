# Ishar 3 in the browser

Ishar 3 (Silmarils, French DOS release from GOG) playable in a web browser with
[ALIS](https://github.com/maestun/alis), an open-source reimplementation of the Silmarils
engine, compiled to WebAssembly. The page adds a map, auto-walk, teleport, party status,
shop and inn panels, auto-attack and more. The game and the page UI are in French.

**Game files are not included.** You need to own Ishar 3 (GOG) and copy its install folder
(`MAIN.IO`, `*.IO`, `*.FIC`, `*.DAT`…) to `game/` (ignored by git), or point the
`ISHAR3_GAME` environment variable to it. The title menu also needs the empty marker files
`INTRO150.DAT` and `LOGO150.DAT` in that folder.

## Run

```sh
./run-web.sh      # ALIS in WebAssembly: http://localhost:8333/alis/
```

`web/serve.py` serves the game files and writes saves to `web/saves/alis/` (not tracked).

Other launchers: `run-web-jsdos.sh` (DOSBox through js-dos), `run-alis-native.sh` (native
ALIS, binary expected in `alis/`), `run-dosbox.sh` (DOSBox Staging).

## Engine

`web/alis/alis.js` and `alis.wasm` are built from ALIS (commit `31b1811`) with
`web/alis/alis-emscripten.patch`:

```sh
git clone https://github.com/maestun/alis alis-src && cd alis-src
git checkout 31b1811 && git apply ../web/alis/alis-emscripten.patch
../web/alis/build-wasm.sh && cp build-wasm/alis.{js,wasm} ../web/alis/
```

ALIS is MIT-licensed (Olivier Huguenot, Vadim Kindl). Ishar 3 and its artwork belong to
their respective rights holders.
