#!/bin/bash 

set -x

IZUMA_USE_CORES="${IZUMA_USE_CORES:-8}"

# remove anything from a previous builder
rm -rf /work/mbed-cloud-client-x86
# start with the original
cp -a /work/mbed-cloud-client-example.orig /work/mbed-cloud-client-x86
# we have to keep the original name b/c apparent it is referenced statically in the CMake files
cd /work/mbed-cloud-client-x86

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

cd __x86_x64_NativeLinux_mbedtls/
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_TOOLCHAIN_FILE="./../pal-platform/Toolchain/GCC/GCC.cmake" -DEXTERNAL_DEFINE_FILE="./../define.txt" 
make -j"${IZUMA_USE_CORES}" mbedCloudClientExample.elf

if [ -e Debug/mbedCloudClientExample.elf ]; then
    cp -r Debug /out/Debug-gcc-x86
fi

