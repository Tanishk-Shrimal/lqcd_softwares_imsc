cmake -S ${SRCDIR}/llvm-project/llvm -B ${BUILDDIR}/build_llvm \
  -DLLVM_ENABLE_TERMINFO="OFF" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/llvm-project \
  -DCMAKE_PREFIX_PATH="${INSTALLDIR}/libxml2" \
  -DLLVM_TARGETS_TO_BUILD="X86;NVPTX" \
  -DLLVM_ENABLE_ZLIB="OFF" \
  -DBUILD_SHARED_LIBS="OFF" \
  -DLLVM_ENABLE_RTTI="ON"

cmake --build ${BUILDDIR}/build_llvm ${CMAKE_MAKE_OPTS}
cmake --install ${BUILDDIR}/build_llvm  
