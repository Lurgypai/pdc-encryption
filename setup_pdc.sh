#!/bin/bash
echo "===== SETTING UP INITIAL WORKSPACE ====="
export WORK_SPACE=$(realpath .)

if [[ -e $WORK_SPACE/source ]]; then
    rm -rf $WORK_SPACE/source
fi
mkdir -p $WORK_SPACE/source

if [[ -e $WORK_SPACE/install ]]; then
    rm -rf $WORK_SPACE/install
fi
mkdir -p $WORK_SPACE/install

cd $WORK_SPACE/source
git clone -q --branch v1.18.0 --depth 1 https://github.com/ofiwg/libfabric.git libfabric
git clone https://github.com/mercury-hpc/mercury --recursive
git clone https://github.com/Lurgypai/enc_wrapper.git
git clone https://github.com/Lurgypai/pdc.git

export LIBFABRIC_SRC_DIR=$WORK_SPACE/source/libfabric
export MERCURY_SRC_DIR=$WORK_SPACE/source/mercury
export ENCWRAPPER_SRC_DIR=$WORK_SPACE/source/enc_wrapper
export PDC_SRC_DIR=$WORK_SPACE/source/pdc

export LIBFABRIC_DIR=$WORK_SPACE/install/libfabric
export MERCURY_DIR=$WORK_SPACE/install/mercury
export ENCWRAPPER_DIR=$WORK_SPACE/install/enc_wrapper
export PDC_DIR=$WORK_SPACE/install/pdc

mkdir -p $LIBFABRIC_SRC_DIR
mkdir -p $MERCURY_SRC_DIR
mkdir -p $ENCWRAPPER_SRC_DIR
mkdir -p $PDC_SRC_DIR

mkdir -p $LIBFABRIC_DIR
mkdir -p $MERCURY_DIR
mkdir -p $ENCWRAPPER_DIR
mkdir -p $PDC_DIR

# Save the environment variables to a file
echo "export WORK_SPACE=$WORK_SPACE" > $WORK_SPACE/pdc_env.sh
echo "export LIBFABRIC_SRC_DIR=$LIBFABRIC_SRC_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export MERCURY_SRC_DIR=$MERCURY_SRC_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export ENCWRAPPER_SRC_DIR=$ENCWRAPPER_SRC_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export PDC_SRC_DIR=$PDC_SRC_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export LIBFABRIC_DIR=$LIBFABRIC_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export MERCURY_DIR=$MERCURY_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export ENCWRAPPER_DIR=$ENCWRAPPER_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export PDC_DIR=$PDC_DIR" >> $WORK_SPACE/pdc_env.sh

echo "export HG_TRANSPORT=sockets" >> $WORK_SPACE/pdc_env.sh
echo "export HG_HOST=lo" >> $WORK_SPACE/pdc_env.sh

echo "===== SETTING UP LIBFABRIC ====="

cd $LIBFABRIC_SRC_DIR
[ -x configure ] || ./autogen.sh
./configure --prefix="$LIBFABRIC_DIR" CC=mpicc CFLAGS="-O2" \
  --enable-tcp=yes --enable-rxm=yes --enable-sockets=yes --disable-verbs --disable-psm3 --disable-efa --disable-opx
make -j && make install

# Test the installation
make check

# Set the environment variables
export LD_LIBRARY_PATH="$LIBFABRIC_DIR/lib:$LD_LIBRARY_PATH"
export PATH="$LIBFABRIC_DIR/include:$LIBFABRIC_DIR/lib:$PATH"
echo 'export LD_LIBRARY_PATH=$LIBFABRIC_DIR/lib:$LD_LIBRARY_PATH' >> $WORK_SPACE/pdc_env.sh
echo 'export PATH=$LIBFABRIC_DIR/include:$LIBFABRIC_DIR/lib:$PATH' >> $WORK_SPACE/pdc_env.sh

echo "===== SETTING UP MERCURY ====="
cd $MERCURY_SRC_DIR

