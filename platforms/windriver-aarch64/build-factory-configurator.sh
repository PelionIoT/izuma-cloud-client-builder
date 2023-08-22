#!/bin/bash 

PATH=/builder/windriver-aarch64/toolchain/gcc-aarch64-none-eabi/bin:$PATH
export PATH=$PATH
SYSROOT=/builder/windriver-aarch64/toolchain/gcc-aarch64-none-eabi
ARMGCC_DIR=$SYSROOT
export ARMGCC_DIR=$ARMGCC_DIR
CC=aarch64-none-linux-gnu-gcc
CXX=aarch64-none-linux-gnu-g++
export CC=$CC
export CXX=$CXX
#export LIBRARY

IZUMA_USE_CORES="${IZUMA_USE_CORES:-8}"

# remove anything from a previous builder
rm -rf /work/factory-configurator-client-example
# start with the original
cp -a /work/factory-configurator-client-example.orig /work/factory-configurator-client-aarch64
# we have to keep the original name b/c apparent it is referenced statically in the CMake files
cd /work/factory-configurator-client-aarch64

# ran during docker build - skip
#mbed deploy
# apply patch for aarch64
if [ -z "${SKIP_PATCH}" ]; then
    patch -s -p1 < /builder/windriver-aarch64/mbed-cloud-client-aarch64.patch
else
    echo "Skipping patches"
fi

cd __Yocto_Generic_YoctoLinux_mbedtls/
cmake -G "Unix Makefiles" -DPARSEC_TPM_SE_SUPPORT=OFF -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_TOOLCHAIN_FILE="./../pal-platform/Toolchain/ARMGCC/ARMGCC.cmake" -DEXTERNAL_DEFINE_FILE="./../linux-config.cmake"
#-- -j ${IZUMA_USE_CORES}
make -j${IZUMA_USE_CORES} factory-configurator-client-example.elf

if [ -f "Debug/factory-configurator-client-example.elf" ]; then
    cp Debug/factory-configurator-client-example.elf /out/factory-configurator-client-example-aarch64.elf
else   
    echo "ERROR: no binary produced"
    exit 1
fi


