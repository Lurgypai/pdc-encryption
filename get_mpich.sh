#!/bin/bash

if [[ ! -d dependencies ]]; then
    echo "Missing output dir (dependencies), aborting"
    exit 1
fi

cd dependencies

ROOT_DIR=$(pwd)

git clone git@github.com:pmodels/mpich.git

cd mpich

git submodule update --init
./autogen.sh
./configure --prefix="${ROOT_DIR}/mpich-ins" --disable-fotran
make -j`nproc` && make install

