---
title: Top 命令
categories:
  - Linux
tags:
  - Linux
toc: true
---
# Top 命令

## man top

Docs <https://man7.org/linux/man-pages/man1/top.1.html>

## top 然后按下h

![Help for Interactive Commands](/assets/images/TopImages/help.png)

## SUMMARY Display

这块就是顶部信息的含义

```terminal
top - 11:25:31 up 1 day,  1:15,  1 user,  load average: 2.81, 1.98, 1.86
Tasks: 527 total,   2 running, 523 sleeping,   0 stopped,   2 zombie
%Cpu(s):  3.3 us,  2.0 sy,  2.2 ni, 91.9 id,  0.5 wa,  0.0 hi,  0.1 si,  0.0 st
MiB Mem :  15712.8 total,    652.8 free,   9137.5 used,   5922.5 buff/cache
MiB Swap:  16212.0 total,  13956.2 free,   2255.8 used.   3878.9 avail Mem 
```

### UPTIME and LOAD Averages

第1行字段分别表示，这些字段用逗号分隔

- 当前时间 & 系统已运行时间 `11:25:31 up 1 day` 
- 当前登录用户的数量 `1 user`
- 相应最近1、5和15分钟内的系统平均负载 `load average: 2.81, 1.98, 1.86`

其实第一行的内容类似命令`uptime`的输出信息

```terminal
 11:26:43 up 1 day,  1:17,  1 user,  load average: 2.66, 2.10, 1.91
```

![uptime](/assets/images/TopImages/uptime.png)

### TASK and CPU States

第2行显示的是任务或者进程的总结，进程可以处于不同的状态。

```terminal
Tasks: 527 total,   1 running, 524 sleeping,   0 stopped,   2 zombie
```

- 全部进程的数量 `527 total`
- 正在运行的进程数量 `1 running`
- 处于睡眠状态的进程数量 `524 sleeping`
- 处于暂停或者跟踪状态stopped `0 stopped`
- 僵尸进程的数量 `2 zombie`

这些进程概括信息可以用’t’切换显示。

第3行显示的是CPU状态，这里显示了不同模式下的所占CPU时间的百分比。这些不同的CPU时间表示

```terminal
%Cpu(s):  5.3 us,  1.9 sy,  0.6 ni, 91.8 id,  0.3 wa,  0.0 hi,  0.1 si,  0.0 st
```

us, user： 运行(未调整优先级的) 用户进程的CPU时间

sy, system: 运行内核进程的CPU时间

ni, niced：运行已调整优先级的用户进程的CPU时间

`wa,` IO wait 用于等待IO完成的CPU时间

`hi`处理硬件中断的CPU时间

si: 处理软件中断的CPU时间

st：这个虚拟机被hypervisor偷去的CPU时间（译注：如果当前处于一个hypervisor下的vm，实际上hypervisor也是要消耗一部分CPU处理时间的）。

us, user    : time running un-niced user processes

sy, system  : time running kernel processes

ni, nice    : time running niced user processes

id, idle    : time spent in the kernel idle handler

wa, IO-wait : time waiting for I/O completion

hi : time spent servicing hardware interrupts

si : time spent servicing software interrupts

st : time stolen from this vm by the hypervisor

### MEMORY Usage

```terminal
MiB Mem :  15712.8 total,    652.8 free,   9137.5 used,   5922.5 buff/cache
MiB Swap:  16212.0 total,  13956.2 free,   2255.8 used.   3878.9 avail Mem 
```

## FIELDS / Columns

字段/列，在横向列出的系统属性和状态下面，是以列显示的进程。不同的列代表下面要解释的不同属性。

1. PID【进程id】
2. USER【进程所有者的用户名】      
3. PR【优先级】  
4. NI【nice值】    
5. VIRT【进程使用的虚拟内存总量】    
6. RES【进程使用的、未被换出的物理内存大小】   
7. SHR【共享内存大小】 
8. S【进程状态】 
9. %CPU【上次更新到现在的CPU时间占用百分比】 
10. %MEM【进程使用的物理内存百分比】     
11. TIME+【进程使用的CPU时间总计】 
12. COMMAND【命令名/命令行】 

| 列名    | 含义                                                         |
| ------- | ------------------------------------------------------------ |
| PID     | 进程 ID                                                      |
| PPID    | 父进程 ID                                                    |
| RUSER   | Real user name                                               |
| UID     | 进程所有者的用户 ID                                          |
| USER    | 进程所有者的用户名                                           |
| GROUP   | 进程所有者的组名                                             |
| TTY     | 启动进程的终端名。不是从终端启动的进程则显示为？             |
| PR      | 优先级                                                       |
| NI      | nice 值。负值表示高优先级，正值表示低优先级                  |
| P       | 最后使用的 CPU，仅在多 CPU 环境下有意义                      |
| %CPU    | 上次更新到现在的 CPU 时间占用百分比                          |
| TIME    | 进程使用的 CPU 时间总计，单位秒                              |
| TIME+   | 进程使用的 CPU 时间总计，单位 1/100 秒                       |
| %MEM    | 进程使用的物理内存百分比                                     |
| VIRT    | 进程使用的虚拟内存总量，单位 kb。VIRT=SWAP+RES               |
| SWAP    | 进程使用的虚拟内存中，被换出的大小，单位 kb。                |
| RES     | 进程使用的、未被换出的物理内存大小，单位 kb。RES=CODE+DATA   |
| CODE    | 可执行代码占用的物理内存大小，单位 kb                        |
| DATA    | 可执行代码以外的部分 (数据段 + 栈) 占用的物理内存大小，单位 kb |
| SHR     | 共享内存大小，单位 kb                                        |
| nFLT    | 页面错误次数                                                 |
| nDRT    | 最后一次写入到现在，被修改过的页面数。                       |
| S       | 进程状态。 D = 不可中断的睡眠状态 R = 运行 S = 睡眠 T = 跟踪 / 停止 Z = 僵尸进程 |
| COMMAND | 命令名 / 命令行                                              |
| WCHAN   | 若该进程在睡眠，则显示睡眠中的系统函数名                     |
| Flags   | 任务标志，参考 sched.h                                       |