---
title: /proc/* 代表的意义
date: 2024-04-03 21:09:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
img_path: 
---


所谓的进程都是在内存当中嘛！而内存当中的数据又都是写入到 /proc/* 这个目录下的。

基本上，目前主机上面的各个进程的 PID 都是以目录的形态存在于 /proc 当中。 举例来说，我们开机所执行的第一个程序 systemd 他的 PID 是 1 ， 这个 PID 的所有相关信息都写入在 /proc/1/* 当中！若我们直接观察 PID 为 1 的数据好了，他有点像这样：

```bash
# ls /proc/1
arch_status         cwd        mem            patch_state   stat
attr                environ    mountinfo      personality   statm
autogroup           exe        mounts         projid_map    status
auxv                fd         mountstats     root          syscall
cgroup              fdinfo     net            sched         task
clear_refs          gid_map    ns             schedstat     timens_offsets
cmdline             io         numa_maps      sessionid     timers
comm                limits     oom_adj        setgroups     timerslack_ns
coredump_filter     loginuid   oom_score      smaps         uid_map
cpu_resctrl_groups  map_files  oom_score_adj  smaps_rollup  wchan
cpuset              maps       pagemap        stack
```

里面的数据还挺多的，不过，比较有趣的其实是两个文件，分别是：

- cmdline：这个进程被启动的指令串；
- environ：这个进程的环境变量内容。

看下我本机的这两个文件的内容如下：

1. `cat /proc/1/cmdline`

输出：

```bash
/sbin/initsplash
```

1. `cat /proc/1/environ` 

输出：

```bash
HOME=/init=/sbin/initNETWORK_SKIP_ENSLAVED=TERM=linuxBOOT_IMAGE=/boot/vmlinuz-5.15.0-100-genericdrop_caps=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/binPWD=/rootmnt=/root
```

其他的文件与对应的内容是这样的

| 文件名            | 文件内容                                                     |
| ----------------- | ------------------------------------------------------------ |
| /proc/cmdline     | 加载 kernel 时所下达的相关指令与参数，可了解指令是如何启动的。 |
| /proc/cpuinfo     | 本机的 CPU 的相关信息，包含频率、类型与运算功能等。          |
| /proc/devices     | 记录了系统各个主要装置的主要装置代号，与 mknod 有关。        |
| /proc/filesystems | 目前系统已经加载的文件系统。                                 |
| /proc/interrupts  | 目前系统上面的 IRQ 分配状态。                                |
| /proc/ioports     | 目前系统上面各个装置所配置的 I/O 地址。                      |
| /proc/kcore       | 内存的大小，但不建议直接读取。                               |
| /proc/loadavg     | 记录系统的三个平均数值，用于 top 和 uptime。                 |
| /proc/meminfo     | 内存信息，类似于使用 free 命令查看的内容。                   |
| /proc/modules     | 已加载的模块列表，也可以看作是驱动程序。                     |
| /proc/mounts      | 系统已挂载的数据，类似于使用 mount 命令查看的内容。          |
| /proc/swaps       | 记录系统挂载的内存分区。                                     |
| /proc/partitions  | 记录所有分区的信息，类似于使用 fdisk -l 命令查看的内容。     |
| /proc/uptime      | 记录系统运行时间信息，类似于使用 uptime 命令查看的内容。     |
| /proc/version     | 记录核心的版本信息，类似于使用 uname -a 命令查看的内容。     |
| /proc/bus/*       | 记录一些总线的装置信息，包括 USB 装置。                      |