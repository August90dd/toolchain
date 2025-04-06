#!/bin/bash


if [ $# -eq 1 ] && [ $1 == "debug" ]; then
	echo "Enable GDB debug mode"
	DBG="-s -S"
fi

KERNEL_DIR=~/toolchain/qemu2runkernel/kernel/
ROOTFS_DIR=~/toolchain/qemu2runkernel/rootfs/

qemu-system-aarch64 \
    -M virt   \
    -cpu cortex-a53 \
    -smp 4  \
    -m 1024M    \
    -kernel ${KERNEL_DIR}/Image \
    -drive file=${ROOTFS_DIR}/rootfs.ext2,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -append "root=/dev/vda rw console=ttyAMA0" \
    -net nic,model=virtio \
    -net user,hostfwd=tcp::2222-:22 \
    -nographic  \
    ${DBG}

#-initrd initramfs.cpio.gz
#-append "root=/dev/ram rdinit=/linuxrc console=ttyAMA0"
