#!/bin/bash


if [ $# -ne 1 ]; then
    echo "Usage: $0 arch (arm or arm64)"
    exit
fi

case $1 in
    arm)
        make qemu_arm_vexpress_defconfig
        make menuconfig
        ### Toolchain ###
        # Toolchain type: External toolchain

        ### Kernel ###
        # [] Linux kernel
        
        ### Target packages ### 
        # Networking applications
        # [*] openssh
        
        ### Filesystem images ###
        # [*] ext2/3/4 root filesystem
        # ext2/3/4 variant: ext4
        
        make -j$(nproc)
        cp output/images/rootfs.ext2 ~/toolchain/qemu2runkernel/rootfs/arm
        ;;

    arm64)
        make qemu_aarch64_virt_defconfig
        make menuconfig
        ### Toolchain ###
        # Toolchain type: External toolchain
        
        ### System configuration ###
        # [*] Enable root login with password
        # (needed for ssh) Root password
        
        ### Kernel ###
        # [] Linux kernel
        
        ### Target packages ### 
        # Networking applications
        # [*] openssh
        # Text editors and viewers
        # [*] bvi
        
        ### Filesystem images ###
        # [*] ext2/3/4 root filesystem
        # ext2/3/4 variant: ext4
        
        make -j$(nproc)
        cp output/images/rootfs.ext2 ~/toolchain/qemu2runkernel/rootfs/arm64
        ;;

    *)
        echo "Unsupported architecture"
        exit
        ;;
esac
