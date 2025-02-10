---
title: 系统资源的观察
date: 2024-04-03 21:09:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
media_subpath: 
---

## free ：观察内存使用情况

```bash
free [-b|-k|-m|-g|-h] [-t] [-s N -c N]
```

选项与参数：

`-b` 直接输入 free 时，显示的单位是 Kbytes，我们可以使用 b(bytes), m(Mbytes), k(Kbytes), 及 g(Gbytes) 来显示单位喔！也可以直接让系统自己指定单位 (-h)

`-t` 在输出的最终结果，显示物理内存与 swap 的总量。

`-s` 可以让系统每几秒钟输出一次，不间断的一直输出的意思！对于系统观察挺有效！

`-c` 与 `-s` 同时处理，让 free 列出几次的意思～

输出：

```bash
# free
              total        used        free      shared  buff/cache   available
Mem:       16089808     7663140      998140      618292     7428528     7471676
Swap:      16601084     3297024    13304060

# free -h
              total        used        free      shared  buff/cache   available
Mem:           15Gi       7.3Gi       996Mi       613Mi       7.1Gi       7.1Gi
Swap:          15Gi       3.1Gi        12Gi
```

## uname：查阅系统与核心相关信息

```bash
uname [-asrmpi]
```

`uname` - print system information

```bash
# uname -a
Linux cn3614001063l 5.15.0-100-generic #110~20.04.1-Ubuntu SMP Tue Feb 13 14:25:03 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
```

选项与参数：

`-a` 所有系统相关的信息，包括底下的数据都会被列出来；

`-s` 系统核心名称

`-r` 核心的版本

`-m` 本系统的硬件名称，例如 i686 或 x86_64 等；

`-p` CPU 的类型，与 -m 类似，只是显示的是 CPU 的类型！

`-i` 硬件的平台 (ix86)

## uptime：观察系统启动时间与工作负载

`uptime` - Tell how long the system has been running.

uptime gives a one line display of the following information.  The current time, how long the system has been running,  how  many  users  are currently  logged  on,  and the system load averages for the past 1, 5, and 15 minutes.

```bash
 # uptime
 09:09:24 up 15:46,  1 user,  load average: 2.27, 2.23, 1.62
```

## netstat ：追踪网络或插槽文件

```bash
netstat -[atunlp]
```

选项与参数：

`-a` 将目前系统上所有的联机、监听、Socket 数据都列出来

`-t` 列出 tcp 网络封包的数据

`-u` 列出 udp 网络封包的数据

`-n` 不以进程的服务名称，以埠号 (port number) 来显示；

`-l` 列出目前正在网络监听 (listen) 的服务；

`-p` 列出该网络服务的进程 PID

### 列出已经建立的网络联机与 unix socket 状态

```bash
netstat
```

输出

```bash
# netstat
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 localhost:54542         localhost:56630         TIME_WAIT  
tcp        0      0 localhost:45410         localhost:56630         TIME_WAIT  
tcp        0      1 riskedesktope:40674     198.18.0.2:9080         SYN_SENT   
tcp        0      0 riskedesktope:51600     98.230.126.124.broa:441 TIME_WAIT  
tcp        0      0 riskedesktope:36050     36.110.162.63:https     ESTABLISHED
tcp        0      0 localhost:43060         localhost:56630         TIME_WAIT  
tcp        0      0 localhost:57630         localhost:60390         ESTABLISHED
tcp        0      0 riskedesktope:51018     42.194.191.45:https     ESTABLISHED
tcp        0      0 localhost:45426         localhost:56630         TIME_WAIT  
tcp        0      0 riskedesktope:58834     static-bbs-61-146-:1942 TIME_WAIT  
tcp        0      0 localhost:49114         localhost:56630         ESTABLISHED
tcp        0      0 localhost:52976         localhost:56630         TIME_WAIT  
tcp        0      1 riskedesktope:55268     static-bbs-61-146-:1942 FIN_WAIT1  
tcp        0      0 riskedesktope:39648     116.246.1.249:1942      TIME_WAIT  
tcp        0      0 localhost:36826         localhost:56630         TIME_WAIT  
```

与网络较相关的部分

1. Proto ：网络的封包协议，主要分为 TCP 与 UDP 封包，相关资料请参考服务器篇；
2. Recv-Q：非由用户程序链接到此 socket 的复制的总 bytes 数；
3. Send-Q：非由远程主机传送过来的 acknowledged 总 bytes 数；
4. Local Address ：本地端的 IP:port 情况
5. Foreign Address：远程主机的 IP:port 情况
6. State ：联机状态，主要有建立(ESTABLISED)及监听(LISTEN)；

