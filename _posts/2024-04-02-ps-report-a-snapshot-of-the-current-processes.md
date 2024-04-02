---
title: ps 将某个时间点的进程运作情况撷取下来
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
---

## Overview

观察系统所有的进程数据

```bash
ps aux
```

也是能够观察所有系统的数据

```bash
ps -lA
```

连同部分进程树状态

```bash
ps axjf
```

选项与参数：

`-A`  所有的 process 均显示出来，与 `-e` 具有同样的效用；

`-a`  不与 terminal 有关的所有 process ；

`-u`  有效使用者 (effective user) 相关的 process ；

`x`  通常与 a 这个参数一起使用，可列出较完整信息。

输出格式规划：

`l`  较长、较详细的将该 PID 的的信息列出；

`j`  工作的格式 (jobs format)

`-f`  做一个更为完整的输出。

## 仅观察自己的 bash 相关进程： `ps -l`

```bash
F S   UID     PID    PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
0 S  1001  377843  377834  0  80   0 -  3650 do_wai pts/2    00:00:00 bash
4 R  1001 1326142  377843  0  80   0 -  3624 -      pts/2    00:00:00 ps
```

F：代表这个进程旗标 (process flags)，说明这个进程的总结权限，常见号码有：

- 若为 4 表示此进程的权限为 root ；
- 若为 1 则表示此子进程仅进行复制(fork)而没有实际执行(exec)。

S：代表这个进程的状态 (STAT)，主要的状态有：

- R (Running)：该程序正在运作中；
- S (Sleep)：该程序目前正在睡眠状态(idle)，但可以被唤醒(signal)。
- D ：不可被唤醒的睡眠状态，通常这支程序可能在等待 I/O 的情况(ex>打印)
- T ：停止状态(stop)，可能是在工作控制(背景暂停)或除错 (traced) 状态；
- Z (Zombie)：僵尸状态，进程已经终止但却无法被移除至内存外。
- UID/PID/PPID：代表『此进程被该 UID 所拥有/进程的 PID 号码/此进程的父进程 PID 号码』
- C：代表 CPU 使用率，单位为百分比；
- PRI/NI： Priority/Nice 的缩写，代表此进程被 CPU 所执行的优先级，数值越小代表该进程越快被 CPU 执行。

详细的 PRI 与 NI 将在下一小节说明。

ADDR/SZ/WCHAN：都与内存有关，ADDR 是 kernel function，指出该进程在内存的哪个部分，如果是个 running 的进程，一般就会显示『 - 』 / SZ 代表此进程用掉多少内存 / WCHAN 表示目前进程是否运作中，同样的， 若为 - 表示正在运作中。

TTY：登入者的终端机位置，若为远程登录则使用动态终端接口 (pts/n)；

TIME：使用掉的 CPU 时间，注意，是此进程实际花费 CPU 运作的时间，而不是系统时间；

CMD：就是 command 的缩写，造成此进程的触发程序之指令为何。

所以你看到的 ps -l 输出讯息中，他说明的是：『bash 的程序属于 UID 为 0 的使用者，状态为睡眠 (sleep)， 之所以为睡眠因为他触发了 ps (状态为 run) 之故。此进程的 PID 为 14836，优先执行顺序为 80 ， 下达 bash 所取得的终端接口为 pts/0 ，运作状态为等待 (wait) 。』

## 观察系统所有进程： `ps aux`

```bash
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.2  0.0 171092 11420 ?        Ss   Mar30   6:41 /sbin/init splash
root           2  0.0  0.0      0     0 ?        S    Mar30   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        I<   Mar30   0:00 [rcu_gp]
root           4  0.0  0.0      0     0 ?        I<   Mar30   0:00 [rcu_par_gp]
root           5  0.0  0.0      0     0 ?        I<   Mar30   0:00 [slub_flushwq]
root           6  0.0  0.0      0     0 ?        I<   Mar30   0:00 [netns]
root           8  0.0  0.0      0     0 ?        I<   Mar30   0:00 [kworker/0:0H-events_highpri]
root          10  0.0  0.0      0     0 ?        I<   Mar30   0:00 [mm_percpu_wq]
root          11  0.0  0.0      0     0 ?        S    Mar30   0:00 [rcu_tasks_rude_]
```

在 ps aux 显示的项目中，各字段的意义为：

USER：该 process 属于那个使用者账号的？

PID ：该 process 的进程标识符。

%CPU：该 process 使用掉的 CPU 资源百分比；

%MEM：该 process 所占用的物理内存百分比；

VSZ ：该 process 使用掉的虚拟内存量 (Kbytes)

RSS ：该 process 占用的固定的内存量 (Kbytes)

