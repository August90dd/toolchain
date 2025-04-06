#!/bin/bash


function compile_busybox() {
    cd ${BUSYBOX_BUILDDIR}

    make defconfig
    cp ../busybox-1.37.0.config .config
    #make menuconfig
    # Setting --->
    # --- Build Options
    # [*] Build static binary (no shared libs)
    
    make -j$(nproc)

    make install

    cd -
}

function mk_initramfs() {
    mkdir -p initramfs/{bin,dev/pts,etc/init.d,proc,sbin,sys,tmp,usr/bin,usr/sbin}

    cp -r ${BUSYBOX_BUILDDIR}/_install/* initramfs/

    cd initramfs

    mknod -m 666 dev/tty1 c 4 1
    mknod -m 666 dev/tty2 c 4 2
    mknod -m 666 dev/tty3 c 4 3
    mknod -m 666 dev/tty4 c 4 4
    mknod -m 666 dev/ttyAMA0 c 204 64
    mknod -m 666 dev/console c 5 1
    mknod -m 666 dev/null c 1 3
    mknod -m 666 dev/zero c 1 5
    mknod -m 666 dev/ram b 1 0

cat > etc/init.d/rcS << 'EOF'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t tmpfs none /tmp
mount -t devtmpfs none /dev
mount -t devpts devpts /dev/pts
mdev -s
EOF
chmod +x etc/init.d/rcS

cat > etc/inittab << EOF
::sysinit:/etc/init.d/rcS
::respawn:-/bin/sh
::ctrlaltdel:/sbin/reboot
::shutdown:/sbin/swapoff -a
::shutdown:/bin/umount -a -r
EOF

cat > etc/fstab << EOF
proc    /proc   proc    defaults    0   0
sysfs   /sys    sysfs   defaults    0   0
tmpfs   /tmp    tmpfs   defaults    0   0
devtmpfs /dev   devtmpfs defaults   0   0
EOF

    find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs/initramfs_${ARCH}.cpio.gz

    cd -
}


# ================
# main
# ================
if [ $# -ne 1 ]; then
    echo "Usage: $0 busybox_pkg(to build)"
    exit
fi

if [ ! -f $1 ]; then
    echo "busybox compressed file not exist"
    exit
fi

tar xf $1
BUSYBOX_BUILDDIR=`ls $1 | awk -F'/' '{print $NF}' | awk -F'.tar' '{print $1}'`

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

compile_busybox
if [ $? -ne 0 ]; then
    echo "compile busybox failed"
    exit
fi

mk_initramfs
if [ $? -ne 0 ]; then
    echo "make initramfs configure failed"
    exit
fi

rm -rf initramfs
rm -rf ${BUSYBOX_BUILDDIR}
