#!/bin/bash

if [[ -z $WORK_SPACE ]]; then
    WORK_SPACE=$(realpath .)
fi

DEP_DIR="$WORK_SPACE/install"
WRAPPER_OUT_DIR="${DEP_DIR}/enc_wrapper"

export GCRYPT_ROOT_DIR=${DEP_DIR}/gcrypt
export GPG_ERROR_ROOT_DIR=${DEP_DIR}/gpgerror

pushd $WORK_SPACE/source
    rm -rf enc_wrapper
    git clone https://github.com/Lurgypai/enc_wrapper.git
    pushd enc_wrapper
        git switch AddIndex
        pushd wrapper
            mkdir out
            pushd out
                cmake .. \
                    -DCMAKE_EXPORT_COMPILE_COMMANDS=On \
                    -DCMAKE_INSTALL_PREFIX=${WRAPPER_OUT_DIR} \
                    -DENC_WRAPPER_ENABLE_NETTLE=Off
                make -j`nproc` && make install
            popd
        popd
    popd
popd

