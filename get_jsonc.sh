#!/bin/bash

pushd dependencies

INS_DIR=$(pwd)

git clone git@github.com:json-c/json-c.git
pushd json-c
mkdir out
cd out 
cmake ..\
    -DCMAKE_INSTALL_PREFIX=$INS_DIR/json-c-ins
make -j`nproc` && make install
