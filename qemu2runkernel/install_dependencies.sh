#!/bin/sh


sudo apt install qemu-kvm  \
    flex \
    bison \ 
    libncurses5-dev \
    libssl-dev \
    gcc-arm-linux-gnueabi \     # 软浮点
    #gcc-arm-linux-gnueabihf \   # 硬浮点
    gdb-multiarch
