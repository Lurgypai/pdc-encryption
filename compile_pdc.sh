#!/bin/bash

if [[ ! -d "pdc/out" ]]; then
    echo "Missing compilation directory \"pdc/out,\" exiting."
    exit 1
fi

cd pdc/out

make clean
make -j && make install