# Checkout a release version
git checkout v2.2.0
mkdir build
cd build
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_INSTALL_PREFIX=$MERCURY_DIR -DCMAKE_C_COMPILER=mpicc -DBUILD_SHARED_LIBS=ON \
    -DBUILD_TESTING=ON -DNA_USE_OFI=ON -DNA_USE_SM=OFF -DNA_OFI_TESTING_PROTOCOL=sockets ../
make -j && make install

# Test the installation
ctest

# Set the environment variables
export LD_LIBRARY_PATH="$MERCURY_DIR/lib:$LD_LIBRARY_PATH"
export PATH="$MERCURY_DIR/include:$MERCURY_DIR/lib:$PATH"
echo 'export LD_LIBRARY_PATH=$MERCURY_DIR/lib:$LD_LIBRARY_PATH' >> $WORK_SPACE/pdc_env.sh
echo 'export PATH=$MERCURY_DIR/include:$MERCURY_DIR/lib:$PATH' >> $WORK_SPACE/pdc_env.sh

echo "===== SETTING UP GCRYPT ====="
$WORK_SPACE/get_gcrypt.sh
export GPGERROR_SRC_DIR=$WORK_SPACE/source/gpgerror
export GCRYPT_SRC_DIR=$WORK_SPACE/source/gcrypt
export GPGERROR_DIR=$WORK_SPACE/install/gpgerror
export GCRYPT_DIR=$WORK_SPACE/install/gcrypt

echo "export GPGERROR_SRC_DIR=$GPGERROR_SRC_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export GCRYPT_SRC_DIR=$GCRYPT_SRC_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export GPGERROR_DIR=$GPGERROR_DIR" >> $WORK_SPACE/pdc_env.sh
echo "export GCRYPT_DIR=$GCRYPT_DIR" >> $WORK_SPACE/pdc_env.sh

export LD_LIBRARY_PATH="$GPGERROR_DIR/lib:$GCRYPT_DIR/lib:$LD_LIBRARY_PATH"
export PATH="$GPGERROR_DIR/include:$GPGERROR_DIR/bin:$GCRYPT_DIR/include:$GCRYPT_DIR/bin:$PATH"

echo 'export LD_LIBRARY_PATH="$GPGERROR_DIR/lib:$GCRYPT_DIR/lib:$LD_LIBRARY_PATH"' >> $WORK_SPACE/pdc_env.sh
echo 'export PATH="$GPGERROR_DIR/include:$GPGERROR_DIR/bin:$GCRYPT_DIR/include:$GCRYPT_DIR/bin:$PATH"' >> $WORK_SPACE/pdc_env.sh

echo "===== SETTING UP ENC_WRAPPER ====="
$WORK_SPACE/get_enc_wrapper.sh
export ENCWRAPPER_SRC_DIR=$WORK_SPACE/source/enc_wrapper
export ENCWRAPPER_DIR=$WORK_SPACE/install/enc_wrapper

echo 'export ENCWRAPPER_SRC_DIR=$WORK_SPACE/source/enc_wrapper' >> $WORK_SPACE/pdc_env.sh
echo 'export ENCWRAPPER_DIR=$WORK_SPACE/install/enc_wrapper' >> $WORK_SPACE/pdc_env.sh

export LD_LIBRARY_PATH="$ENCWRAPPER_DIR/lib:$LD_LIBRARY_PATH"
export PATH="$ENCWRAPPER_DIR/include:$PATH"

echo 'export LD_LIBRARY_PATH="$ENCWRAPPER_DIR/lib:$LD_LIBRARY_PATH"' >> $WORK_SPACE/pdc_env.sh
echo 'export PATH="$ENCWRAPPER_DIR/include:$PATH"' >> $WORK_SPACE/pdc_env.sh

echo "===== SETTING UP PDC ====="
./compile_pdc.sh

export LD_LIBRARY_PATH="$PDC_DIR/lib:$LD_LIBRARY_PATH"
export PATH="$PDC_DIR/include:$PDC_DIR/lib:$PATH"
echo 'export LD_LIBRARY_PATH=$PDC_DIR/lib:$LD_LIBRARY_PATH' >> $WORK_SPACE/pdc_env.sh
echo 'export PATH=$PDC_DIR/include:$PDC_DIR/lib:$PATH' >> $WORK_SPACE/pdc_env.sh