```bash
Active UNIX domain sockets (w/o servers)
Proto RefCnt Flags       Type       State         I-Node   Path
unix  2      [ ]         DGRAM                    113328   /run/user/1001/systemd/notify
unix  2      [ ]         DGRAM                    48735    /run/user/125/systemd/notify
unix  2      [ ]         STREAM                   28314    @Global\D892D986-A09F-4636-B9FB-B7CE0EF488F3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
unix  2      [ ]         DGRAM                    45580    /run/wpa_supplicant/wlp0s20f3
unix  2      [ ]         DGRAM                    55415    @var/run/nvidia-xdriver-acbafa21@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
unix  2      [ ]         DGRAM      CONNECTED     64642    /var/lib/samba/private/msg.sock/3871
unix  4      [ ]         DGRAM      CONNECTED     31918    /run/systemd/notify
unix  2      [ ]         DGRAM      CONNECTED     55273    /var/lib/samba/private/msg.sock/4700
unix  2      [ ]         DGRAM      CONNECTED     61066    /var/lib/samba/private/msg.sock/4829
unix  2      [ ]         DGRAM                    31944    /run/systemd/journal/syslog
unix  35     [ ]         DGRAM      CONNECTED     31954    /run/systemd/journal/dev-log
unix  9      [ ]         DGRAM      CONNECTED     31958    /run/systemd/journal/socket
unix  2      [ ]         DGRAM      CONNECTED     62121    /var/lib/samba/private/msg.sock/4586
```

除了网络上的联机之外，其实 Linux 系统上面的进程是可以接收不同进程所发送来的信息，那就是

Linux 上头的插槽文件 (socket file)。socket file 可以沟通两个进程之间的信息，因此进程可以取得对方传送过来的资料。 上表中 socket file 的输出字段有：

1. Proto ：一般就是 unix 啦；
2. RefCnt：连接到此 socket 的进程数量；
3. Flags ：联机的旗标；
4. Type ：socket 存取的类型。主要有确认联机的 STREAM 与不需确认的 DGRAM 两种；
5. State ：若为 CONNECTED 表示多个进程之间已经联机建立。
6. Path ：连接到此 socket 的相关程序的路径！或者是相关数据输出的路径。

 PATH 指向的就是这些进程要交换数据的插槽文件（socket）

### 找出已在监听的网络联机及其 PID

```bash
netstat -tulnp
```

输出

```bash
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:5900            0.0.0.0:*               LISTEN      9049/vino-server                   
tcp6       0      0 :::46461                :::*                    LISTEN      71492/xterminal     
tcp6       0      0 :::5900                 :::*                    LISTEN      9049/vino-server    
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           19587/msedge --type 
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           19587/msedge --type 
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           19587/msedge --type 
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           19587/msedge --type 
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           19540/msedge        
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           19540/msedge        
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           19540/msedge        
udp        0      0 224.0.0.251:5353        0.0.0.0:*                           19540/msedge        
udp        0      0 0.0.0.0:5353            0.0.0.0:*                           -                   
udp        0      0 0.0.0.0:5656            0.0.0.0:*                           -                   
udp        0      0 0.0.0.0:15769           0.0.0.0:*                           -                   
udp        0      0 0.0.0.0:56978           0.0.0.0:*                           8560/fcitx          
```

### 打印网络接口

```bash
netstat -i
```

输出

```bash
Kernel Interface table
Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
docker0   1500    23158      0      0 0         28261      0      0      0 BMRU
enx207bd  1500  5370342      0 179063 0       6444967      0      0      0 BMRU
lo       65536  1507796      0      0 0       1507796      0      0      0 LRU
utun7     1500  1672390      0      0 0        608674      0      0      0 MOPRU
vethff7c  1500    23158      0      0 0         28261      0      0      0 BMRU
wlp0s20f  1500  2337246      0      0 0        858897      0      0      0 BMRU
```

## dmesg ：分析核心产生的讯息

系统在开机的时候，核心会去侦测系统的硬件，你的某些硬件到底有没有被捉到，那就与这个时候的侦测有关。 但是这些侦测的过程要不是没有显示在屏幕上，就是很飞快的在屏幕上一闪而逝！

所有核心侦测的讯息，不管是开机时候还是系统运作过程中，反正只要是核心产生的讯息，都会被记录到内存中的某个保护区段。 dmesg 这个指令就能够将该区段的讯息读出来的！

比如如下输出：

```bash
[    0.000000] microcode: microcode updated early to revision 0x4e, date = 2023-09-07
[    0.000000] Linux version 5.15.0-100-generic (buildd@lcy02-amd64-014) (gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #110~20.04.1-Ubuntu SMP Tue Feb 13 14:25:03 UTC 2
024 (Ubuntu 5.15.0-100.110~20.04.1-generic 5.15.143)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.15.0-100-generic root=UUID=0650b271-c3ea-47a6-9670-3657bfb9a096 ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai  
[    0.000000] x86/split lock detection: #AC: crashing the kernel on kernel split_locks and warning on user-space split_locks
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000005f433fff] usable
[    0.000000] BIOS-e820: [mem 0x000000005f434000-0x0000000063510fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000063511000-0x0000000063d71fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000063d72000-0x0000000063ffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000063fff000-0x0000000063ffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000064000000-0x0000000067ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000068400000-0x00000000685fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000068e00000-0x00000000707fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed7ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000048f7fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x5a2d7018-0x5a2e6057] usable ==> usables
```

