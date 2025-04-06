#!/bin/bash


if [ $# -ne 1 ]; then
    echo "Usage: $0 kernel_src_dir(to build)"
    exit
fi
if [ ! -d $1 ]; then
    echo "Kernel source dir not exsit"
    exit
fi

cd $1

KERNEL_DIR=~/toolchain/qemu2runkernel/kernel/

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

make defconfig
make menuconfig
# Kernel Features --->
#   Page size (4KB) --->
#       Virtual address space size (48-bit) --->

make -j$(nproc)

cp arch/arm64/boot/Image ${KERNEL_DIR}
