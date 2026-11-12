cd $PDC_SRC_DIR
git checkout add-more-encryption
mkdir build
cd build
export ENCWRAPPER_ROOT_DIR=$ENCWRAPPER_DIR
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DBUILD_MPI_TESTING=ON -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=ON -DCMAKE_INSTALL_PREFIX=$PDC_DIR \
    -DPDC_ENABLE_MPI=ON -DMERCURY_DIR=$MERCURY_DIR -DCMAKE_C_COMPILER=mpicc -DMPI_RUN_CMD=mpiexec ../
make -j && make install

# Set the environment variables
