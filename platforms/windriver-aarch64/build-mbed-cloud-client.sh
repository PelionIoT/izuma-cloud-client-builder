#!/bin/bash

if [ -e /builder/"${1}"/buildenv.inc ]; then
    source /builder/"${1}"/buildenv.inc
fi

ARMGCC_DIR="$SYSROOT"
export ARMGCC_DIR="$ARMGCC_DIR"

IZUMA_USE_CORES="${IZUMA_USE_CORES:-8}"

# remove anything from a previous builder
rm -rf /work/mbed-cloud-client-example
# start with the original
cp -a /work/mbed-cloud-client-example.orig /work/mbed-cloud-client-aarch64
# we have to keep the original name b/c apparent it is referenced statically in the CMake files
cd /work/mbed-cloud-client-aarch64 || exit

# apply patch for aarch64
if [ -z "${SKIP_PATCH}" ]; then
    patch -s -p1 < /builder/windriver-aarch64/mbed-cloud-client-aarch64.patch
else
    echo "Skipping patches"
fi

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
        cp -r ./.manifest-dev-tool /out/manifest-dev-tool-aarch64
    else
        echo "Cloud not find .manifest-dev-tool folder"
    fi
fi

cd __Yocto_Generic_YoctoLinux_mbedtls/ || exit
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_TOOLCHAIN_FILE="./../pal-platform/Toolchain/ARMGCC/ARMGCC.cmake" -DEXTERNAL_DEFINE_FILE="./../define.txt"

make -j"${IZUMA_USE_CORES}" mbedCloudClientExample.elf

if [ -f "Debug/mbedCloudClientExample.elf" ]; then
    cp Debug/mbedCloudClientExample.elf /out/mbedCloudClientExample-aarch64.elf
else
    echo "ERROR: no binary produced"
    exit 1
fi


