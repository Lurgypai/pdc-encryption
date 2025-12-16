#!/bin/bash

if [[ ! -d dependencies ]]; then
    echo "Missing output dir (dependencies), aborting"
    exit 1
fi

cd dependencies

ROOT_DIR=$(pwd)

git clone https://github.com/mercury-hpc/mercury --recursive

cd mercury

# Checkout a release version
git checkout v2.2.0
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${ROOT_DIR}/mercury-ins -DCMAKE_C_COMPILER=${ROOT_DIR}/mpich-ins/bin/mpicc -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_PREFIX_PATH=${ROOT_DIR}/libfabric-ins \
      -DBUILD_TESTING=ON -DNA_USE_OFI=ON -DNA_USE_SM=OFF -DNA_OFI_TESTING_PROTOCOL=tcp ../
make -j && make install

# Test the installation
ctest
