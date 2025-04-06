#!/bin/bash


function compile_busybox() {
    tar xf $1
    BUSYBOX_BUILDDIR=`ls $1 |  awk -F'/' '{print $NF}' | awk -F'.tar' '{print $1}'`
    cd ${BUSYBOX_BUILDDIR}

    case $2 in
        arm)
            export ARCH=arm
            export CROSS_COMPILE=arm-linux-gnueabi-
            ;;
        arm64)
            export ARCH=arm64
            export CROSS_COMPILE=aarch64-linux-gnu-
            ;;
        *)
            echo "Unsupported architecture"
            exit
            ;;
    esac

    make menuconfig
    # Setting --->
    # --- Build Options
    # [*] Build static binary (no shared libs)
    
    make -j ${JOBCOUNT}
    make install
    cd -
}

function mk_rootfs_conf() {
    mkdir -p ${BUSYBOX_BUILDDIR}/_install/etc/init.d
    
    echo "mkdir -p /proc" > ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    echo "mkdir -p /tmp" >> ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    echo "mkdir -p /sys" >> ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    echo "mkdir -p /mnt" >> ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    echo "/bin/mount -a" >> ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    echo "mkdir -p /dev/pts" >> ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    echo "mount -t devpts devpts /dev/pts" >> ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    echo "mdev -s" >> ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    chmod a+x ${BUSYBOX_BUILDDIR}/_install/etc/init.d/rcS
    
    echo "proc /proc proc defaults 0 0" > ${BUSYBOX_BUILDDIR}/_install/etc/fstab
    echo "tmpfs /tmp tmpfs defaults 0 0" >> ${BUSYBOX_BUILDDIR}/_install/etc/fstab
    echo "sysfs /sys sysfs defaults 0 0" >> ${BUSYBOX_BUILDDIR}/_install/etc/fstab
    echo "tmpfs /dev tmpfs defaults 0 0" >> ${BUSYBOX_BUILDDIR}/_install/etc/fstab
    
    echo "::sysinit:/etc/init.d/rcS" > ${BUSYBOX_BUILDDIR}/_install/etc/inittab
    echo "::respawn:-/bin/sh" >> ${BUSYBOX_BUILDDIR}/_install/etc/inittab
    echo "::askfirst:-/bin/sh" >> ${BUSYBOX_BUILDDIR}/_install/etc/inittab
    echo "::ctrlaltdel:-/bin/umount -a -r" >> ${BUSYBOX_BUILDDIR}/_install/etc/inittab
    
    mkdir -p ${BUSYBOX_BUILDDIR}/_install/dev
    cd ${BUSYBOX_BUILDDIR}/_install/dev
    mknod -m 666 tty1 c 4 1
    mknod -m 666 tty2 c 4 2
    mknod -m 666 tty3 c 4 3
    mknod -m 666 tty4 c 4 4
    mknod -m 666 console c 5 1
    mknod -m 666 null c 1 3
    cd -
    
    mkdir -p ${BUSYBOX_BUILDDIR}/_install/mnt
   
    cp -raf ${LIB} ${BUSYBOX_BUILDDIR}/_install/ # 拷贝库文件, 如不拷贝交叉编译需加-static编译为静态文件
}

function mk_rootfs_img() {
    if [ ! -d initramfs ]; then
        mkdir -p initramfs
    fi
    dd if=/dev/zero of=initramfs/initramfs_${ARCH}.img bs=1M count=256
    mkfs.ext4 initramfs/initramfs_${ARCH}.img
    mount -t ext4 initramfs/initramfs_${ARCH}.img /mnt -o loop
    cp -raf ${BUSYBOX_BUILDDIR}/_install/* /mnt
    umount /mnt
}


# ================
# main
# ================
if [ $# -ne 2 ]; then
    echo "Usage: $0 busybox_pkg arch (arm or arm64)"
    exit
fi

BUSYBOX_PKG=$1

case $2 in
    arm)
        ARCH=arm
        LIB=/usr/arm-linux-gnueabi/lib
        ;;
    arm64)
        ARCH=arm64
        LIB=/usr/aarch64-linux-gnu/lib
        ;;
    *)
        echo "Unsupported architecture"
        exit
        ;;
esac

compile_busybox ${BUSYBOX_PKG} ${ARCH}
if [ $? -ne 0 ]; then
    echo "compile busybox failed"
    exit
fi

mk_rootfs_conf
mk_rootfs_img
rm -rf ${BUSYBOX_BUILDDIR}
