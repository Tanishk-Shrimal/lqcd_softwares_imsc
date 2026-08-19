cmake -S ${SRCDIR}/qmp -B ${BUILDDIR}/build_qmp \
  -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/QMP \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_C_FLAGS="-fPIC" \
  -DQMP_MPI=ON \
  -DQMP_TESTING=ON
cmake --build ${BUILDDIR}/build_qmp ${CMAKE_MAKE_OPTS}
cmake --install ${BUILDDIR}/build_qmp
