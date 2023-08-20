#!/bin/bash

# MUST BE RUN IN PLATFORM ROOT FOLDER

PATH=/builder/windriver-aarch64/toolchain/gcc-arm-none-eabi/bin:$PATH
SYSROOT=/builder/windriver-aarch64/toolchain/gcc-arm-none-eabi
CC=aarch64-none-linux-gnu-gcc
cd libidn2-2.3.4/
./configure --verbose --host=aarch64-none-linux-gnu --with-sysroot=${SYSROOT} --prefix=${SYSROOT}
#--prefix=${SYSROOT}/aarch64-none-linux-gnu
make -j4
make install

