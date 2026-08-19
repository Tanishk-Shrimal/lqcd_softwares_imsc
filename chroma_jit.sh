cmake -S ${SRCDIR}/chroma -B ${BUILDDIR}/build_chroma_jit \
  -DCMAKE_BUILD_TYPE=DEVEL \
  -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/CHROMA_JIT \
  -DCMAKE_PREFIX_PATH="${INSTALLDIR}/QUDA;${INSTALLDIR}/QMP;${INSTALLDIR}/QDP-JIT;${INSTALLDIR}/llvm-project;${INSTALLDIR}/libxml2;" \
  -DBUILD_SHARED_LIBS=ON \
  -DChroma_ENABLE_JIT_CLOVER=ON \
  -DChroma_ENABLE_QUDA=ON \
  -DChroma_ENABLE_OPENMP=ON \
  -DChroma_ENABLE_CUDA=ON \
  -DChroma_ENABLE_LAPACK=OFF \
  -DMPI_CXX_SKIP_MPICXX=OFF \
  -DCMAKE_Fortran_COMPILER=/opt/ohpc/pub/mpi/openmpi4-gnu12/4.1.6/bin/mpifort \
  -DMPI_Fortran_COMPILER=/opt/ohpc/pub/mpi/openmpi4-gnu12/4.1.6/bin/mpifort \
  -DCMAKE_CXX_FLAGS=${ARCHFLAGS}

cmake --build ${BUILDDIR}/build_chroma_jit ${CMAKE_MAKE_OPTS}
cmake --install ${BUILDDIR}/build_chroma_jit
