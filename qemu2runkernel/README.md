1) ./install_dependencies.sh

2) ./compile_kernel.sh

3) ./mkrootfs.sh

4) ./qemu.sh
    qemu中使用9p用于host和guest中共享目录，不需要网络的支持，而是需要virtio的支持。
    
    qemu启动参数需要添加：
    -fsdev local,security_model=passthrough,id=fsdev0,path=/mnt
    -device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare
    
    在guest中挂载host共享的目录：
    mkdir /mnt/host_files
    mount -t 9p -o trans=virtio,version=9p2000.L hostshare /mnt/host_files
    
    mount: unknown filesystem type '9p'
    需要在kernel中添加9p的支持：
    CONFIG_NET_9P=y
    CONFIG_NET_9P_VIRTIO=y
    CONFIG_NET_9P_DEBUG=y (Optional)
    CONFIG_9P_FS=y
    CONFIG_9P_FS_POSIX_ACL=y (Optional)
