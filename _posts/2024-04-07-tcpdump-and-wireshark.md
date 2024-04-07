---
title: tcpdump & wireshark
date: 2024-04-07 21:09:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
img_path: /assets/images/2024-04-07-tcpdump-and-wireshark
---

找到一个网站 <https://www.tcpdump.org/>

## tcpdump 原理

如图

![img](BPF.png)

## tcpdump 的基本用法

Docs <https://linux.die.net/man/8/tcpdump>

### 抓取报文？

用 tcpdump 抓取报文，最常见的场景是要抓取去往某个 ip，或者从某个 ip 过来的流量。我们可以用 host {对端 IP} 作为抓包过滤条件，比如：

```bash
# tcpdump host 192.16.10.113 -i wlp0s20f3
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlp0s20f3, link-type EN10MB (Ethernet), capture size 262144 bytes
...
```

> 需要指定哪个网卡 -i interface 不然默认第一个网卡
{: .prompt-tip }

Print the list of the network interfaces available on the system and on  which  tcp‐dump  can  capture  packets.

```bash
# tcpdump --list-interfaces
1.docker0 [Up, Running]
2.enx207bd2697db1 [Up, Running]
3.wlp0s20f3 [Up, Running]
4.utun7 [Up, Running]
5.vetha1ee81b [Up, Running]
6.lo [Up, Running, Loopback]
7.any (Pseudo-device that captures on all interfaces) [Up, Running]
8.bluetooth-monitor (Bluetooth Linux Monitor) [none]
9.nflog (Linux netfilter log (NFLOG) interface) [none]
10.nfqueue (Linux netfilter queue (NFQUEUE) interface) [none]
11.bluetooth0 (Bluetooth adapter number 0) [none]
```

另一个常见的场景是抓取某个端口的流量，比如，我们想抓取 SSH 的流量，那么可以这样：

```bash
# tcpdump port 22 -i enx207bd2697db1
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enx207bd2697db1, link-type EN10MB (Ethernet), capture size 262144 bytes
...
```

还有不少参数我们也经常用到，比如：

- `-w` 文件名，可以把报文保存到文件；
- `-c` 数量，可以抓取固定数量的报文，这在流量较高时，可以避免一不小心抓取过多报文；
- `-s` 长度，可以只抓取每个报文的一定长度，后面我会介绍相关的使用场景；
- `-n`，不做地址转换（比如 IP 地址转换为主机名，port 80 转换为 http）；
- `-v/-vv/-vvv`，可以打印更加详细的报文信息；
- `-e`，可以打印二层信息，特别是 MAC 地址；
- `-p`，关闭混杂模式。所谓混杂模式，也就是嗅探（Sniffering），就是把目的地址不是本机地址的网络报文也抓取下来。

还有一个`-X`参数：

-X     When parsing and printing, in addition to printing the headers of each packet, print the  data  of  each  packet (minus its link level header) in hex and ASCII.  This is very handy for analysing new protocols.

看下抓取到的报文`-w`输出出来的文件：

```bash
# tcpdump port 22 -i enx207bd2697db1 -X -w enx.pcap

# cat enx.pcap 
�ò�f~�<< {�i}����EH(��@@�#��F����ѳ��CFg�P�P�f��66���F {�i}E(l�@@I������F�CFg�ѳ��P���f�::���E {�i}E,96�@@�'��E�����[]��mCP�Wifr�vv���E {�i}Eh97@@|������E���mC[]�P���6j��4���Mb�~B�Z�B��)�&0��cI�ո�y�aGBjyO�@@����E�����[]��m�P�ܰq��\�$�+�(p�Y�}���^,�W�P�i�>,�Sڊ7ʂ��T�f־66���E {�i}E(98@@}�����E���m�[^!P���

# file enx.pcap 
enx.pcap: pcap capture file, microsecond ts (little-endian) - version 2.4 (Ethernet, capture length 262144)
```

### 过滤报文？

抓包的精髓：**报文量偏移的方法**

