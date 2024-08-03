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

| 层次     | 功能描述                                                   | 协议示例                                               |
|----------|------------------------------------------------------------|--------------------------------------------------------|
| **应用层** | 决定了向用户提供应用服务时通信的活动                       | FTP (File Transfer Protocol), DNS (Domain Name System), HTTP |
| **传输层** | 对上层应用层，提供处于网络连接中的两台计算机之间的数据传输 | TCP (Transmission Control Protocol), UDP (User Datagram Protocol) |
| **网络层** | 处理在网络上流动的数据包                                   | IP (Internet Protocol)                                  |
| **链路层** | 处理连接网络的硬件部分                                     | Ethernet, Wi-Fi (IEEE 802.11), PPP (Point-to-Point Protocol) |

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

URI Uniform Resource Identifier 统一资源标识符 vs. URL Uniform Resource Locator 统一资源定位符

[RFC2396](https://www.rfc-editor.org/rfc/rfc2396) 分别对这 3 个单词进行了如下定义。

- Uniform

规定统一的格式可方便处理多种不同类型的资源，而不用根据上下文环境来识别资源指定的访问方式。另外，加入新增的协议方案（如http: 或 ftp:）也更容易。

- Resource

资源的定义是“可标识的任何东西”。除了文档文件、图像或服务（例如当天的天气预报）等能够区别于其他类型的，全都可作为资源。另外，资源不仅可以是单一的，也可以是多数的集合体。

- Identifier

表示可标识的对象。也称为标识符。

综上所述，URI 就是由某个协议方案表示的资源的定位标识符。协议方案是指访问资源所使用的协议类型名称。采用 HTTP 协议时，协议方案就是 http。除此之外，还有 ftp、mailto、telnet、file 等。

标准的 URI 协议方案有 30 种左右，由隶属于国际互联网资源管理的非营利社团 ICANN（Internet Corporation for Assigned Names and Numbers，互联网名称与数字地址分配机构）的 IANA（Internet Assigned Numbers Authority，互联网号码分配局）管理颁布。IANA - Uniform Resource Identifier (URI) SCHEMES（统一资源标识符方案）-> <http://www.iana.org/assignments/uri-schemes>

**区别：**URI 用字符串标识某一互联网资源，而 URL 表示资源的地点（互联网上所处的位置）。可见 URL 是 URI 的子集。

“RFC3986：统一资源标识符（URI）通用语法”中列举了几种 URI 例子，如下所示。

```plaintext
ftp://ftp.is.co.za/rfc/rfc1808.txt
http://www.ietf.org/rfc/rfc2396.txt
ldap://[2001:db8::7]/c=GB?objectClass?one
mailto:John.Doe@example.com
news:comp.infosystems.www.servers.unix
tel:+1-816-555-1212
telnet://192.0.2.16:80/
urn:oasis:names:specification:docbook:dtd:xml:4.1.2
```

### 绝对 URI 的格式

```plaintext
http://user:pass@www.example.jp:80/dir/index.htm?uid=1#ch1
```

| 组件                  | 描述                                                                                     | 示例                                  |
|-----------------------|------------------------------------------------------------------------------------------|---------------------------------------|
| **协议类型**          | 使用 `http:` 或 `https:` 等协议获取资源。不区分大小写，后面跟一个冒号。                 | `http:`                               |
| **登录信息（认证）**  | 指定用户名和密码作为身份认证。此项为可选项。                                              | `user:pass`                           |
| **服务器地址**        | 指定可解析的域名、IPv4 或 IPv6 地址。                                                     | `www.example.jp`, `192.168.1.1`, `[0:0:0:0:0:0:0:1]` |
| **服务器端口号**      | 指定服务器连接的端口。可选项，缺省时使用默认端口。                                       | `:80`                                 |
| **带层次的文件路径**  | 指定服务器上的文件路径来定位资源。                                                        | `/dir/index.htm`                      |
| **查询字符串**        | 附加参数到已指定的文件路径内资源。可选项。                                                | `?uid=1`                              |
| **片段标识符**        | 标记出已获取资源中的子资源或文档内的特定位置。可选项。                                    | `#ch1`                                |

> [0:0:0:0:0:0:0:1]是一种 IPv6 地址，在浏览器上访问 IPv6 的地址需要加中括号`[]`
{: .prompt-tip }