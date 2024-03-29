---
title: HTTP协议笔记
date: 2023-06-01 21:09:00 +0800
categories: [Computer Networking]
tags: [Computer Networking]
author: ltfy
pin: false
math: false
mermaid: false
---

HTTP 规定在 HTTP 客户端与 HTTP 服务器之间的每次交互，都由一个 ASCII 码串构成的请求和一个类 MIME[^MIME] 的相应组成（MIME-like）。HTTP 报文通常都是用 TCP 连接。

从层次的角度看，HTTP 是面向事务的应用层协议。**所谓事务，就是指一系列的信息交换，而这一系列的信息交换是一个不可分割的整体，即要么所有信息交换都完成，要么一次交换都不进行。**

HTTP 协议本身是无连接的，虽然 HTTP 使用了 TCP 连接，但通信的双方在交换 HTTP 报文前不需要建立 HTTP 连接。

HTTP 协议是无状态的（stateless），也就是说，同一个客户第二次访问同一个服务器上的页面时，服务器的响应与第一次被访问时的相同。

万维网客户把 HTTP 请求报文作为 TCP 连接三次握手的第三个报文的数据发送给万维网服务器，服务器收到 HTTP 请求报文后，就把所请求的文档作为响应报文返回给客户。

HTTP/1.0 的主要缺点，是每请求一个文档就要有两倍 RTT[^RTT] 的开销。HTTP/1.1 使用持续连接。所谓持续连接，就是万维网服务器在发送响应后仍然在一段时间内保持这条连接，使同一个客户（浏览器）和该服务器可以继续在这条连接上传送后续的 HTTP 请求报文和响应报文，这并不局限于传送同一个页面上链接的文档，而是只要这些文档都在同一个服务器上就行。

HTTP/1.1 协议的持续连接有两种方式，即非流水线方式和流水线方式。
    - 非流水线方式的特点是，客户在收到前一个响应后才能发出下一个请求；
    - 流水线方式的特点是，客户在收到HTTP的响应报文之前就能接着发送新的请求报文。

HTTP 请求报文和响应报文都由三个部分组成：开始行、首部行、实体主题。开始行用于区别报文时响应报文还是请求报文，在请求报文中，开始行叫做请求行，而在响应报文中，开始行叫做状态行。

请求报文请求行只有三个内容：**方法**、**请求资源的 URL**、**HTTP 的版本**。响应报文的状态行也包括三项内容：**HTTP 的版本**、**状态码**、**解释状态码的简单短语**。

状态码都是三位数字的，分为5大类共33种，例如：
    - 1xx表示通知信息的，如请求收到了或正在进行处理；
    - 2xx表示成功，如接受或知道了；
    - 3xx表示重定向，如果完成请求，还必须采取进一步的行动；
    - 4xx表示客户端错误，如请求中有错误的语法或不能完成；
    - 5xx表示服务端错误，如服务器失效无法完成请求。

<font color='red' style='font-weight:bold; font-size: 120%;'>Q: 在浏览器地址栏键入 URL，按下回车之后发生的几个事件？</font>
1. 浏览器向 DNS 服务器请求解析该 URL 中的域名所对应的 IP 地址；
2. 解析出 IP 地址后，根据该 IP 地址和默认端口 80，和服务器建立 TCP 连接；
3. 浏览器发出读取文件（URL 中域名后面部分对应的文件）的 HTTP 请求，该请求报文作为 TCP 三次握手的第三个报文的数据发送给服务器；
4. 服务器给出相应，把对应的 html 文本发送给浏览器；
5. 释放 TCP 连接；
6. 浏览器将该文本显示出来。

## Reference
[^MIME]: [A media type (also known as a Multipurpose Internet Mail Extensions or MIME type) indicates the nature and format of a document, file, or assortment of bytes. MIME types are defined and standardized in IETF's RFC 6838.](https://datatracker.ietf.org/doc/html/rfc6838)
[^RTT]: [wiki/Round-trip_delay](https://en.wikipedia.org/wiki/Round-trip_delay)