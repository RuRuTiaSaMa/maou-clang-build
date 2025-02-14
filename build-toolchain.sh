#!/usr/bin/env bash

set -eo pipefail

base=$(dirname "$(readlink -f "$0")")
install=$base/install

rm -rf $install

# Function to show an informational message
function msg() {
    echo -e "\e[1;32m$@\e[0m"
}

# Build LLVM
msg "Building LLVM..."
./build-llvm.py \
	--vendor-string "Maou" \
    --build-target distribution \
	--targets ARM AArch64 X86 \
	--install-folder "$install" \
	--install-target distribution \
	--defines "LLVM_PARALLEL_COMPILE_JOBS=$(nproc) LLVM_PARALLEL_LINK_JOBS=$(nproc) CMAKE_C_FLAGS=-O3 CMAKE_CXX_FLAGS=-O3 LLVM_USE_LINKER=lld LLVM_ENABLE_LLD=ON" \
	--projects clang lld polly compiler-rt bolt \
	--pgo kernel-defconfig \
	--lto thin \
	--bolt 

# Build binutils
msg "Building binutils..."
./build-binutils.py \
 --targets arm aarch64 x86_64 \
 --install-folder "$install"

# Remove unused products
msg "Removing unused products..."
rm -fr $install/include
rm -f $install/lib/*.a $install/lib/*.la

# Strip remaining products
msg "Stripping remaining products..."
for f in $(find $install -type f -exec file {} \; | grep 'not stripped' | awk '{print $1}'); do
	strip ${f: : -1}
done

# Set executable rpaths so setting LD_LIBRARY_PATH isn't necessary
msg "Setting library load paths for portability..."
for bin in $(find $install -mindepth 2 -maxdepth 3 -type f -exec file {} \; | grep 'ELF .* interpreter' | awk '{print $1}'); do
	# Remove last character from file output (':')
	bin="${bin: : -1}"

	echo "$bin"
	patchelf --set-rpath '$ORIGIN/../lib' "$bin"
done
