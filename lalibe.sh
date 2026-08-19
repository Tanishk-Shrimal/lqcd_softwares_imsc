cmake -S ${SRCDIR}/lalibe -B ${BUILDDIR}/build_lalibe \
  -DCMAKE_INSTALL_PREFIX="${INSTALLDIR}/LALIBE" \
  -DCMAKE_PREFIX_PATH=${INSTALLDIR}\
  -DBUILD_HDF5=ON \
  -DCHROMA_INSTALL="${INSTALLDIR}/CHROMA_CPU" \
  -DChroma_DIR="/lustre/tanishks/chroma_gpu/install/CHROMA_CPU/lib/cmake/Chroma" \
  -DLIBXML2_INCLUDE_DIR="/lustre/tanishks/chroma_laph_suite/install/libxml2/include/libxml2" \
  -DLIBXML2_LIBRARY="/lustre/tanishks/chroma_laph_suite/install/libxml2/lib/libxml2.so" \
  -DLibXml2_ROOT="/lustre/tanishks/chroma_laph_suite/install/libxml2" \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DCMAKE_C_COMPILER=mpicc 
cmake --build ${BUILDDIR}/build_lalibe ${CMAKE_MAKE_OPTS} -j64
cmake --install ${BUILDDIR}/build_lalibe
