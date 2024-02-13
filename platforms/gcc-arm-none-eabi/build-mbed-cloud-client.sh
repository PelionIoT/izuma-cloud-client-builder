#!/bin/bash 

PATH=/builder/gcc-arm-none-eabi/toolchain/gcc-arm-none-eabi/bin:$PATH
export PATH=$PATH
SYSROOT=/builder/gcc-arm-none-eabi/toolchain/gcc-arm-none-eabi
ARMGCC_DIR=$SYSROOT
export ARMGCC_DIR=$ARMGCC_DIR
CC=aarch64-none-linux-gnu-gcc
CXX=aarch64-none-linux-gnu-g++
export CC=$CC
export CXX=$CXX
#export LIBRARY

IZUMA_USE_CORES="${IZUMA_USE_CORES:-8}"

# remove anything from a previous builder
rm -rf /work/mbed-cloud-client-gcc-arm-none-eabi
# start with the original
cp -a /work/mbed-cloud-client-example.orig /work/mbed-cloud-client-gcc-arm-none-eabi
# we have to keep the original name b/c apparent it is referenced statically in the CMake files
cd /work/mbed-cloud-client-gcc-arm-none-eabi

if [ -e /auth/mbed_cloud_dev_credentials.c ]; then
    cp /auth/mbed_cloud_dev_credentials.c .
else
    echo "Need to place mbed_cloud_dev_credentials.c in /auth"
    exit 1
fi
if [ -e /auth/update_default_resources.c ]; then
    cp /auth/update_default_resources.c .
else
    if [[ -z "${IZUMA_ACCESS_KEY}" ]]; then
        manifest-dev-tool init
    else
        manifest-dev-tool init --access-key "${IZUMA_ACCESS_KEY}"
    fi
    if [ -d ".manifest-dev-tool" ]; then
        cp -r ./.manifest-dev-tool /out/manifest-dev-tool-gcc-x86
    else
        echo "Cloud not find .manifest-dev-tool folder"
    fi
fi
if [ -e /auth/fota_linux_ifs.cpp ]; then
    cp /auth/fota_linux_ifs.cpp .
else
    echo "Need to place fota_linux_ifs.cpp in /auth"
    exit 1
fi

cd __Yocto_Generic_YoctoLinux_mbedtls/
cmake --G "Unix Makefiles" -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_TOOLCHAIN_FILE="./../pal-platform/Toolchain/ARMGCC/ARMGCC.cmake" -DEXTERNAL_DEFINE_FILE="./../define.txt"
make mbedCloudClientExample.elf

if [ -e __Yocto_Generic_YoctoLinux_mbedtls/Debug/mbedCloudClientExample.elf ]; then
    cp __Yocto_Generic_YoctoLinux_mbedtls/Debug/mbedCloudClientExample.elf /out/__Yocto_Generic_YoctoLinux_mbedtls/Debug/mbedCloudClientExample-arm32.elf
fi
