#!/bin/zsh
set -e
OUT=${1:-build-wasm}; mkdir -p $OUT/obj
SRCS=(${(f)"$(find src -name '*.c' | grep -v -e sys_sdl1.c -e sys_atari)"})
INC=(${(f)"$(find src -type d | sed 's/^/-I/')"})
FLAGS=(-O2 -pthread -sUSE_SDL=2 -DNDEBUG -w)
for f in $SRCS; do o=$OUT/obj/${${f//\//_}%.c}.o; [[ $o -nt $f ]] || echo "emcc -c $f -o $o $INC $FLAGS"; done | xargs -P 8 -I{} sh -c '{}'
emcc $OUT/obj/*.o -o $OUT/alis.js $FLAGS \
  -sPTHREAD_POOL_SIZE=6 -sALLOW_MEMORY_GROWTH=1 -sINITIAL_MEMORY=128MB -sSTACK_SIZE=1MB \
  -sEXIT_RUNTIME=0 -sINVOKE_RUN=0 -sFORCE_FILESYSTEM=1 -lidbfs.js \
  -sEXPORTED_RUNTIME_METHODS=callMain,FS,IDBFS,HEAPU8,HEAPU32,UTF8ToString -sEXPORTED_FUNCTIONS=_main,_malloc,_free -sENVIRONMENT=web,worker
ls -la $OUT/alis.*
