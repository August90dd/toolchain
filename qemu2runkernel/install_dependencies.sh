#!/bin/sh

# gcc-arm-linux-gnueabi     软浮点
# gcc-arm-linux-gnueabihf   硬浮点

apt install	\
    qemu-kvm  \
    flex \
    bison \
    libncurses-dev \
    libssl-dev \
    gcc-arm-linux-gnueabi   \
    gdb-multiarch