## vmstat ：侦测系统资源变化

vmstat 可以侦测『 CPU / 内存 / 磁盘输入输出状态 』等等

vmstat reports information about processes, memory, paging, block IO, traps, disks and cpu activity.

1. CPU/内存等信息 `vmstat [-a] [延迟 [总计侦测次数]]`
2. 内存相关 `vmstat [-fs]`
3. 设定显示数据的单位 `vmstat [-S 单位]` 
4. 与磁盘有关 `vmstat [-d]` 
5. 与磁盘有关 `vmstat [-p 分区槽]`

选项与参数：

`-a` 使用 inactive/active(活跃与否) 取代 buffer/cache 的内存输出信息；

`-f` 开机到目前为止，系统复制 (fork) 的进程数；

`-s` 将一些事件 (开机至目前为止) 导致的内存变化情况列表说明；

`-S` 后面可以接单位，让显示的数据有单位。例如 K/M 取代 bytes 的容量；

`-d` 列出磁盘的读写总量统计表

`-p` 后面列出分区槽，可显示该分区槽的读写总量统计表

### 统计目前主机 CPU 状态，每秒一次，共计三次！

```bash
vmstat 1 3
```

输出

```bash
# vmstat 1 3
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0 1697792 665744 583432 4567452    0    2    43    35    2   23  2  1 96  0  0
 0  0 1697792 666336 583448 4582928    0    0     0   168 2871 7308  1  1 98  0  0
 0  0 1697792 666036 583448 4582948   16    0    16     0 2985 7614  1  1 98  0  0
```

那么上面的表格各项字段的意义为何？ 基本说明如下：

#### 进程字段 (procs) 的项目分别为：

r ：等待运作中的进程数量；

b：不可被唤醒的进程数量。这两个项目越多，代表系统越忙碌 (因为系统太忙，所以很多进程就无法被执行或一直在等待而无法被唤醒之故)。

#### 内存字段 (memory) 项目分别为：

swpd：虚拟内存被使用的容量； 

free：未被使用的内存容量； 

buff：用于缓冲存储器； 

cache：用于高速缓存。 这部份则与 free 是相同的。

#### 内存置换空间 (swap) 的项目分别为：

si：由磁盘中将进程取出的量； 

so：由于内存不足而将没用到的进程写入到磁盘的 swap 的容量。 如果 si/so的数值太大，表示内存内的数据常常得在磁盘与主存储器之间传来传去，系统效能会很差！

#### 磁盘读写 (io) 的项目分别为：

bi：由磁盘读入的区块数量； 

bo：写入到磁盘去的区块数量。如果这部份的值越高，代表系统的 I/O 非常忙碌！

#### 系统 (system) 的项目分别为：

in：每秒被中断的进程次数； 

cs：每秒钟进行的事件切换次数；这两个数值越大，代表系统与接口设备的沟通非常频繁！ 这些接口设备当然包括磁盘、网络卡、时间钟等。

#### CPU 的项目分别为：

us：非核心层的 CPU 使用状态； 

sy：核心层所使用的 CPU 状态； 

id：闲置的状态； 

wa：等待 I/O 所耗费的 CPU 状态； 

st：被虚拟机 (virtual machine) 所盗用的 CPU 使用状态。

### 系统上面所有的磁盘的读写状态

```bash
vmstat -d
```

输出

```bash
# vmstat -d
disk- ------------reads------------ ------------writes----------- -----IO------
       total merged sectors      ms  total merged sectors      ms    cur    sec
loop0     14      0      34       0      0      0       0       0      0      0
loop1    304      0    3268      10      0      0       0       0      0      0
loop2    283      0    1750       5      0      0       0       0      0      0
loop3    434      0    3652       9      0      0       0       0      0      0
loop4    459      0   13424      20      0      0       0       0      0      0
loop5    271      0    1696       6      0      0       0       0      0      0
loop6   2629      0   62448     116      0      0       0       0      0      0
loop7    319      0    3268       8      0      0       0       0      0      0
nvme1n1  57463  23635 7538146    7645   6334    303 7887328    4896      0     21
nvme0n1 817195 161632 75467498 1650202 1006837 1055693 59371906 1633686      0   1306
loop9    279      0    1728       8      0      0       
```

## References

1. free - Display amount of free and used memory in the system <https://www.man7.org/linux/man-pages/man1/free.1.html>
2. uname - print system information <https://man7.org/linux/man-pages/man1/uname.1.html>
3. uptime - Tell how long the system has been running. <https://www.man7.org/linux/man-pages/man1/uptime.1.html>
4. netstat - Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships <https://www.man7.org/linux/man-pages/man8/netstat.8.html>
5. dmesg - print or control the kernel ring buffer <https://www.man7.org/linux/man-pages/man1/dmesg.1.html>
6. vmstat - Report virtual memory statistics <https://www.man7.org/linux/man-pages/man8/vmstat.8.html>