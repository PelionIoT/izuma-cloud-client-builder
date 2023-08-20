# DOWNLOADS

# aarch64 for Wind River
if [ ! -e $ADDS/gcc-arm-none-eabi-10.3-2021.07-x86_64-linux.tar.bz2 ]; then
    curl https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/10.3-2021.07/gcc-arm-none-eabi-10.3-2021.07-x86_64-linux.tar.bz2 --output $ADDS/gcc-arm-none-eabi-10.3-2021.07-x86_64-linux.tar.bz2
fi
if [ ! -e $ADDS/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz ]; then
    curl https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz --output $ADDS/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz
fi
if [ ! -e $ADDS/libidn2-latest.tar.gz ]; then
    curl https://ftp.gnu.org/gnu/libidn/libidn2-latest.tar.gz --output $ADDS/libidn2-latest.tar.gz
fi

