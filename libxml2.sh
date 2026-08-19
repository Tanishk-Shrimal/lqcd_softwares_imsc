cmake -S ${SRCDIR}/libxml2 -B ${BUILDDIR}/build_libxml2 \
  -DLIBXML2_WITH_PYTHON=OFF \
  -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/libxml2 \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DCMAKE_C_COMPILER=mpicc
cmake --build ${BUILDDIR}/build_libxml2 ${CMAKE_MAKE_OPTS}
cmake --install ${BUILDDIR}/build_libxml2
