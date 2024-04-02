---
title: 简单的 HTTP 协议
date: 2023-06-11 21:09:00 +0800
author: 
categories: [Computer Networking]
tags: [Computer Networking]
pin: false
math: false
mermaid: false
---

## HTTP 协议用于客户端和服务器端之间的通信

概念阐述：

- 请求访问文本或图像等资源的一端称为客户端
- 提供资源响应的一端称为服务器端

## 通过请求和响应的交换达成通信

HTTP 协议规定，请求从客户端发出，最后服务器端响应该请求并返回。换句话说，肯定是先从客户端开始建立通信的，服务器端在没有接收到请求之前不会发送响应。

```plaintext
GET /index.htm HTTP/1.1
Host: hackr.jp
```

这段就是，请求访问某台 HTTP 服务器上的 /index.htm 页面资源

- 起始行开肉的 GET 表示请求访问服务器的类型，称为方法（method）
- 随后的字符串 /index.htm 指明了请求访问的资源对象，也叫请求 URI （request-URI）
- 最后的 HTTP/1.1，即 HTTP 的版本号，用来提示客户端使用的 HTTP 协议功能。

![请求报文的构成](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a7bad7d5-8a87-444f-8e8d-512a105bbaa1/Untitled.png)

请求报文的构成

请求报文是由请求方法、请求 URI、协议版本、可选的请求首部字段和内容实体构成的。

![响应报文](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e5f15686-f6c7-49e9-aa1a-43d74b2c8601/Untitled.png)

响应报文

- 在起始行开头的 HTTP/1.1 表示服务器对应的 HTTP 版本
- 紧挨着的 200 OK 表示请求的处理结果的状态码（status code）和原因短语（reason-phrase）。
- 下一行显示了创建响应的日期时间，是首部字段（header field）内的一个属性
- 紧接着以一空行分隔，之后的内容称为资源实体的主体（entity body）

![响应报文的构成](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1695bf2a-f0e4-4605-a40c-e76d75cd858b/Untitled.png)

响应报文的构成

响应报文基本上由协议版本、状态码（表示请求成功或失败的数字代码）、用以解释状态码的原因短语、可选的响应首部字段以及实体主体构成。

## HTTP 是**不保存状态**的协议

HTTP 是一种不保存状态，即无状态（stateless）协议。HTTP 协议自身不对请求和响应之间的通信状态进行保存。也就是说在 HTTP 这个级别，协议对于发送过的请求或响应都不做持久化处理。

**HTTP 协议自身不具备保存之前发送过的请求或响应的功能。**

~~HTTP/1.1 虽然是无状态协议，但为了实现期望的保持状态功能，于是引入了 Cookie 技术。有了 Cookie 再用 HTTP 协议通信，就可以管理状态了。~~

## 请求 URI 定位资源

- URI 为完整的请求 URI
    
    `GET http://hackr.jp/index.htm HTTP/1.1`
    
- 在首部字段 Host 中写明网络域名或 IP 地址
    
    GET /index.htm HTTP/1.1
    
    Host: hackr.jp
    

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/62556f3a-fc1e-45bd-af47-f65d6e457870/Untitled.png)

## 告知服务器意图的 HTTP 方法

- GET 获取资源
    
    GET 方法用来请求访问已被 URI 识别的资源。指定的资源经服务器端解析后返回响应内容。也就是说，如果请求的资源是文本，那就保持原样返回；如果是像 CGI（Common Gateway Interface，通用网关接
    口）那样的程序，则返回经过执行后的输出结果。
    
    | 请求 | GET /index.html HTTP/1.1 |
    | --- | --- |
    | 响应 | 返回 index.html 的页面资源 |
    
    | 请求 | GET /index.html HTTP/1.1
    Host: www.hackr.jp
    If-Modified-Since: Thu, 12  Jul 2012 07:30:00 GMT |
    | --- | --- |
    | 响应 | 仅返回2012年7 月12日7 点30分以后更新过的index.html页面资源。如果未有内容更新，则以状态码304 Not Modified作为响应返回 |
- POST 传输实体主体
    
    虽然用 GET 方法也可以传输实体的主体，但一般不用 GET 方法进行传输，而是用 POST 方法。虽说 POST 的功能与 GET 很相似，但 POST 的主要目的并不是获取响应的主体内容。
    
    | 请求 | POST /submit.cgi HTTP/1.1
    Host: http://www.hackr.jp/
    Content-Length: 1560（1560字节的数据） |
    | --- | --- |
    | 响应 | 返回 submit.cgi 接收数据的处理结果 |
- PUT 传输文件
    
    PUT 方法用来传输文件。就像 FTP 协议的文件上传一样，要求在请求报文的主体中包含文件内容，然后保存到请求 URI 指定的位置。
    
    ~~但是，鉴于 HTTP/1.1 的 PUT 方法自身不带验证机制，任何人都可以上传文件 , 存在安全性问题，因此一般的 Web 网站不使用该方法。若配合 Web 应用程序的验证机制，或架构设计采用REST（REpresentational State Transfer，表征状态转移）标准的同类Web 网站，就可能会开放使用 PUT 方法。~~
    
    | 请求 | PUT /example.html HTTP/1.1
    Host: http://www.hackr.jp/
    Content-Type: text/html
    Content-Length: 1560（1560 字节的数据 |
    | --- | --- |
    | 响应 | 响应返回状态码 204 No Content（比如 ：该 html 已存在于服务器上） |
- HEAD 获得报文首部
    
    HEAD 方法和 GET 方法一样，只是不返回报文主体部分。用于确认 URI 的有效性及资源更新的日期时间等。
    
    | 请求 | HEAD /index.html HTTP/1.1
    Host: http://www.hackr.jp/ |
    | --- | --- |
    | 响应 | 返回index.html有关的响应首部 |
