#!/bin/sh

# Detect mold linker support
# Workaround: mold's new PLT scheme stores unrelocated addresses in GOT.PLT
# entries. IRELATIVE resolvers (from .rela.dyn) run before .rela.plt lazy
# setup, so PLT calls from resolvers jump to unmapped addresses and crash.
# -Wl,-z,now forces eager binding, ensuring GOT.PLT is fully resolved before
# any IRELATIVE resolver executes. See mold-problem/BUGREPORT.md for details.
if echo "int main(){}" | ${CC:-cc} -fuse-ld=mold -x c - -o /dev/null 2>/dev/null; then
  MOLD_FLAGS="-DLLVM_USE_LINKER=mold"
  MOLD_LINKER_FLAGS="-Wl,-z,now"
elif [ -d /usr/local/libexec/mold ]; then
  MOLD_FLAGS=""
  MOLD_LINKER_FLAGS="-B/usr/local/libexec/mold -Wl,-z,now"
else
  MOLD_FLAGS=""
  MOLD_LINKER_FLAGS=""
fi

$CMAKE -G Ninja \
  -C "$SRCDIR"/clang/cmake/caches/VectorEngine.cmake \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DLLVM_PARALLEL_COMPILE_JOBS="$COMPILE_THREADS" \
  -DLLVM_PARALLEL_LINK_JOBS="$LINK_THREADS" \
  -DCMAKE_INSTALL_PREFIX="$DEST" \
  -DCMAKE_C_FLAGS="$OPTFLAGS" \
  -DCMAKE_CXX_FLAGS="$OPTFLAGS" \
  -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_EXE_LINKER_FLAGS="$MOLD_LINKER_FLAGS" \
  -DCMAKE_SHARED_LINKER_FLAGS="$MOLD_LINKER_FLAGS" \
  -DCMAKE_MODULE_LINKER_FLAGS="$MOLD_LINKER_FLAGS" \
  $MOLD_FLAGS \
  $EXTRA_CMAKE_OPTS \
  "$SRCDIR"/llvm
