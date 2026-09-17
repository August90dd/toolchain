# 调试信息与符号表(gcc -g)
    $ dwarfdump     dumps DWARF debug information of an ELF object
    $ strip         去掉调试信息与符号表


# 常用操作
    (gdb) ctrl+x, a 开启gdbtui
    (gdb) ctrl+x, 2 打开汇编指令级窗口

    (gdb) b(break)  设置断点
    (gdb) r(run)

    (gdb) s(step)   单步跟踪进入(执行一行源程序代码, 如果此行代码中有函数调用, 则进入该函数)
    (gdb) n(next)   单步跟踪(执行一行源程序代码, 此行代码中的函数调用也一并执行)
    (gdb) si        命令类似于s命令
    (gdb) ni        命令类似于n命令
                    所不同的是, 这两个命令(si/ni)所针对的是汇编指令, 而s/n针对的是源代码.

    (gdb) bt(backtrace)     栈回溯

    (gdb) i(info) b         查看断点
          i(info) thread    查看线程
    (gdb) d(delete)         后接断点号, 删除断点.

    (gdb) watch 只要watch的变量被修改, 就会自动设置断点停住.

    (gdb) c(continue)

    (gdb) fin(ish)  把函数运行完成, 例如a()->b()->c(), c()函数中执行finish返回到b().


# 用gdb查看内存
    格式: x/nfu <addr>

    说明:
    x是examine的缩写

    n表示要显示的内存单元的个数

    f表示显示方式, 可取如下值:
        x 按十六进制格式显示变量
        d 按十进制格式显示变量
        u 按十进制格式显示无符号整型
        o 按八进制格式显示变量
        t 按二进制格式显示变量
        i 指令地址格式
        c 按字符格式显示变量
        f 按浮点数格式显示变量

    u表示一个地址单元的长度:
        b表示单字节
        h表示双字节
        w表示四字节
        g表示八字节

    Format letters are o(octal), x(hex), d(decimal), u(unsigned decimal),
    t(binary), f(float), a(address), i(instruction), c(char) and s(string).
    Size letters are b(byte), h(halfword), w(word), g(giant, 8 bytes).

    举例:
    x/3uh buf
    表示从内存地址buf读取内容, h表示以双字节为一个单位, 3表示三个单位, u表示按十六进制显示.


# 修改内存
    命令形式: set * 有类型的指针=value
    使用示例: 对于`void *p = malloc(128)`这样分配的地址, 可以使用先强制指定类型, 后再写入值, 如:
    ```
    set *((char *)p) = 0x61
    set *((char *)p) = 'a'
    set *((char *)(p+110)) = 'b'
    set *(int *)p = 0xff
    ```


# attach pid
    $ gdb attach pid
    执行后进程会停止, 跳到gdb执行.


# gdb call functions 
    gdb带call func能力
    (gdb) call printf("hello gdb\n")


# gdb debug MultiProcess
    [4.11 Debugging Forks](https://sourceware.org/gdb/current/onlinedocs/gdb/Forks.html)
    (1) detach-on-fork
        (gdb) show detach-on-fork
        Whether gdb will detach the child of a fork is on.

        on(default)     调试一个进程, 调试哪个取决于follow-fork-mode的设置
        off             调试两个进程

    (2) follow-fork-mode
        (gdb) show follow-fork-mode
        Debugger response to a program call of fork or vfork is "parent".

        parent(default)
        child

    (3) i(nfo) inferiors
        列出当前 GDB 会话中所有被调试的目标进程（inferiors）的信息

        在deatch-on-fork off时父子进程都attach, 可以通过inferior切换.
        (gdb) inferior num 在两进程中切换


# gdb debug MultiThread
    $ gcc -g multipthread.c
    $ gdb ./a.out
    (gdb) i(nfo) threadx                查看线程
    (gdb) thread 2                      切换到线程2
    (gdb) thread apply all bt           查看所有线程backtrace
    (gdb) thread apply n bt             查看线程n的backtrace

    (gdb) i(nfo) b(reakpoint)           查看断点
    (gdb) b(reakpoint) n                默认针对所有线程设置断点
    (gdb) b(reakpoint) n thread m       只针对线程m设置断点
    (gdb) d(elete) n                    删除断点

    (gdb) set scheduler-locking on/off  on锁住调度器, off放开. 
    (gdb) c(continue)                   只会让一个线程运行, 另外的线程会锁住.


# coredump
    i.   ulimit -c unlimited   不限制core文件大小, 只会在在当前shell中生效.
    ii.  echo "kernel.core_pattern = /var/crash/core-%e-%p-%t" >> /etc/sysctl.conf
            %e  添加导致产生core的命令名
            %p  添加pid
            %t  添加core文件生成时间
    iii. sysctl -p

    $ gcc -g coredump.c
    $ gdb ./a.out -c /var/crash/core-a.out-4071-1789626121

## minicoredumper
    i.  install minicoredumper
        /etc/minicoredumper/minicoredumper.cfg.json     配置文件
    ii. echo '|usr/sbin/minicoredumper %P %u %s %t %h %e' | tee /proc/sys/kernel/core_pattern


# gdb + qemu调试内核
    调试模式启动qemu
    $ qemu -s -S
    (gdb) gdb-multiarch vmlinux


# with `LD_PRELOAD`
    (gdb) set environment LD_PRELOAD ./lsan-helper.so
    (gdb) file a.out
