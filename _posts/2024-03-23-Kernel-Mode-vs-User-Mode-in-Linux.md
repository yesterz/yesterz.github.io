---
title: 内核态和用户态 
date: 2024-03-23 11:43:00 +0800
author: 
categories: [Linux]
tags: [System]
pin: false
math: true
mermaid: false
img_path: /assets/images/
---

要了解用户态和内核态需要先了解Linux系统的体系架构：

![用户空间（应用程序的活动空间）和内核](Kernel-Mode-vs-User-Mode-in-Linux/images.png){: w="330" h="300" .left }

Linux 操作系统的体系架构分为：用户空间（应用程序的活动空间）和内核。

内核：本质上可以理解为一种软件，控制计算机的硬件资源，并提供上层应用程序运行的环境。

用户空间：上层应用程序活动的空间。应用程序的执行必须依托于内核提供的资源，包括CPU资源、存储资源、I/O资源等。

系统调用：为了使上层应用能够访问到这些资源，内核必须为上层应用提供访问的接口：即系统调用。

所有进程初始都运行于用户空间，此时即为用户运行状态（简称：用户态）；但是当它调用系统调用执行某些操作时，例如 I/O调用，此时需要陷入内核中运行，我们就称进程处于内核运行态（或简称为内核态）。 

系统调用（System Call）的过程可以简单理解为：

1. 用户态程序将一些数据值放在寄存器中， 或者使用参数创建一个堆栈， 以此表明需要操作系统提
供的服务。
2. 用户态程序执行系统调用。CPU切换到内核态，并跳到位于内存指定位置的指令。
3. 系统调用处理器(system call handler)会读取程序放入内存的数据参数，并执行程序请求的服务。
4. 系统调用完成后，操作系统会重置CPU为用户态并返回系统调用的结果。

由此可见用户态切换至内核态需要传递许多变量，同时内核还需要保护好用户态在切换时的一些寄存器
值、变量等，以备内核态切换回用户态。这种切换就带来了大量的系统资源消耗。

查看 CPU 时间在 User space 与 Kernel Space 之间的分配情况，可以使用`top`命令。它的第三行输出就是 CPU 时间分配统计。

这一行有 8 项统计指标。

```terminal
top - 11:25:31 up 1 day,  1:15,  1 user,  load average: 2.81, 1.98, 1.86
Tasks: 527 total,   2 running, 523 sleeping,   0 stopped,   2 zombie
%Cpu(s):  3.3 us,  2.0 sy,  2.2 ni, 91.9 id,  0.5 wa,  0.0 hi,  0.1 si,  0.0 st
MiB Mem :  15712.8 total,    652.8 free,   9137.5 used,   5922.5 buff/cache
MiB Swap:  16212.0 total,  13956.2 free,   2255.8 used.   3878.9 avail Mem 
```

其中，第一项 3.3 us（user 的缩写）就是 CPU 消耗在 User space 的时间百分比，第二项 2.0 sy（system 的缩写）是消耗在 Kernel space 的时间百分比。

其他 6 个指标的含义。

- `ni`：niceness 的缩写，CPU 消耗在 nice 进程（低优先级）的时间百分比
- `id`：idle 的缩写，CPU 消耗在闲置进程的时间百分比，这个值越低，表示 CPU 越忙
- `wa`：wait 的缩写，CPU 等待外部 I/O 的时间百分比，这段时间 CPU 不能干其他事，但是也没有执行运算，这个值太高就说明外部设备有问题
- `hi`：hardware interrupt 的缩写，CPU 响应硬件中断请求的时间百分比
- `si`：software interrupt 的缩写，CPU 响应软件中断请求的时间百分比
- `st`：stole time 的缩写，该项指标只对虚拟机有效，表示分配给当前虚拟机的 CPU 时间之中，被同一台物理机上的其他虚拟机偷走的时间百分比

如果想查看单个程序的耗时，一般使用time命令。程序名之前加上 time 命令，会在程序执行完毕以后，默认显示三行统计。

- `real`：程序从开始运行到结束的全部时间，这是用户能感知到的时间，包括 CPU 切换去执行其他任务的时间。
- `user`：程序在 User space 执行的时间
- `sys`：程序在 Kernel space 执行的时间

user 和 sys 之和，一般情况下，应该小于 real。但如果是多核 CPU，这两个指标反映的是所有 CPU 的总耗时，所以它们之和可能大于 real。