---
title: 了解 Web 及网络基础
date: 2023-06-10 21:09:00 +0800
author: 
categories: [Computer Networking]
tags: [Computer Networking]
pin: false
math: false
mermaid: false
---

## TCP/IP 的分层管理

TCP/IP 协议族最重要的一点就是分层！ 应用层、传输层、网络层、数据链路层

| 应用层 | 决定了向用户提供应用服务时通信的活动                       | FTP(File Transfer Protocol), DNS(Domain Name System), HTTP  |
| ------ | ---------------------------------------------------------- | ----------------------------------------------------------- |
| 传输层 | 对上层应用层，提供处于网络连接中的两台计算机之间的数据传输 | TCP(Transmission Control Protocol), UDP(User Data Protocol) |
| 网络层 | 处理在网络上流动的数据包                                   |                                                             |
| 链路层 | 处理连接网络的硬件部分                                     |                                                             |

## 与 HTTP 关系密切的协议：IP、TCP、DNS

- IP Internet Protocol 网际协议

  网际协议位于网络层。

  作用是将各种数据包传送给对方。IP 地址指明了节点被分配到的地址，MAC 地址是指网卡所属的固定地址。IP 地址可以和 MAC 地址进行配对。但 MAC 地址基本上不会更改。

  **使用 ARP 协议凭借 MAC 地址进行通信**

  IP 间的通信依赖 MAC 地址。通常会经过多台计算机和网络设备中转才能到下一个目标，这时会采用 ARP 协议（Address Resolution Protocol）。ARP 是一种用以解析地址的协议，根据通信方的 IP 可以反查出对应的 MAC 地址。

  在到达通信目标前的中转过程中，那些计算机和路由器等网络设备只能获悉很粗略的传输路线。这种机制称为路由选择（routing）。

- 确保可靠性的 TCP 协议

  按照层次分，TCP 位于传输层，提供**可靠**的**字节**流服务。

  1. 所谓的字节流服务（Byte Stream Service）是指，为了方便传输，将大块数据分割成报文段（segment）为单位的数据包进行管理。
  2. 可靠的传输服务是指，能够把数据准确可靠地传给对方。

  TCP 协议采用三次握手（three-way handshaking）策略，保证数据准确无误送达。会和对方确认是否发送成功。

  握手过程中使用了 TCP 地标志（flag）——SYN（synchronize）和ACK（acknowledgement）

  发送端首先发送一个带 SYN 标志地数据包给对方。接收端收到后，回传一个带有 SYN/ACK 标志地数据包以表示传达确认信息。最后，发送端再回传一个带 ACK 标志地数据包，代表“握手”结束。

  如果握手过程中断，TCP 会再按照相同顺序发送相同数据包。

- 负责域名解析的 DNS 服务

  DNS Domain Name System 一样位于应用层。提供域名到 IP 地址之间的解析服务。

## URI & URL

URI Uniform Resource Identifier 统一资源标识符

URL Uniform Resource Locator 统一资源定位符

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/991e0305-c40c-41be-ae37-1167a0cfb795/Untitled.png)

区别：URI 用字符串标识某一互联网资源，而 URL 表示资源的地点（互联网上所处的位置）。可见 URL 是 URI 的子集。