#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../

# -DTIME
# -DINT_TIME

CC=gcc \
CXX=g++ \
cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_C_FLAGS="-DUSE_SIM_ENVIRON" \
    $dir
