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
rm -rf /work/mbed-cloud-client-example
# start with the original
cp -a /work/mbed-cloud-client-example.orig /work/mbed-cloud-client-aarch64
# we have to keep the original name b/c apparent it is referenced statically in the CMake files
cd /work/mbed-cloud-client-aarch64

# ran during docker build - skip
#mbed deploy
# apply patch for aarch64
if [ -z "${SKIP_PATCH}" ]; then
    patch -s -p1 < /builder/windriver-aarch64/mbed-cloud-client-aarch64.patch
else
    echo "Skipping patches"
fi

sed -i "s/MBED_CONF_APP_DEVELOPER_MODE=1/MBED_CONF_APP_DEVELOPER_MODE=0/" define.txt
cd __Yocto_Generic_YoctoLinux_mbedtls/
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE="Release" -DCMAKE_TOOLCHAIN_FILE="./../pal-platform/Toolchain/ARMGCC/ARMGCC.cmake" -DEXTERNAL_DEFINE_FILE="./../define.txt"

make -j${IZUMA_USE_CORES}

if [ -f "Release/mbedCloudClientExample.elf" ]; then
    cp -r Release/ /out/Release-aarch64
else   
    echo "ERROR: no binary produced"
    exit 1
fi


