LIB_DIR=$(realpath dependencies)
OUT_DIR=$(pwd)

. env.sh

cd pdc

rm -r out
mkdir out
cd out

cmake -DBUILD_MPI_TESTING=ON -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=ON -DCMAKE_INSTALL_PREFIX=${OUT_DIR}/pdc-ins \
    -DENC_WRAPPER_ENABLE_GCRYPT=On -DENC_WRAPPER_ENABLE_NETTLE=Off \
    -DPDC_ENABLE_MPI=ON -DMERCURY_DIR=${MERCURY_DIR} -DCMAKE_C_COMPILER=${LIB_DIR}/mpich-ins/bin/mpicc -DMPI_RUN_CMD=${LIB_DIR}/mpich-ins/bin/mpiexec ../
