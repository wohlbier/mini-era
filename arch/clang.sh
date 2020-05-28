#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../

# -DTIME
# -DINT_TIME

CFLAGS="-DUSE_SIM_ENVIRON"
#CFLAGS+=" -DVERBOSE"
CFLAGS+=" -fprofile-instr-generate"
#CFLAGS+=" -fprofile-instr-use=/workspace/mini-era/miniera.profdata"

CC=clang \
CXX=clang++ \
cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_C_FLAGS="${CFLAGS}" \
    $dir

# 1. run application:
#    ./build_clang/miniera
# 2. generate miniera.profdata
#    llvm-profdata merge -output=miniera.profdata default.profraw
# 3. Rebuild application with -fprofile-instr-use=... above
#    cd build_clang
#    rm -rf *
#    (comment OUT -fprofile-instr-generate and IN -fprofile-instr-use=...
#    ../arch/clang.sh
#    (make ir)
#    make fp
