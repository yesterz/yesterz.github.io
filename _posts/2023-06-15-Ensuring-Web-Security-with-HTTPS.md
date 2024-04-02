---
title: 确保 Web 安全的 HTTPS
date: 2023-06-15 21:09:00 +0800
author: 
categories: [Computer Networking]
tags: [Computer Networking]
pin: false
math: false
mermaid: false
---

## HTTP 的缺点

1. 通信使用明文（不加密），内容可能会被窃听
2. 不验证通信方的身份，因此有可能遭遇伪装
3. 无法证明报文的完整性，所以有可能已遭篡改

### 通信使用明文可能会被窃听

- TCP/IP 是可能被窃听的网络
    
    **HTTP 报文使用明文（指未经过加密的报文）方式发送**
    
- 加密处理防止被窃听
    1. 通信的加密
        
        HTTP 协议中没有加密机制，但可以通过和 SSL（Secure Socket Layer，安全套接层）或
        TLS（Transport Layer Security，安全层传输协议）的组合使用，加密 HTTP 的通信内容。
        
        用 SSL建立安全通信线路之后，就可以在这条线路上进行 HTTP 通信了。与 SSL组合使用的 HTTP 被称为 HTTPS（HTTP Secure，超文本传输安全协议）或 HTTP over SSL。
        
    2. 内容的加密
        
        还有一种将参与通信的内容本身加密的方式。由于 HTTP 协议中没有加密机制，那么就对 HTTP 协议传输的内容本身加密。即把 HTTP 报文里所含的内容进行加密处理。
        

### 不验证通信方的身份就可能遭遇伪装

HTTP 协议中的请求和响应不会对通信方进行确认。也就是说存在“服务器是否就是发送请求中 URI 真正指定的主机，返回的响应是否真的返回到实际提出请求的客户端”等类似问题。

- 任何人都可发起请求
- 查明对手的证书

### 无法证明报文完整性，可能已遭篡改

所谓完整性是指信息的准确度。若无法证明其完整性，通常也就意味着无法判断信息是否准确。

- 接收到的内容可能有误
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c52dffd0-dcc3-40c3-ad32-f12756bf91ac/Untitled.png)
    
- 如何防止篡改
    
    其中常用的是 MD5 和 SHA-1 等散列值校验的方法，以及用来确认文件的数字签名方法。
    

## HTTP + 加密 + 认证 + 完整性保护 = HTTPS

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/15ac419e-f23e-4ad3-9e50-b378348d6726/Untitled.png)

### HTTPS 是身披 SSL 外壳的 HTTP

HTTPS 并非是应用层的一种新协议。只是 HTTP 通信接口部分用 SSL（Secure Socket Layer）和 TLS（Transport Layer Security）协议代替而已。

通常，HTTP 直接和 TCP 通信。当使用 SSL时，则演变成先和 SSL通信，再由 SSL和 TCP 通信了。简言之，所谓 HTTPS，其实就是身披SSL协议这层外壳的 HTTP。

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/71d712f5-8694-46a9-9b90-315122f3e7d4/Untitled.png)

### 相互交换密钥的公开密钥加密技术

SSL采用一种叫做公开密钥加密（Public-key cryptography）的加密处理方式。

- 共享密钥加密的困境
    
    加密和解密同用一个密钥的方式称为共享密钥加密（Common keycrypto system），也被叫做对称密钥加密。
    
- 使用两把密钥的公开密钥加密
    
    公开密钥加密使用一对非对称的密钥。一把叫做私有密钥（private key），另一把叫做公开密钥（public key）。顾名思义，私有密钥不能让其他任何人知道，而公开密钥则可以随意发布，任何人都可以获得。
    
- HTTPS 采用混合加密机制
    
    HTTPS 采用共享密钥加密和公开密钥加密两者并用的混合加密机制。若密钥能够实现安全交换，那么有可能会考虑仅使用公开密钥加密来通信。但是公开密钥加密与共享密钥加密相比，其处理速度要慢。
    

### 证明公开密钥正确性的证书

使用由数字证书认证机构（CA，Certificate Authority）和其相关机关颁发的公开密钥证书。

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/209effc5-2f60-45ce-8993-8ed5a1021257/Untitled.png)

### HTTPS 的安全通信机制

HTTPS 的安全通信机制

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/cfb77b92-ee84-45d2-9699-2a8485cddfef/Untitled.png)

步骤 1： 客户端通过发送 Client Hello 报文开始 SSL通信。报文中包含客户端支持的 SSL的指定版本、加密组件（Cipher Suite）列表（所使用的加密算法及密钥长度等）。

步骤 2： 服务器可进行 SSL通信时，会以 Server Hello 报文作为应答。和客户端一样，在报文中包含 SSL版本以及加密组件。服务器的加密组件内容是从接收到的客户端加密组件内筛选出来的。

步骤 3： 之后服务器发送 Certificate 报文。报文中包含公开密钥证书。

步骤 4： 最后服务器发送 Server Hello Done 报文通知客户端，最初阶段的 SSL握手协商部分结束。

步骤 5： SSL第一次握手结束之后，客户端以 Client Key Exchange 报文作为回应。报文中包含通信加密中使用的一种被称为 Pre-master secret 的随机密码串。该报文已用步骤 3 中的公开密钥进行加密。

步骤 6： 接着客户端继续发送 Change Cipher Spec 报文。该报文会提示服务器，在此报文之后的通信会采用 Pre-master secret 密钥加密。

步骤 7： 客户端发送 Finished 报文。该报文包含连接至今全部报文的整体校验值。这次握手协商是否能够成功，要以服务器是否能够正确解密该报文作为判定标准。

步骤 8： 服务器同样发送 Change Cipher Spec 报文。

步骤 9： 服务器同样发送 Finished 报文。

步骤 10： 服务器和客户端的 Finished 报文交换完毕之后，SSL连接就算建立完成。当然，通信会受到 SSL的保护。从此处开始进行应用层协议的通信，即发送 HTTP 请求。

步骤 11： 应用层协议通信，即发送 HTTP 响应。

步骤 12： 最后由客户端断开连接。断开连接时，发送 close_notify 报文。上图做了一些省略，这步之后再发送 TCP FIN 报文来关闭与 TCP 的通信。

在以上流程中，应用层发送数据时会附加一种叫做 MAC（Message Authentication Code）的报文摘要。MAC 能够查知报文是否遭到篡改，从而保护报文的完整性。

![图中说明了从仅使用服务器端的公开密钥证书（服务器证书）建立 HTTPS 通信的整个过程。](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/389da85d-3c3e-4674-8f66-d3c857084704/Untitled.png)

图中说明了从仅使用服务器端的公开密钥证书（服务器证书）建立 HTTPS 通信的整个过程。