TTY ：该 process 是在那个终端机上面运作，若与终端机无关则显示 ?，另外， tty1-tty6 是本机上面的登入者进程，若为 pts/0 等等的，则表示为由网络连接进主机的进程。

STAT：该进程目前的状态，状态显示与 ps -l 的 S 旗标相同 (R/S/T/Z)

START：该 process 被触发启动的时间；

TIME ：该 process 实际使用 CPU 运作的时间。

COMMAND：该进程的实际指令为何？

## 观察系统所有进程： `ps -lA`

```bash
F S   UID     PID    PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
4 S     0       1       0  0  80   0 - 42773 -      ?        00:06:46 systemd
1 S     0       2       0  0  80   0 -     0 -      ?        00:00:00 kthreadd
1 I     0       3       2  0  60 -20 -     0 -      ?        00:00:00 rcu_gp
1 I     0       4       2  0  60 -20 -     0 -      ?        00:00:00 rcu_par_gp
1 I     0       5       2  0  60 -20 -     0 -      ?        00:00:00 slub_flushwq
1 I     0       6       2  0  60 -20 -     0 -      ?        00:00:00 netns
1 I     0       8       2  0  60 -20 -     0 -      ?        00:00:00 kworker/0:0H-events_highpri
1 I     0      10       2  0  60 -20 -     0 -      ?        00:00:00 mm_percpu_wq
1 S     0      11       2  0  80   0 -     0 -      ?        00:00:00 rcu_tasks_rude_
```

会发现每个字段与 ps -l 的输出情况相同，但显示的进程则包括系统所有的进程。

## 列出类似进程树的进程显示：`ps axjf`

```bash
   PPID     PID    PGID     SID TTY        TPGID STAT   UID   TIME COMMAND
      0       2       0       0 ?             -1 S        0   0:00 [kthreadd]
      2       3       0       0 ?             -1 I<       0   0:00  \_ [rcu_gp]
      2       4       0       0 ?             -1 I<       0   0:00  \_ [rcu_par_gp]
      2       5       0       0 ?             -1 I<       0   0:00  \_ [slub_flushwq]
      2       6       0       0 ?             -1 I<       0   0:00  \_ [netns]
      2       8       0       0 ?             -1 I<       0   0:00  \_ [kworker/0:0H-events_highpri]
      2      10       0       0 ?             -1 I<       0   0:00  \_ [mm_percpu_wq]
      2      11       0       0 ?             -1 S        0   0:00  \_ [rcu_tasks_rude_]
      2      12       0       0 ?             -1 S        0   0:00  \_ [rcu_tasks_trace]
```

其实还可以使用 pstree 来达成这个进程树

## 找出与 cron 与 rsyslog 这两个服务有关的 PID 号码

```bash
root        1307  0.0  0.0  12500  3192 ?        Ss   Mar30   0:00 /usr/sbin/cron -f
syslog      1337  0.0  0.0 233984  4120 ?        Ssl  Mar30   0:50 /usr/sbin/rsyslogd -n -iNONE
riske    1699090  0.0  0.0  12120  2692 pts/3    S+   11:04   0:00 grep -E --color=auto (cron|rsyslog)
```

> egrep -> grep -E 正则表达式 **E**xtended **G**lobal **R**egular **E**xpression **P**rint
>
> 使用`.`匹配任意字符，`*`匹配零个或多个前导字符，`|`表示或逻辑等
>
> { }

## 僵尸 (zombie)

我们必须要知道的是『僵尸 (zombie) 』进程是什么？ 通常，造成僵尸进程的成因是因为该进程应该已经执行完毕，或者是因故应该要终止了， 但是该进程的父进程却无法完整的将该进程结束掉，而造成那个进程一直存在内存当中。 如果你发现在某个进程的 CMD 后面还接上<defunct> 时，就代表该进程是僵尸进程啦。

```bash
# ps aux | grep defunct
riske       5955  0.0  0.0      0     0 tty2     Z+   Mar30   0:00 [xbrlapi] <defunct>
riske       5995  0.0  0.0      0     0 tty2     Z+   Mar30   0:00 [fcitx] <defunct>
riske     533874  0.0  0.0      0     0 ?        Z    Mar30   0:00 [createThumbnail] <defunct>
riske    1407445  0.0  0.0      0     0 ?        Z    Mar31   0:00 [createThumbnail] <defunct>
riske    1656742  0.0  0.0  12120  2592 pts/3    S+   11:01   0:00 grep --color=auto defunct
```

## Reference

1. ps - report a snapshot of the current processes. <https://www.man7.org/linux/man-pages/man1/ps.1.html>
2. 《鸟哥的 Linux 私房菜》