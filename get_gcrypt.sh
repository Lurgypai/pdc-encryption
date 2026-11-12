#!/bin/bash

if [[ -z $WORK_SPACE ]]; then
    WORK_SPACE=$(realpath .)
fi

SOURCE_DIR=$WORK_SPACE/source
INSTALL_DIR=$WORK_SPACE/install

pushd $SOURCE_DIR > /dev/null

GPG_ERROR_CONFIG=$(which gpg-error-config)
if [[ -z ${GPG_ERROR_CONFIG} ]]; then
    echo "Downloading and unzipping gpg error"
    wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.56.tar.bz2
    tar -xvf "libgpg-error-1.56.tar.bz2"
    rm "libgpg-error-1.56.tar.bz2"
    echo "Compiling gpg error"
    pushd "libgpg-error-1.56" > /dev/null
    ./autogen.sh
    ./configure --prefix=${INSTALL_DIR}/gpgerror --enable-install-gpg-error-config
    make -j`nproc` && make install
    popd > /dev/null
else
    echo "Found gpg-error-config at \"${GPG_ERROR_CONFIG}\", skipping install"
fi

GCRYPT_CONFIG=$(which libgcrypt-config)
if [[ -z ${GCRYPT_CONFIG} ]]; then
    echo "Downloading and unzipping gcrypt"
    wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.2.tar.bz2
    tar -xvf "libgcrypt-1.11.2.tar.bz2"
    rm "libgcrypt-1.11.2.tar.bz2"
    pushd "libgcrypt-1.11.2" > /dev/null
    ./configure --prefix=${INSTALL_DIR}/gcrypt --with-libgpg-error-prefix=${INSTALL_DIR}/gpgerror
    make -j`nproc` && make install
    popd > /dev/null
else
    echo "Found gcrypt-config at \"${GCRYPT_CONFIG}\", skipping install"
fi

popd > /dev/null
