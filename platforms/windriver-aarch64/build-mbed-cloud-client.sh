#!/bin/bash 

PATH=/builder/windriver-aarch64/toolchain/gcc-arm-none-eabi/bin:$PATH
export PATH=$PATH
SYSROOT=/builder/windriver-aarch64/toolchain/gcc-arm-none-eabi
ARMGCC_DIR=$SYSROOT
export ARMGCC_DIR=$ARMGCC_DIR
CC=aarch64-none-linux-gnu-gcc
CXX=aarch64-none-linux-gnu-g++
export CC=$CC
export CXX=$CXX

# remove anything from a previous builder
rm -rf /work/mbed-cloud-client-example
# start with the original
cp -a /work/mbed-cloud-client-example.orig /work/mbed-cloud-client-aarch64
# we have to keep the original name b/c apparent it is referenced statically in the CMake files
cd /work/mbed-cloud-client-aarch64

# ran during docker build - skip
#mbed deploy
# apply patch for aarch64
patch -s -p1 < ../mbed-cloud-client-example-aarch64.patch
#python3 pal-platform/pal-platform.py deploy --target=Yocto_Generic_YoctoLinux_mbedtls generate
if [ -e /auth/mbed_cloud_dev_credentials.c ]; then
    cp /auth/mbed_cloud_dev_credentials.c .
else
    echo "Need to place mbed_cloud_dev_credentials.c in /auth"
    exit 1
fi
if [[ -z "${IZUMA_ACCESS_KEY}" ]]; then 
    echo "Need to set IZUMA_ACCESS_KEY"
    exit 1
else 
    manifest-dev-tool init --access-key ${IZUMA_ACCESS_KEY}
fi

cd __Yocto_Generic_YoctoLinux_mbedtls/
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_TOOLCHAIN_FILE="./../pal-platform/Toolchain/ARMGCC/ARMGCC.cmake" -DEXTERNAL_DEFINE_FILE="./../define.txt"
make mbedCloudClientExample.elf