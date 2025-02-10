---
title: ARP（地址解析协议）
categories: [Uncategorized]
tags: [Uncategorized]
toc: true
media_subpath: 
---

ARP -> Address Resolution Protocol

地址解析协议（ARP）是将不断变化的Internet协议（IP）地址连接到局域网（LAN）中的固定物理机地址（也称为媒体访问控制（MAC）地址）的协议或过程。 此映射过程很重要，因为IP和MAC地址的长度不同，并且需要进行转换，以便系统可以相互识别。目前最常用的IP是IP版本4（IPv4）。IP地址的长度为32位。但是，MAC地址的长度为48位。ARP将32位地址转换为48，反之亦然。 Q: man

Ans:MAC 地址（Media Access Control Address），直译为媒体存取控制位址，也称为局域网地址（LAN Address），MAC 位址，以太网地址（Ethernet Address）或物理地址（Physical Address），它是一个用来确认网络设备位置的地址。

ARP 协议的全称是 Address Resolution Protocol（地址解析协议），它是一个通过用于实现从 IP 地址到 MAC 地址的映射，即询问目标 IP 对应的 MAC 地址 的一种协议。ARP 协议在 IPv4 中极其重要。

- **注意：**ARP 只用于 IPv4 协议中，IPv6 协议使用的是 Neighbor Discovery Protocol，译为邻居发现协议，它被纳入 ICMPv6 中。
- 简而言之，ARP 就是一种解决地址问题的协议，它以 IP 地址为线索，定位下一个应该接收数据分包的主机 MAC 地址。如果目标主机不在同一个链路上，那么会查找下一跳路由器的 MAC 地址。

![img](https://fpfl3bbe49.feishu.cn/space/api/box/stream/download/asynccode/?code=ZDhhOTEwY2Y2YzY3M2E5ZWIyYjFmMGMwMzY2MTIwOGNfbVNiSTZCRklvT1lmdzVvcENCbFhiejJaSGNPNjJkbEJfVG9rZW46UXFjUWJqakxrb0hOY254STVac2NuUGI3bmtoXzE3Mjk0MDE0NjI6MTcyOTQwNTA2Ml9WNA)

![img](https://fpfl3bbe49.feishu.cn/space/api/box/stream/download/asynccode/?code=YWU5NTUxYmUxOGQ5YzY4Mjc4MzNiOWE0YTIyOTU4NGVfZ29wbDE0RlhXcWJVN1ZvOXFpY01wOFI4VjI0a2M2TmRfVG9rZW46TG11Q2JUOHlDb3BFWkR4b3M3Q2NsWVU2blFoXzE3Mjk0MDE0NjI6MTcyOTQwNTA2Ml9WNA)

ARP是做什么的，如何工作的？ 当新计算机加入局域网（LAN）时，它将收到一个唯一的IP地址，用于标识和通信。 数据包到达网关，发往特定主机。网关或网络上允许数据从一个网络流向另一个网络的硬件要求ARP程序查找与IP地址匹配的MAC地址。ARP缓存保留每个IP地址及其匹配的MAC地址的列表。ARP缓存是动态的，但网络上的用户也可以配置包含IP地址和MAC地址的静态ARP表。 ARP缓存保存在IPv4以太网网络中的所有操作系统上。每次设备请求MAC地址将数据发送到连接到LAN的另一台设备时，设备都会验证其ARP缓存以查看IP到MAC地址连接是否已完成。如果存在，则不需要新请求。但是，如果尚未执行转换，则会发送网络地址请求，并执行ARP。 ARP缓存大小受设计限制，地址往往只在缓存中保留几分钟。它会定期清除以释放空间。此设计还旨在保护隐私和安全，以防止IP地址

在使用 TCP/IP 协议的电脑或路由器里都有一个 ARP 缓存表，表里的 IP 地址与 MAC 地址是一对应的，如下表所示。

| Host  | Address        | HWaddress         |
| ----- | -------------- | ----------------- |
| HostA | 192.168.3.1    | b8:3a:08:0d:70:58 |
| HostB | 169.254.73.152 | 00:11:22:33:44:55 |

```Bash
➜  ~ arp -h
Usage:
  arp [-vn]  [<HW>] [-i <if>] [-a] [<hostname>]             <-Display ARP cache
  arp [-v]          [-i <if>] -d  <host> [pub]               <-Delete ARP entry
  arp [-vnD] [<HW>] [-i <if>] -f  [<filename>]            <-Add entry from file
  arp [-v]   [<HW>] [-i <if>] -s  <host> <hwaddr> [temp]            <-Add entry
  arp [-v]   [<HW>] [-i <if>] -Ds <host> <if> [netmask <nm>] pub          <-''-

        -a                       display (all) hosts in alternative (BSD) style
        -e                       display (all) hosts in default (Linux) style
        -s, --set                set a new ARP entry
        -d, --delete             delete a specified entry
        -v, --verbose            be verbose
        -n, --numeric            don't resolve names
        -i, --device             specify network interface (e.g. eth0)
        -D, --use-device         read <hwaddr> from given device
        -A, -p, --protocol       specify protocol family
        -f, --file               read new entries from file or from /etc/ethers

  <HW>=Use '-H <hw>' to specify hardware address type. Default: ether
  List of possible hardware types (which support ARP):
    ash (Ash) ether (Ethernet) ax25 (AMPR AX.25) 
    netrom (AMPR NET/ROM) rose (AMPR ROSE) arcnet (ARCnet) 
    dlci (Frame Relay DLCI) fddi (Fiber Distributed Data Interface) hippi (HIPPI) 
    irda (IrLAP) x25 (generic X.25) eui64 (Generic EUI-64) 
➜  ~ 
```

打印当前的arp表

```Bash
➜  ~ arp       
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.3.1              ether   b8:3a:08:0d:70:58   C                     eth3
169.254.73.152           ether   00:11:22:33:44:55   CM                    loopback0
➜  ~ 
```

指定interface，-i

```Bash
➜  ~ arp -i eth3
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.3.1              ether   b8:3a:08:0d:70:58   C                     eth3
➜  ~ arp -i loopback0
Address                  HWtype  HWaddress           Flags Mask            Iface
169.254.73.152           ether   00:11:22:33:44:55   CM                    loopback0
➜  ~
```

查看arp缓存表

```Bash
➜  ~ arp -a          
? (192.168.3.1) at b8:3a:08:0d:70:58 [ether] on eth3
? (169.254.73.152) at 00:11:22:33:44:55 [ether] PERM on loopback0
➜  ~ 
```

查看arp缓存表的详细信息

```Bash
➜  ~ arp -nv
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.3.1              ether   b8:3a:08:0d:70:58   C                     eth3
169.254.73.152           ether   00:11:22:33:44:55   CM                    loopback0
Entries: 2        Skipped: 0        Found: 2
➜  ~
```
