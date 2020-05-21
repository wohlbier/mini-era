#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../

# -DTIME
# -DINT_TIME

CFLAGS="-DUSE_SIM_ENVIRON"
#CFLAGS+=" -DVERBOSE"
#CFLAGS+=" -DINT_TIME"

CC=gcc \
CXX=g++ \
cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_C_FLAGS="${CFLAGS}" \
    $dir