最近我们有个实际的需求，要统计我们某个 HTTPS VIP 的访问流量里，TLS 版本（现在主要是 TLS1.0、1.1、1.2、1.3）的分布。为了控制抓包文件的大小，我们又不想什么 TLS 报文都抓，只想抓取 TLS 版本信息。这该如何做到呢？要知道，针对这个需求，tcpdump 本身没有一个现成的过滤器。

其实，BPF 本身是基于偏移量来做报文解析的，所以我们也可以在 tcpdump 中使用这种偏移量技术，实现我们的需求。下面这个命令，就可以抓取到 TLS 握手阶段的 Client Hello 报文：

```bash
tcpdump -w file.pcap 'dst port 443 && tcp[20]==22 && tcp[25]==1' -i wlp0s20f3
```

用 Wireshark 来看抓到的报文

```bash
wireshark file.pcap
```

![img](handshake.png)

我给你解释一下上面的三个过滤条件。

- `dst port 443`：这个最简单，就是抓取从客户端发过来的访问 HTTPS 的报文。
- `tcp[20]==22`：这是提取了 TCP 的第 21 个字节（因为初始序号是从 0 开始的），由于 TCP 头部占 20 字节，TLS 又是 TCP 的载荷，那么 TLS 的第 1 个字节就是 TCP 的第 21 个字节，也就是 TCP[20]，这个位置的值如果是 22（十进制），那么就表明这个是 TLS 握手报文。
- `tcp[25]==1`：同理，这是 TCP 头部的第 26 个字节，如果它等于 1，那么就表明这个是 Client Hello 类型的 TLS 握手报文。

![img](offset.png)

还好，不是每个过滤条件都要这么“艰难”的。对一些常见的过滤场景，tcpdump 也预定义了一些相对方便的过滤器。比如**我们想要过滤出 TCP RST 报文**，那么可以用下面这种写法，相对来说比用数字做偏移量的写法，要更加容易理解和记忆：

```bash
tcpdump -w file.pcap 'tcp[tcpflags]&(tcp-rst) != 0' -i wlp0s20f3
```

如果是用偏移量的写法，会是下面这样：

```bash
tcpdump -w file.pcap 'tcp[13]&4 != 0' -i wlp0s20f3
```

用 Wireshark 来看抓到的报文：`wireshark file.pcap`

![img](rst.png)

- tcpdump 抓取 TCP SYN 包的过滤方法

```bash
tcpdump 'tcp[13] = 2' -w file.pcap
tcpdump host xxxx and 'tcp[tcpflags] == tcp-syn' -w file.pcap
```

- 确定命令在 IP 层，tcpdump 怎么写，既可以找到 IP 层的问题，又节约抓包大小呢？

```bash
tcpdump -s 34 -w file.pcap 
```

### 在抓包时显示报文内容？

有时候你想看 TCP 报文里面的具体内容，比如应用层的数据，那么你可以用 -X 这个参数，以 ASCII 码来展示 TCP 里面的数据：

```bash
tcpdump port 80 -X  -i wlp0s20f3
```

### 读取抓包文件？

这个比较简单，tcpdump 加上 -r 参数和文件名称，就可以读取这个文件了，而且也可以加上过滤条件。比如：

```bash
tcpdump -r file.pcap 'tcp[tcpflags]&(tcp-rst) != 0'
```

### 过滤后再转存下来？

有时候，我们想从抓包文件中过滤出想要的报文，并转存到另一个文件中。比如想从一个抓包文件中找到 TCP RST 报文，并把这些 RST 报文保存到新文件。那么就可以这么做：

```bash
tcpdump -r file.pcap 'tcp[tcpflags]&(tcp-rst) != 0' -w rst.pcap
```

### 让抓包时间尽量延长一点？

我们给 tcpdump 加上 -s 参数，指定抓取的每个报文的最大长度，就节省抓包文件的大小，也就延长了抓包时间。

一般来说，帧头是 14 字节，IP 头是 20 字节，TCP 头是 20~40 字节。如果你明确地知道这次抓包的重点是传输层，那么理论上，对于每一个报文，你只要抓取到传输层头部即可，也就是前 14+20+40 字节（即前 74 字节）：

```bash
tcpdump -s 74 -w file.pcap
```

## Wireshark 使用

![img](wireshark.png)