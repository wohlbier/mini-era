#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../

# -DTIME
# -DINT_TIME

CFLAGS="-DUSE_SIM_ENVIRON"
CFLAGS+=" -fprofile-instr-generate"
#CFLAGS+=" -fprofile-instr-use=/workspace/mini-era/miniera.profdata"

CC=clang \
CXX=clang++ \
cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_C_FLAGS="${CFLAGS}" \
    $dir

# Generate miniera.profdata with:
# llvm-profdata merge -output=miniera.profdata default.profraw
