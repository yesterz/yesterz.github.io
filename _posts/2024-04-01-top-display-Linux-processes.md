---
title: Top 命令
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
---

相对于 ps 是撷取一个时间点的进程状态， top 则可以持续侦测进程运作的状态！

使用方式如下：

```bash
top [-d number] | top [-bnp]
```

## Top display

```terminal
top - 10:19:24 up 2 days, 51 min,  1 user,  load average: 0.94, 1.27, 1.51
Tasks: 522 total,   2 running, 516 sleeping,   0 stopped,   4 zombie
%Cpu(s):  1.5 us,  1.3 sy,  0.0 ni, 97.2 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :  15712.7 total,   2095.5 free,   7352.8 used,   6264.4 buff/cache
MiB Swap:  16212.0 total,  12832.0 free,   3380.0 used.   7293.7 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND    
   5859 root      20   0   24.7g 118504  76836 S   0.7   0.7  50:51.04 Xorg
```

top 主要分为两个画面，上面的画面为整个系统的资源使用状态，基本上总共有六行，

### SUMMARY Display

显示的内容依序是：

第一行(top...)：这一行显示的信息分别为：

1. 目前的时间，亦即是 10:19:24 那个项目；
2. 开机到目前为止所经过的时间，亦即是 up 2 days, 那个项目；
3. 已经登入系统的用户人数，亦即是 1 users, 项目；
4. 系统在 1, 5, 15 分钟的平均工作负载。我们在第十五章谈到的 batch 工作方式为负载小于 0.8 就是这个负载啰！代表的是 1, 5, 15 分钟，系统平均要负责运作几个进程(工作)的意思。 越小代表系统越闲置，若高于 1 得要注意你的系统进程是否太过繁复了！

第二行(Tasks...)：显示的是目前进程的总量与个别进程在什么状态(running, sleeping, stopped, zombie)。 比较

需要注意的是最后的 zombie 那个数值，如果不是 0 ！好好看看到底是那个 process 变成僵尸了吧？

第三行(%Cpus...)：显示的是 CPU 的整体负载，每个项目可使用 ? 查阅。需要特别注意的是 wa 项目，那

个项目代表的是 I/O wait， 通常你的系统会变慢都是 I/O 产生的问题比较大！因此这里得要注意这个项目

耗用 CPU 的资源喔！ 另外，如果是多核心的设备，可以按下数字键『1』来切换成不同 CPU 的负载率。比如如下这样子：

```terminal
top - 10:23:22 up 2 days, 55 min,  1 user,  load average: 1.03, 1.26, 1.46
Tasks: 521 total,   1 running, 516 sleeping,   0 stopped,   4 zombie
%Cpu0  :  2.0 us,  6.6 sy,  0.0 ni, 91.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu1  :  0.7 us,  1.3 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu2  :  2.0 us,  0.0 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu3  :  1.3 us,  0.7 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu4  :  0.7 us,  0.7 sy,  0.0 ni, 98.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu5  :  0.7 us,  0.0 sy,  0.0 ni, 98.7 id,  0.0 wa,  0.0 hi,  0.7 si,  0.0 st
%Cpu6  :  0.0 us,  0.6 sy,  0.0 ni, 99.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu7  :  0.7 us,  1.3 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu8  :  0.7 us,  0.7 sy,  0.0 ni, 98.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu9  :  1.3 us,  0.0 sy,  0.0 ni, 98.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu10 :  2.6 us,  1.3 sy,  0.0 ni, 96.1 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu11 :  0.7 us,  0.0 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu12 :  0.7 us,  0.0 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu13 :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu14 :  0.0 us,  1.3 sy,  0.0 ni, 98.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu15 :  0.6 us,  1.3 sy,  0.0 ni, 98.1 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :  15712.7 total,   2002.7 free,   7412.5 used,   6297.5 buff/cache
MiB Swap:  16212.0 total,  12832.7 free,   3379.2 used.   7270.9 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND  
   5859 root      20   0   24.7g 119956  78288 S   5.9   0.7  50:28.52 Xorg 
```

第四行与第五行：表示目前的物理内存与虚拟内存 (Mem/Swap) 的使用情况。 再次重申，要注意的是 swap

的使用量要尽量的少！如果 swap 被用的很大量，表示系统的物理内存实在不足！

第六行：这个是当在 top 程序当中输入指令时，显示状态的地方。交互式命令的地方，交互的地方。

### FIELDS / Columns

至于 top 下半部分的画面，则是每个 process 使用的资源情况。比较需要注意的是：

1. `PID` 每个 process 的 ID 啦！
2. `USER` 该 process 所属的使用者；
3. `PR` Priority 的简写，进程的优先执行顺序，越小越早被执行；
4. `NI` Nice 的简写，与 Priority 有关，也是越小越早被执行；
5. `%CPU` CPU 的使用率；
6. `%MEM` 内存的使用率；
7. `TIME+` CPU 使用时间的累加；

## COMMAND-LINE Options

`-d` 后面可以接秒数，就是整个进程画面更新的秒数。预设是 3 秒；

`-b` 以批次的方式执行 top ，还有更多的参数可以使用喔！通常会搭配数据流重导向来将批次的结果输出成为文件。(Batch-mode operation)

`-n` 与 -b 搭配，意义是“需要进行几次 top 的输出结果”。使用方式如下：

```bash
# 将 top 的信息进行 2 次，然后将结果输出到 /tmp/top.txt
top -b -n 2 > /tmp/top.txt
```

`-p` 指定某些个 PID 来进行观察监测而已。使用方式如下：

```bash
top -pN1 -pN2 ...  or  -pN1,N2,N3 ...
```

## INTERACTIVE Commands

在 top 执行过程当中可以使用的按键指令：

`Enter` or `Space`  刷新(Refresh-Display)

`?` or `h`  帮助命令，显示在 top 当中可以输入的按键指令；(Press 'h' or '?' for help with Windows)

`P` 以 CPU 的使用资源排序显示；

`M` 以 Memory 的使用资源排序显示；

`N` 以 PID 来排序喔！

`T` 由该 Process 使用的 CPU 时间累积 (TIME+) 排序。

`k` 给予某个 PID 一个讯号(signal)。默认排第一的程序

```bash
PID to signal/kill [default pid = 5859] 
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                       
   5859 root      20   0   24.7g 119956  78288 S   5.9   0.7  50:28.52 Xorg 
# after type ENTER
   Send pid 5859 signal [15/sigterm]
```

`r` 给予某个 PID 重新制订一个 nice 值(Renice-a-Task)。

`d` 重设一个画面刷新间隔秒数 (Change-Delay-Time-interval)

`q` 离开 top 软件的按键。(Quit)

## Reference

1. top - display Linux processes <https://www.man7.org/linux/man-pages/man1/top.1.html>
2. 《鸟哥的 Linux 私房菜》