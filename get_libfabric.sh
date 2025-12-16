#!/bin/bash

if [[ ! -d dependencies ]]; then
    echo "Missing output dir (dependencies), aborting"
    exit 1
fi

cd dependencies

ROOT_DIR=$(pwd)

git clone https://github.com/ofiwg/libfabric

cd libfabric

git checkout v1.18.0

./autogen.sh
./configure --prefix=${ROOT_DIR}/libfabric-ins CC=${ROOT_DIR}/mpich-ins/bin/mpicc CFLAG="-O2"
make -j`nproc` && make install
make check
