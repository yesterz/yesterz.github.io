---
title: HTTP 首部
date: 2023-06-14 21:09:00 +0800
author: 
categories: [Computer Networking]
tags: [Computer Networking]
pin: false
math: false
mermaid: false
---

# HTTP 报文首部

![HTTP 报文的结构](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/14135fdb-8764-4018-ba5a-3773d88628f7/Untitled.png)

HTTP 报文的结构

HTTP 协议的请求和响应报文中必定包含 HTTP 首部。

首部内容为客户端和服务器分别处理请求和响应提供所需要的信息。

对于客户端用户来说，这些信息中的大部分内容都无须亲自查看。

- HTTP 请求报文
    
    ![在请求中，HTTP 报文由方法、URI、HTTP 版本、HTTP 首部字段等部分构成。](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/67d51871-3713-46af-ab27-29b49b84da15/Untitled.png)
    
    在请求中，HTTP 报文由方法、URI、HTTP 版本、HTTP 首部字段等部分构成。
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0575de07-4d97-4e14-9b3e-27ce0533d869/Untitled.png)
    
- HTTP 响应报文
    
    在响应中，HTTP 报文由 HTTP 版本、状态码（数字和原因短语）、HTTP 首部字段 3 部分构成。
    
    ![响应报文](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/220206fb-bbb5-4853-9118-451688c457f9/Untitled.png)
    
    响应报文
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2f1c308d-ad91-46f0-8fc4-0b1ca729a714/Untitled.png)
    

# HTTP 首部字段

- HTTP 首部字段结构
    
    HTTP 首部字段是由首部字段名和字段值构成的，中间用冒号“:” 分隔。
    
    `首部字段名: 字段值`
    
    例如：
    
    `Content-Type: text/html`
    
    `Keep-Alive: timeout=15, max=100`
    
- 4种 HTTP 首部字段类型
    
    根据实际用途被分为以下 4 种类型
    
    1. 通用首部字段（General Header Fields）
        
        请求报文和响应报文两方都会使用的首部。
        
    2. 请求首部字段（Request Header Fields）
        
        从客户端向服务器端发送请求报文时使用的首部。补充了请求的附加内容、客户端信息、响应内容相关优先级等信息。
        
    3. 响应首部字段（Response Header Fields）
        
        从服务器端向客户端返回响应报文时使用的首部。补充了响应的附加内容，也会要求客户端附加额外的内容信息。
        
    4. 实体首部字段（Entity Header Fields）
        
        针对请求报文和响应报文的实体部分使用的首部。补充了资源内容更新时间等与实体有关的信息。
        
- HTTP/1.1 首部字段一览
    
    HTTP/1.1 规范定义了如下 47 种首部字段。
    
    ![通用首部字段](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7aedb277-b7a1-4375-a188-00ab4d3b23b4/Untitled.png)
    
    通用首部字段
    
    ![请求首部字段](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e2c07df1-47f0-4955-a46e-96e9b8e10283/Untitled.png)
    
    请求首部字段
    
    ![响应首部字段](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/20507cbb-3b35-4dab-9b2c-64cf6b0b79b9/Untitled.png)
    
    响应首部字段
    
    ![实体首部字段](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b185bd01-5002-4542-ae3c-cc5b1a060ce9/Untitled.png)
    
    实体首部字段
    
- 非 HTTP/1.1 首部字段
    
    在 HTTP 协议通信交互中使用到的首部字段，不限于 RFC2616 中定义的 47 种首部字段。还有 Cookie、Set-Cookie 和 Content-Disposition 等在其他 RFC 中定义的首部字段，它们的使用频率也很高。这些非正式的首部字段统一归纳在 RFC4229 HTTP Header Field Registrations 中。
    
- End-to-end 首部和 Hop-by-hop 首部
    
    HTTP 首部字段将定义成缓存代理和非缓存代理的行为，分成 2 种类型。
    
    1. 端到端首部（End-to-end Header）
        
        分在此类别中的首部会转发给请求 / 响应对应的最终接收目标，且必须保存在由缓存生成的响应中，另外规定它必须被转发。
        
    2. 逐跳首部（Hop-by-hop Header）
        
        分在此类别中的首部只对单次转发有效，会因通过缓存或代理而不再转发。HTTP/1.1 和之后版本中，如果要使用 hop-by-hop 首部，需提供 Connection 首部字段。
        
        下面列举了 HTTP/1.1 中的逐跳首部字段。除这 8 个首部字段之外，其他所有字段都属于端到端首部。
        
        - Connection
        - Keep-Alive
        - Proxy-Authenticate
        - Proxy-Authorization
        - Trailer
        - TE
        - Transfer-Encoding
        - Upgrade

# HTTP/1.1 通用首部字段

通用首部字段是指，请求报文和响应报文双方都会使用的首部。

## Cache-Control

通过指定首部字段 Cache-Control 的指令，就能操作缓存的工作机制。

指令的参数是可选的，多个指令之间通过“,”分隔。首部字段 CacheControl 的指令可用于请求及响应时。

`Cache-Control: private, max-age=0, no-cache`

- Cache-Control 指令一览
    
    可用的指令按请求和响应分类如下所示。
    
    ![缓存请求指令](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5035e973-0984-40d9-8268-16b7aa0f9593/Untitled.png)
    
    缓存请求指令
    
    ![缓存响应指令](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c01c494f-d948-4a00-b9e2-cf1340acbff1/Untitled.png)
    
    缓存响应指令
    

## Connection

Connection 首部字段具备如下两个作用。

- 控制不再转发给代理的首部字段
- 管理持久连接

## Date

首部字段 Date 表明创建 HTTP 报文的日期和时间。

## Pragma

Pragma 是 HTTP/1.1 之前版本的历史遗留字段，仅作为与 HTTP/1.0 的向后兼容而定义。

## Trailer

首部字段 Trailer 会事先说明在报文主体后记录了哪些首部字段。该首部字段可应用在 HTTP/1.1 版本分块传输编码时。

## Transfer-Encoding

Transfer-Encoding

首部字段 Transfer-Encoding 规定了传输报文主体时采用的编码方式。

## Upgrade

首部字段 Upgrade 用于检测 HTTP 协议及其他协议是否可使用更高的版本进行通信，其参数值可以用来指定一个完全不同的通信协议。

## Via

使用首部字段 Via 是为了追踪客户端与服务器之间的请求和响应报文的传输路径。

报文经过代理或网关时，会先在首部字段 Via 中附加该服务器的信息，然后再进行转发。这个做法和 traceroute 及电子邮件的 Received 首部的工作机制很类似。

首部字段 Via 不仅用于追踪报文的转发，还可避免请求回环的发生。所以必须在经过代理时附加该首部字段内容。

## Warning

`Warning: [警告码][警告的主机:端口号]“[警告内容]”([日期时间])`

HTTP/1.1 中定义了 7 种警告。警告码对应的警告内容仅推荐参考。另外，警告码具备扩展性，今后有可能追加新的警告码。

![HTTP/1.1 警告码](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/61d4cb64-1216-4254-830b-e1343376b712/Untitled.png)

HTTP/1.1 警告码