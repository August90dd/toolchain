#!/bin/bash


if [ $# -lt 2 ]; then
    echo "Usage: $0 kbuild_dir arch (arm or arm64) [debug]"
    exit
fi

if [ $# -eq 3 ] && [ $3 == "debug" ]; then
	echo "Enable GDB debug mode"
	DBG="-s -S"
fi

KBUILD_DIR=$1
ARCH=$2

case ${ARCH} in
    arm)
        qemu-system-arm -M vexpress-a9 -smp 4 -m 1024M -nographic \
            -kernel ${KBUILD_DIR}/extra/arm/zImage \
            -dtb ${KBUILD_DIR}/extra/arm/vexpress-v2p-ca9.dtb \
            -sd initramfs/initramfs_${ARCH}.img \
            -append "rw rootwait earlyprintk console=ttyAMA0 init=/linuxrc root=/dev/mmcblk0" \
            -fsdev local,security_model=passthrough,id=fsdev0,path=/mnt \
            -device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
            ${DBG} #2>/dev/null
            ;;
    arm64)
        qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -smp 4 -m 1024M -nographic \
            -kernel ${KBUILD_DIR}/extra/arm64/Image \
            -append "rdinit=/linuxrc console=ttyAMA0"  \
            -fsdev local,id=kmod_dev,security_model=none \
            -device virtio-9p-device,fsdev=kmod_dev,mount_tag=kmod_mount \
            ${DBG} #2>/dev/null
            ;;
    *)
        echo "Unsupported architecture"
        exit
        ;;
esac
