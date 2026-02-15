#!/bin/sh

# Detect mold linker support
if echo "int main(){}" | ${CC:-cc} -fuse-ld=mold -x c - -o /dev/null 2>/dev/null; then
  MOLD_FLAGS="-DLLVM_USE_LINKER=mold"
elif [ -d /usr/local/libexec/mold ]; then
  MOLD_FLAGS="-DCMAKE_EXE_LINKER_FLAGS=-B/usr/local/libexec/mold \
    -DCMAKE_SHARED_LINKER_FLAGS=-B/usr/local/libexec/mold \
    -DCMAKE_MODULE_LINKER_FLAGS=-B/usr/local/libexec/mold"
else
  MOLD_FLAGS=""
fi

$CMAKE -G Ninja \
  -C $SRCDIR/clang/cmake/caches/VectorEngine.cmake \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DLLVM_PARALLEL_COMPILE_JOBS=$COMPILE_THREADS \
  -DLLVM_PARALLEL_LINK_JOBS=$LINK_THREADS \
  -DCMAKE_INSTALL_PREFIX=$DEST \
  -DCMAKE_C_FLAGS="$OPTFLAGS" \
  -DCMAKE_CXX_FLAGS="$OPTFLAGS" \
  -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF \
  $MOLD_FLAGS \
  $SRCDIR/llvm