- DELETE 删除文件
    
    DELETE 方法用来删除文件，是与 PUT 相反的方法。DELETE 方法按请求 URI 删除指定的资源。
    
    ~~但是，HTTP/1.1 的 DELETE 方法本身和 PUT 方法一样不带验证机制，所以一般的 Web 网站也不使用 DELETE 方法。当配合 Web 应用程序的验证机制，或遵守 REST 标准时还是有可能会开放使用的。~~
    
    | 请求 | DELETE /example.html HTTP/1.1
    Host: http://www.hackr.jp/ |
    | --- | --- |
    | 响应 | 响应返回状态码 204 No Content（比如 ：该 html 已从该服务器上删除） |
- OPTIONS 支持询问的方法
    
    OPTIONS 方法用来查询针对请求 URI 指定的资源支持的方法。
    
    | 请求 | OPTIONS * HTTP/1.1
    Host: http://www.hackr.jp/ |
    | --- | --- |
    | 响应 | HTTP/1.1 200 OK
    Allow: GET, POST, HEAD, OPTIONS
    （返回服务器支持的方法） |
- TRACE 追踪路径
    
    TRACE 方法是让 Web 服务器端将之前的请求通信环回给客户端的方法。**不常用**
    
    | 请求 | TRACE / HTTP/1.1
    Host: http://hackr.jp/
    Max-Forwards: 2 |
    | --- | --- |
    | 响应 | HTTP/1.1 200 OK
    Content-Type: message/http
    Content-Length: 1024
    
    TRACE / HTTP/1.1
    Host: http://hackr.jp/
    Max-Forwards: 2（返回响应包含请求内容） |
- CONNECT 要求用隧道协议连接代理
    
    CONNECT 方法要求在与代理服务器通信时建立隧道，实现用隧道协议进行 TCP 通信。主要使用 SSL（Secure Sockets Layer，安全套接层）和 TLS（Transport Layer Security，传输层安全）协议把通信内容加 密后经网络隧道传输。
    
    CONNECT 方法的格式 `CONNECT 代理服务器名:端口号 HTTP版本`
    
    | 请求 | CONNECT http://proxy.hackr.jp:8080/ HTTP/1.1
    Host: http://proxy.hackr.jp/ |
    | --- | --- |
    | 响应 | HTTP/1.1 200 OK（之后进入网络隧道） |

## 使用方法下达命令

**向请求 URI 指定的资源发送请求报文时，采用称为方法的命令。**

方法的作用在于，可以指定请求的资源按期望产生某种行为。方法中有 GET、POST 和 HEAD 等。

**方法名大小写敏感。**

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d1237c25-3676-4392-8b00-00a859a2aebf/Untitled.png)

## 持久连接节省通信量

HTTP 协议的初始版本中，每进行一次 HTTP 通信就要断开一次 TCP 连接。

- 持久连接
    
    为解决上述 TCP 连接的问题，HTTP/1.1 和一部分的 HTTP/1.0 想出了持久连接（HTTP Persistent Connections，也称为 HTTP keep-alive 或HTTP connection reuse）的方法。持久连接的特点是，只要任意一端没有明确提出断开连接，则保持 TCP 连接状态。
    
    **持久连接旨在建立 1 次 TCP 连接后进行多次请求和响应的交互**
    
    持久连接的好处在于减少了 TCP 连接的重复建立和断开所造成的额外开销，减轻了服务器端的负载。另外，减少开销的那部分时间，使HTTP 请求和响应能够更早地结束，这样 Web 页面的显示速度也就相应提高了。
    在 HTTP/1.1 中，所有的连接默认都是持久连接，但在 HTTP/1.0 内并未标准化。虽然有一部分服务器通过非标准的手段实现了持久连接，但服务器端不一定能够支持持久连接。毫无疑问，除了服务器端，客户端也需要支持持久连接。
    
- 管线化
    
    持久连接使得多数请求以管线化（pipelining）方式发送成为可能。从前发送请求后需等待并收到响应，才能发送下一个请求。管线化技术出现后，不用等待响应亦可直接发送下一个请求。
    
    这样就能够做到同时并行发送多个请求，而不需要一个接一个地等待响应了。
    
    **不等待响应，直接发送下一个请求**
    

## 使用 Cookie 的状态管理

HTTP 是无状态协议，它不对之前发生过的请求和响应的状态进行管理。也就是说，无法根据之前的状态进行本次的请求处理。

**如果让服务器管理全部客户端状态则会成为负担**

保留无状态协议这个特征的同时又要解决类似的矛盾问题，于是引入了 Cookie 技术。Cookie 技术通过在请求和响应报文中写入 Cookie 信息来控制客户端的状态。

**Cookie 会根据从服务器端发送的响应报文内的一个叫做 Set-Cookie 的首部字段信息，通知客户端保存 Cookie。**当下次客户端再往该服务器发送请求时，客户端会自动在请求报文中加入 Cookie 值后发送出去。

服务器端发现客户端发送过来的 Cookie 后，会去检查究竟是从哪一个客户端发来的连接请求，然后对比服务器上的记录，最后得到之前的状态信息。

1. 请求报文（没有 Cookie 信息的状态）
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/4143565c-0d8a-4073-87e6-0bc57a1ec6e9/Untitled.png)
    
2. 响应报文（服务器端生成 Cookie 信息）
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0e2c544c-6ec9-4a6d-b913-41e1bcf7e201/Untitled.png)
    
3. 请求报文（自动发送保存着的 Cookie 信息）
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d51e8025-38ab-45e8-83d6-0be7da30f4f6/Untitled.png)