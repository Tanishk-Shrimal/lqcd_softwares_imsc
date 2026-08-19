#!/bin/bash
cmake -G Ninja -S ${SRCDIR}/quda_laph/source -B ${BUILDDIR}/build_quda_laph \
  -DCMAKE_CXX_COMPILER=mpicxx -DCMAKE_C_COMPILER=mpicc \
  -DARCH=PARALLEL \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/QUDA_LAPH \
  -DCMAKE_PREFIX_PATH="${INSTALLDIR}/QUDA_FOR_LAPH" \
  -DQUDA_DIR=${INSTALLDIR}/QUDA_FOR_LAPH \
  -DHOSTCBLAS=OPENBLAS \
  -DGPUTOOLKIT_DIR=/opt/apps/cuda/13.0.2 \
  -DCBLAS_INC="/opt/ohpc/pub/libs/gnu12/openblas/0.3.21/include" \
  -DCBLAS_LIB="/opt/ohpc/pub/libs/gnu12/openblas/0.3.21/lib/libopenblas.so"

ninja -C ${BUILDDIR}/build_quda_laph -j 64
ninja -C ${BUILDDIR}/build_quda_laph install
