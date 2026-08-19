# Define your HDF5 and OpenBLAS roots based on your module list
HDF5_ROOT="/opt/ohpc/pub/libs/gnu12/openmpi4/hdf5/1.10.8/" # Verify this path with 'module show phdf5'
OPENBLAS_ROOT="/opt/ohpc/pub/libs/gnu12/openblas/0.3.21" # Verify this path with 'module show openblas'

cmake -S ${SRCDIR}/chroma_laph -B ${BUILDDIR}/build_chroma_laph \
  -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/chroma_laph \
  -DCMAKE_PREFIX_PATH="${INSTALLDIR}/CHROMA_CPU;${INSTALLDIR}/QDPXX;${INSTALLDIR}/QMP;${INSTALLDIR}/libxml2" \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DQDP_ND=4 \
  -DCMAKE_C_COMPILER=mpicc \
  -DChroma_DIR="${INSTALLDIR}/CHROMA_CPU/lib/cmake/Chroma" \
  -DQDPXX_DIR="${INSTALLDIR}/QDPXX/lib/cmake/QDPXX" \
  -DQMP_DIR="${INSTALLDIR}/QMP/lib/cmake/QMP" \
  -DLAPH_CXX_FLAGS="-O3 -msse3 -DHAVE_BLAS -DBUILD_BLAS -DLAPACK_BLAS -DUSE_OPENBLAS -DLAPH_USE_HDF5" \
  -DLAPH_INCDIRS="${OPENBLAS_ROOT}/include;${HDF5_ROOT}/include;${INSTALLDIR}/openQCD-1.6/openqcd_1.6_4d/include" \
  -DLAPH_LIBDIRS="${OPENBLAS_ROOT}/lib;${HDF5_ROOT}/lib" \
  -DLAPH_LIBS="openblas;lapack;hdf5;hdf5_hl;z;dl;m" \
  -DUSE_OPENQCD=OFF \
  -DOPENQCD_LIB="${INSTALLDIR}/openQCD-1.6/openqcd_1.6_4d/lib/libopenQCD.a" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DLIBXML2_LIBRARY="${INSTALLDIR}/libxml2/lib64/libxml2.so" \
  -DLIBXML2_INCLUDE_DIR="${INSTALLDIR}/libxml2/include/libxml2/"

# Run the build
cmake --build ${BUILDDIR}/build_chroma_laph -j 64
cmake --install ${BUILDDIR}/build_chroma_laph

