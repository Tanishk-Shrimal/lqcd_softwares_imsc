# Define BLAS and LAPACK locations
OPENBLAS_ROOT="/opt/ohpc/pub/libs/gnu12/openblas/0.3.21"

cmake -S ${SRCDIR}/chroma -B ${BUILDDIR}/build_chroma_cpu \
  -DCMAKE_BUILD_TYPE=DEVEL \
  -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/CHROMA_CPU \
  -DCMAKE_PREFIX_PATH="${INSTALLDIR}/QDPXX;${INSTALLDIR}/libxml2;${INSTALLDIR}/QMP"\
  -DBUILD_SHARED_LIBS=ON \
  -DChroma_ENABLE_OPENMP=ON \
  -DMPIEXEC_MAX_NUMPROCS=64 \
  -DChroma_ENABLE_SSE3=ON \
  -DChroma_ENABLE_CPP_WILSON_DSLASH=ON \
  -DCMAKE_CXX_FLAGS="-O3 -msse3" \
  -DQDPLapack_BLAS_CDOT=ON \
  -DChroma_ENABLE_OPT_EIGCG=ON \
  -DChroma_ENABLE_SSE_BICGSTAB_KERNELS=ON \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DCMAKE_C_COMPILER=mpicc \
  -DBLAS_LIBRARIES="${OPENBLAS_ROOT}/lib/libopenblas.so" \
  -DLAPACK_LIBRARIES="${OPENBLAS_ROOT}/lib/libopenblas.so" \
  -DBLAS_INCLUDE_DIRS="${OPENBLAS_ROOT}/include" \
  -DLAPACK_INCLUDE_DIRS="${OPENBLAS_ROOT}/include"
cmake --build ${BUILDDIR}/build_chroma_cpu ${CMAKE_MAKE_OPTS} -j 64
cmake --install ${BUILDDIR}/build_chroma_cpu
