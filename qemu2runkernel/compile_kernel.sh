#!/bin/bash


if [ $# -ne 2 ]; then
    echo "Usage: $0 kbuild_src arch (arm or arm64)"
    exit
fi

KERNEL_PKG=$1
KBUILD_SRC=`ls ${KERNEL_PKG} | awk -F'/' '{print $NF}' | awk -F'.tar' '{print $1}'`
JOBCOUNT=${JOBCOUNT=$(nproc)}

if [ -d ${KBUILD_SRC} ]; then
    rm -rf ${KBUILD_SRC}
fi
tar xf ${KERNEL_PKG}
cd ${KBUILD_SRC}

case $2 in
    arm)
        export ARCH=arm
        export CROSS_COMPILE=arm-linux-gnueabi-
        make vexpress_defconfig # 采用vexpress虚拟开发板的默认配置
        make menuconfig
        # Kernel Features --->
        # Memory split (3G/1G user/kernel split) --->
        #
        # Boot options --->
        #   ()Default kernel command string
        make zImage -j ${JOBCOUNT}
        make modules -j ${JOBCOUNT}
        make dtbs # dts文件存放硬件信息
        mkdir -p extra/arm
        cp arch/arm/boot/zImage extra/arm
        cp arch/arm/boot/dts/*ca9.dtb extra/arm
        cp .config extra/arm
        make modules_install INSTALL_MOD_PATH=extra/arm
        ;;

    arm64)
        export ARCH=arm64
        export CROSS_COMPILE=aarch64-linux-gnu-
        make defconfig
        make menuconfig
        # Kernel Features --->
        #   Page size (4KB) --->
        #       Virtual address space size (48-bit) --->
        #
        # Boot options --->
        #   ()Default kernel command string
        make -j ${JOBCOUNT}
        ;;

    *)
        echo "Unsupported architecture"
        exit
        ;;
esac
