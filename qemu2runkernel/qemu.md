# 显示版本
qemu-img -V
qemu-system-arm --version


# 显示支持的开发板
qemu-system-arm -M help
    vexpress-a9 是arm32一款很常用的开发板, Cortex-A9处理器.


# qemu 参数
-M(Machine) 需要模拟的开发板
-m(memory)  指定内存大小
-kernel     运行哪个内核镜像
-dtb        linux最新内核支持的设备树来传递一些参数
-nographic  不使用图形界面
-append     添加一些参数, 比如启动参数, 指定使用串口作为控制台.


# 退出
Ctrl+a x
