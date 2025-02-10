---
title: HTTP 首部
date: 2023-06-14 21:09:00 +0800
author: 
categories: [Computer Networking]
tags: [Computer Networking]
pin: false
math: false
mermaid: false
media_subpath: /assets/images/2023-06-14-HTTP-Headers
---

## HTTP 报文首部

![The-structure-of-an-HTTP-message.png](The-structure-of-an-HTTP-message.png)

HTTP 报文的结构

HTTP 协议的请求和响应报文中必定包含 HTTP 首部。

首部内容为客户端和服务器分别处理请求和响应提供所需要的信息。

对于客户端用户来说，这些信息中的大部分内容都无须亲自查看。

- HTTP 请求报文
    
    ![在请求中，HTTP 报文由方法、URI、HTTP 版本、HTTP 首部字段等部分构成。](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/67d51871-3713-46af-ab27-29b49b84da15/Untitled.png)
    
    在请求中，HTTP 报文由方法、URI、HTTP 版本、HTTP 首部字段等部分构成。

    ```plaintext
    GET / HTTP/1.1
    Host: hackr.jp
    User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20100101 Firefox/13.0
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*; q=0.8
    Accept-Language: ja,en-us;q=0.7,en;q=0.3
    Accept-Encoding: gzip, deflate
    DNT: 1
    Connection: keep-alive
    If-Modified-Since: Fri, 31 Aug 2007 02:02:20 GMT
    If-None-Match: "45bae1-16a-46d776ac"
    Cache-Control: max-age=0
    ```    
    
- HTTP 响应报文
    
    在响应中，HTTP 报文由 HTTP 版本、状态码（数字和原因短语）、HTTP 首部字段 3 部分构成。
    
    ![响应报文](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/220206fb-bbb5-4853-9118-451688c457f9/Untitled.png)
    
    响应报文
    
    ```plaintext
    HTTP/1.1 304 Not Modified
    Date: Thu, 07 Jun 2012 07:21:36 GMT
    Server: Apache
    Connection: close
    Etag: "45bae1-16a-46d776ac"
    ```
    

## HTTP 首部字段

### HTTP 首部字段结构
    
HTTP 首部字段是由首部字段名和字段值构成的，中间用冒号“:”分隔。

```plaintext
首部字段名: 字段值
```

例如：

`Content-Type: text/html`

字段值对应单个 HTTP 首部字段可以有多个值，比如

`Keep-Alive: timeout=15, max=100`
    
### 4种 HTTP 首部字段类型
    
根据实际用途被分为以下 4 种类型

1. 通用首部字段（General Header Fields）
    
    请求报文和响应报文两方都会使用的首部。
    
2. 请求首部字段（Request Header Fields）
    
    从客户端向服务器端发送请求报文时使用的首部。补充了请求的附加内容、客户端信息、响应内容相关优先级等信息。
    
3. 响应首部字段（Response Header Fields）
    
    从服务器端向客户端返回响应报文时使用的首部。补充了响应的附加内容，也会要求客户端附加额外的内容信息。
    
4. 实体首部字段（Entity Header Fields）
    
    针对请求报文和响应报文的实体部分使用的首部。补充了资源内容更新时间等与实体有关的信息。
        
### HTTP/1.1 首部字段一览
    
HTTP/1.1 规范定义了如下 47 种首部字段。

- 通用首部字段

    | 首部字段名          | 说明                       |
    |-------------------|----------------------------|
    | Cache-Control     | 控制缓存的行为               |
    | Connection        | 逐跳首部、连接的管理          |
    | Date              | 创建报文的日期时间            |
    | Pragma            | 报文指令                     |
    | Trailer           | 报文末端的首部一览             |
    | Transfer-Encoding | 指定报文主体的传输编码方式     |
    | Upgrade           | 升级为其他协议                |
    | Via               | 代理服务器的相关信息           |
    | Warning           | 错误通知                     |

- 请求首部字段

    | 首部字段名             | 说明                           |
    |----------------------|--------------------------------|
    | Accept               | 用户代理可处理的媒体类型             |
    | Accept-Charset       | 优先的字符集                      |
    | Accept-Encoding      | 优先的内容编码                    |
    | Accept-Language      | 优先的语言（自然语言）             |
    | Authorization       | Web认证信息                      |
    | Expect               | 期待服务器的特定行为               |
    | From                 | 用户的电子邮箱地址                 |
    | Host                 | 请求资源所在服务器                 |
    | If-Match             | 比较实体标记（ETag）               |
    | If-Modified-Since    | 比较资源的更新时间                 |
    | If-None-Match        | 比较实体标记（与 If-Match 相反）    |
    | If-Range             | 资源未更新时发送实体 Byte 的范围请求 |
    | If-Unmodified-Since  | 比较资源的更新时间（与If-Modified-Since相反） |
    | Max-Forwards         | 最大传输逐跳数                     |
    | Proxy-Authorization  | 代理服务器要求客户端的认证信息        |
    | Range                | 实体的字节范围请求                  |
    | Referer              | 对请求中 URI 的原始获取方           |
    | TE                   | 传输编码的优先级                   |
    | User-Agent           | HTTP 客户端程序的信息              |

- 响应首部字段

    | 首部字段名            | 说明                          |
    |---------------------|-------------------------------|
    | Accept-Ranges       | 是否接受字节范围请求              |
    | Age                 | 推算资源创建经过时间              |
    | ETag                | 资源的匹配信息                   |
    | Location            | 令客户端重定向至指定URI           |
    | Proxy-Authenticate | 代理服务器对客户端的认证信息       |
    | Retry-After         | 对再次发起请求的时机要求          |
    | Server              | HTTP服务器的安装信息              |
    | Vary                | 代理服务器缓存的管理信息           |
    | WWW-Authenticate    | 服务器对客户端的认证信息           |

- 实体首部字段

    | 首部字段名            | 说明                           |
    |---------------------|-------------------------------|
    | Allow               | 资源可支持的HTTP方法             |
    | Content-Encoding    | 实体主体适用的编码方式             |
    | Content-Language    | 实体主体的自然语言               |
    | Content-Length      | 实体主体的大小（单位：字节）      |
    | Content-Location    | 替代对应资源的URI                |
    | Content-MD5         | 实体主体的报文摘要                |
    | Content-Range       | 实体主体的位置范围               |
    | Content-Type        | 实体主体的媒体类型               |
    | Expires             | 实体主体过期的日期时间            |
    | Last-Modified       | 资源的最后修改日期时间            |

    
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

## HTTP/1.1 通用首部字段

通用首部字段是指，请求报文和响应报文双方都会使用的首部。

### Cache-Control

通过指定首部字段 Cache-Control 的指令，就能操作缓存的工作机制。

指令的参数是可选的，多个指令之间通过“,”分隔。首部字段 CacheControl 的指令可用于请求及响应时。

`Cache-Control: private, max-age=0, no-cache`

- Cache-Control 指令一览
    
    可用的指令按请求和响应分类如下所示。
        
    **缓存请求指令**

    | 指令             | 参数         | 说明                           |
    |-----------------|--------------|-------------------------------|
    | no-cache        | 无           | 强制向源服务器再次验证             |
    | no-store        | 无           | 不缓存请求或响应的任何内容           |
    | max-age         | [秒]         | 响应的最大Age值                  |
    | max-stale       | [= [秒]]     | 接收已过期的响应                   |
    | min-fresh       | [秒]         | 期望在指定时间内的响应仍有效          |
    | no-transform    | 无           | 代理不可更改媒体类型                |
    | only-if-cached  | 无           | 从缓存获取资源                    |
    | cache-extension | -            | 新指令标记（token）               |
    
    **缓存响应指令**
    
    | 指令             | 参数         | 说明                                      |
    |-----------------|--------------|------------------------------------------|
    | public          | 无           | 可向任意方提供响应的缓存                     |
    | private         | 可省略       | 仅向特定用户返回响应                        |
    | no-cache        | 可省略       | 缓存前必须先确认其有效性                    |
    | no-store        | 无           | 不缓存请求或响应的任何内容                    |
    | no-transform    | 无           | 代理不可更改媒体类型                         |
    | must-revalidate | 无           | 可缓存但必须再向源服务器进行确认              |
    | proxy-revalidate| 无           | 要求中间缓存服务器对缓存的响应有效性再进行确认   |
    | max-age         | [秒]         | 响应的最大Age值                             |
    | s-maxage        | [秒]         | 公共缓存服务器响应的最大Age值                |
    | cache-extension | -            | 新指令标记（token）                          |


### Connection

Connection 首部字段具备如下两个作用。

- 控制不再转发给代理的首部字段
- 管理持久连接

### Date

首部字段 Date 表明创建 HTTP 报文的日期和时间。

### Pragma

Pragma 是 HTTP/1.1 之前版本的历史遗留字段，仅作为与 HTTP/1.0 的向后兼容而定义。

### Trailer

首部字段 Trailer 会事先说明在报文主体后记录了哪些首部字段。该首部字段可应用在 HTTP/1.1 版本分块传输编码时。

### Transfer-Encoding

Transfer-Encoding

首部字段 Transfer-Encoding 规定了传输报文主体时采用的编码方式。

### Upgrade

首部字段 Upgrade 用于检测 HTTP 协议及其他协议是否可使用更高的版本进行通信，其参数值可以用来指定一个完全不同的通信协议。

### Via

使用首部字段 Via 是为了追踪客户端与服务器之间的请求和响应报文的传输路径。

报文经过代理或网关时，会先在首部字段 Via 中附加该服务器的信息，然后再进行转发。这个做法和 traceroute 及电子邮件的 Received 首部的工作机制很类似。

首部字段 Via 不仅用于追踪报文的转发，还可避免请求回环的发生。所以必须在经过代理时附加该首部字段内容。

### Warning

`Warning: [警告码][警告的主机:端口号]“[警告内容]”([日期时间])`

HTTP/1.1 中定义了 7 种警告。警告码对应的警告内容仅推荐参考。另外，警告码具备扩展性，今后有可能追加新的警告码。

![HTTP/1.1 警告码](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/61d4cb64-1216-4254-830b-e1343376b712/Untitled.png)

HTTP/1.1 警告码

| 警告码 | 警告内容                           | 说明                                     |
|-------|-----------------------------------|-----------------------------------------|
| 110   | Response is stale（响应已过期）    | 代理返回已过期的资源                      |
| 111   | Revalidation failed（再验证失败） | 代理再验证资源有效性时失败（服务器无法到达等原因） |
| 112   | Disconnection operation（断开连接操作） | 代理与互联网连接被故意切断                  |
| 113   | Heuristic expiration（试探性过期） | 响应的使用期超过24小时（有效缓存的设定时间大于24小时的情况下） |
| 199   | Miscellaneous warning（杂项警告） | 任意的警告内容                            |
| 214   | Transformation applied（使用了转换） | 代理对内容编码或媒体类型等执行了某些处理时  |
| 299   | Miscellaneous persistent warning（持久杂项警告） | 任意的警告内容                        |

## 请求首部字段

请求首部字段是从客户端往服务器端发送请求报文中所使用的字段，用于补充请求的附加信息、客户端信息、对响应内容相关的优先级等内容。

### Accept

```plaintext
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
```

Accept 首部字段可通知服务器，用户代理能够处理的媒体类型及媒体类型的相对优先级。可使用 type/subtype 这种形式，一次指定多种媒体类型。

试举几个媒体类型的例子。
- 文本文件
    text/html, text/plain, text/css ...
    application/xhtml+xml, application/xml ...
- 图片文件
    image/jpeg, image/gif, image/png ...
- 视频文件
    video/mpeg, video/quicktime ...
- 应用程序使用的二进制文件
    application/octet-stream, application/zip ...

比如，如果浏览器不支持 PNG 图片的显示，那 Accept 就不指定image/png，而指定可处理的 image/gif 和 image/jpeg 等图片类型。

若想要给显示的媒体类型增加优先级，则使用 q= 来额外表示权重值1，用分号（;）进行分隔。权重值 q 的范围是 0~1（可精确到小数点后 3 位），且 1 为最大值。不指定权重 q 值时，默认权重为 q=1.0。

### Accept-Charset

```plaintext
Accept-Charset: iso-8859-5, unicode-1-1;q=0.8
```

Accept-Charset 首部字段可用来通知服务器用户代理支持的字符集及字符集的相对优先顺序。另外，可一次性指定多种字符集。与首部字段 Accept 相同的是可用权重 q 值来表示相对优先级。

该首部字段应用于内容协商机制的服务器驱动协商。

### Accept-Encoding

```plaintext
Accept-Encoding: gzip, deflate
```

Accept-Encoding 首部字段用来告知服务器用户代理支持的内容编码及内容编码的优先级顺序。可一次性指定多种内容编码。

下面试举出几个内容编码的例子。

- gzip

    由文件压缩程序 gzip（GNU zip）生成的编码格式（RFC1952），采用 Lempel-Ziv 算法（LZ77）及 32 位循环冗余校验（Cyclic Redundancy Check，通称 CRC）。

- compress

    由 UNIX 文件压缩程序 compress 生成的编码格式，采用 Lempel-Ziv-Welch 算法（LZW）。

- deflate

    组合使用 zlib 格式（RFC1950）及由 deflate 压缩算法（RFC1951）生成的编码格式。

- identity

    不执行压缩或不会变化的默认编码格式

采用权重 q 值来表示相对优先级，这点与首部字段 Accept 相同。另外，也可使用星号（*）作为通配符，指定任意的编码格式。

### Accept-Language

```plaintext
Accept-Language: zh-cn,zh;q=0.7,en-us,en;q=0.3
```

首部字段 Accept-Language 用来告知服务器用户代理能够处理的自然语言集（指中文或英文等），以及自然语言集的相对优先级。可一次指定多种自然语言集。

和 Accept 首部字段一样，按权重值 q 来表示相对优先级。客户端在服务器有中文版资源的情况下，会请求其返回中文版对应的响应，没有中文版时，则请求返回英文版响应。

### Authorization

```plaintext
Authorization: Basic dWVub3NlbjpwYXNzd29yZA==
```

首部字段 Authorization 是用来告知服务器，用户代理的认证信息（证书值）。通常，想要通过服务器认证的用户代理会在接收到返回的401 状态码响应后，把首部字段 Authorization 加入请求中。共用缓存在接收到含有 Authorization 首部字段的请求时的操作处理会略有差异。

有关 HTTP 访问认证及 Authorization 首部字段，稍后的章节还会详细说明。另外，读者也可参阅 RFC2616。

### Expect

```plaintext
Expect: 100-continue
```

客户端使用首部字段 Expect 来告知服务器，期望出现的某种特定行为。因服务器无法理解客户端的期望作出回应而发生错误时，会返回状态码 417 Expectation Failed。

客户端可以利用该首部字段，写明所期望的扩展。虽然 HTTP/1.1 规范只定义了 100-continue（状态码 100 Continue 之意）。

等待状态码 100 响应的客户端在发生请求时，需要指定 Expect:100-continue。

### From

首部字段 From 用来告知服务器使用用户代理的用户的电子邮件地址。通常，其使用目的就是为了显示搜索引擎等用户代理的负责人的电子邮件联系方式。使用代理时，应尽可能包含 From 首部字段（但可能会因代理不同，将电子邮件地址记录在 User-Agent 首部字段内）。

### Host

```plaintext
Host: www.hackr.jp
```

首部字段 Host 会告知服务器，请求的资源所处的互联网主机名和端口号。Host 首部字段在 HTTP/1.1 规范内是唯一一个必须被包含在请求内的首部字段。

首部字段 Host 和以单台服务器分配多个域名的虚拟主机的工作机制有很密切的关联，这是首部字段 Host 必须存在的意义。

请求被发送至服务器时，请求中的主机名会用 IP 地址直接替换解决。但如果这时，相同的 IP 地址下部署运行着多个域名，那么服务器就会无法理解究竟是哪个域名对应的请求。因此，就需要使用首部字段 Host 来明确指出请求的主机名。若服务器未设定主机名，那直接发送一个空值即可。如下所示。

```plaintext
Host:
```

### If-Xxxx

形如 If-xxx 这种样式的请求首部字段，都可称为条件请求。服务器接收到附带条件的请求后，只有判断指定条件为真时，才会执行请求。

#### If-Match

```plaintext
If-Match: "123456"
```

首部字段 If-Match，属附带条件之一，它会告知服务器匹配资源所用的实体标记（ETag）值。这时的服务器无法使用弱 ETag 值。（请参照本章有关首部字段 ETag 的说明）

服务器会比对 If-Match 的字段值和资源的 ETag 值，仅当两者一致时，才会执行请求。反之，则返回状态码 412 Precondition Failed 的响应。

还可以使用星号（*）指定 If-Match 的字段值。针对这种情况，服务器将会忽略 ETag 的值，只要资源存在就处理请求。

#### If-Modified-Since

```plaintext
If-Modified-Since: Thu, 15 Apr 2004 00:00:00 GMT
```

首部字段 If-Modified-Since，属附带条件之一，它会告知服务器若 If-Modified-Since 字段值早于资源的更新时间，则希望能处理该请求。而在指定 If-Modified-Since 字段值的日期时间之后，如果请求的资源都没有过更新，则返回状态码 304 Not Modified 的响应。

If-Modified-Since 用于确认代理或客户端拥有的本地资源的有效性。获取资源的更新日期时间，可通过确认首部字段 Last-Modified 来确定。

#### If-None-Match

只有在 If-None-Match 的字段值与 ETag 值不一致时，可处理该请求。与 If-Match 首部字段的作用相反

首部字段 If-None-Match 属于附带条件之一。它和首部字段 If-Match作用相反。用于指定 If-None-Match 字段值的实体标记（ETag）值与请求资源的 ETag 不一致时，它就告知服务器处理该请求。

在 GET 或 HEAD 方法中使用首部字段 If-None-Match 可获取最新的资源。因此，这与使用首部字段 If-Modified-Since 时有些类似。

#### If-Range

首部字段 If-Range 属于附带条件之一。它告知服务器若指定的 If-Range 字段值（ETag 值或者时间）和请求资源的 ETag 值或时间相一致时，则作为范围请求处理。反之，则返回全体资源。

下面我们思考一下不使用首部字段 If-Range 发送请求的情况。服务器端的资源如果更新，那客户端持有资源中的一部分也会随之无效，当然，范围请求作为前提是无效的。这时，服务器会暂且以状态码 412 Precondition Failed 作为响应返回，其目的是催促客户端再次发送请求。这样一来，与使用首部字段 If-Range 比起来，就需要花费两倍的功夫。

#### If-Unmodified-Since

```plaintext
If-Unmodified-Since: Thu, 03 Jul 2012 00:00:00 GMT
```

首部字段 If-Unmodified-Since 和首部字段 If-Modified-Since 的作用相反。它的作用的是告知服务器，指定的请求资源只有在字段值内指定的日期时间之后，未发生更新的情况下，才能处理请求。如果在指定日期时间后发生了更新，则以状态码 412 Precondition Failed 作为响应返回。

### Max-Forwards

```plaintext
Max-Forwards: 10
```

通过 TRACE 方法或 OPTIONS 方法，发送包含首部字段 Max-Forwards 的请求时，该字段以十进制整数形式指定可经过的服务器最大数目。服务器在往下一个服务器转发请求之前，Max-Forwards 的值减 1 后重新赋值。当服务器接收到 Max-Forwards 值为 0 的请求时，则不再进行转发，而是直接返回响应。

使用 HTTP 协议通信时，请求可能会经过代理等多台服务器。途中，如果代理服务器由于某些原因导致请求转发失败，客户端也就等不到服务器返回的响应了。对此，我们无从可知。

可以灵活使用首部字段 Max-Forwards，针对以上问题产生的原因展开调查。由于当 Max-Forwards 字段值为 0 时，服务器就会立即返回响应，由此我们至少可以对以那台服务器为终点的传输路径的通信状况有所把握。

### Proxy-Authorization

```plaintext
Proxy-Authorization: Basic dGlwOjkpNLAGfFY5
```

接收到从代理服务器发来的认证质询时，客户端会发送包含首部字段Proxy-Authorization 的请求，以告知服务器认证所需要的信息。

这个行为是与客户端和服务器之间的 HTTP 访问认证相类似的，不同之处在于，认证行为发生在客户端与代理之间。客户端与服务器之间的认证，使用首部字段 Authorization 可起到相同作用。

### Range

```plaintext
Range: bytes=5001-10000
```

对于只需获取部分资源的范围请求，包含首部字段 Range 即可告知服务器资源的指定范围。上面的示例表示请求获取从第 5001 字节至第10000 字节的资源。

接收到附带 Range 首部字段请求的服务器，会在处理请求之后返回状态码为 206 Partial Content 的响应。无法处理该范围请求时，则会返回状态码 200 OK 的响应及全部资源。

### Referer

```plaintext
Referer: http://www.hackr.jp/index.htm
```

首部字段 Referer 会告知服务器请求的原始资源的 URI。

客户端一般都会发送 Referer 首部字段给服务器。但当直接在浏览器的地址栏输入 URI，或出于安全性的考虑时，也可以不发送该首部字段。

因为原始资源的 URI 中的查询字符串可能含有 ID 和密码等保密信息，要是写进 Referer 转发给其他服务器，则有可能导致保密信息的泄露。

另外，Referer 的正确的拼写应该是 Referrer，但不知为何，大家一直沿用这个错误的拼写。

### TE

```plaintext
TE: gzip, deflate;q=0.5
```

首部字段 TE 会告知服务器客户端能够处理响应的传输编码方式及相对优先级。它和首部字段 Accept-Encoding 的功能很相像，但是用于传输编码。

首部字段 TE 除指定传输编码之外，还可以指定伴随 trailer 字段的分块传输编码的方式。应用后者时，只需把 trailers 赋值给该字段值。

```plaintext
TE: trailers
```

### User-Agent

```plaintext
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20100101 Firefox/13.0.1
```

首部字段 User-Agent 会将创建请求的浏览器和用户代理名称等信息传达给服务器。

由网络爬虫发起请求时，经常用这个字段~~

## 响应首部字段

响应首部字段是由服务器端向客户端返回响应报文中所使用的字段，用于补充响应的附加信息、服务器信息，以及对客户端的附加要求等信息。

### Accept-Ranges

```plaintext
Accept-Ranges: bytes
```

首部字段 Accept-Ranges 是用来告知客户端服务器是否能处理范围请求，以指定获取服务器端某个部分的资源。

可指定的字段值有两种，可处理范围请求时指定其为 bytes，反之则指定其为 none。

### Age

```plaintext
Age: 600
```
首部字段 Age 能告知客户端，源服务器在多久前创建了响应。字段值的单位为秒。

若创建该响应的服务器是缓存服务器，Age 值是指缓存后的响应再次发起认证到认证完成的时间值。代理创建响应时必须加上首部字段 Age。

### ETag

```plaintext
ETag: "82e22293907ce725faf67773957acd12"
```

首部字段 ETag 能告知客户端实体标识。它是一种可将资源以字符串形式做唯一性标识的方式。服务器会为每份资源分配对应的 ETag 值。

另外，当资源更新时，ETag 值也需要更新。生成 ETag 值时，并没有统一的算法规则，而仅仅是由服务器来分配。

资源被缓存时，就会被分配唯一性标识。例如，当使用中文版的浏览器访问 <http://www.google.com/> 时，就会返回中文版对应的资源，而使用英文版的浏览器访问时，则会返回英文版对应的资源。两者的URI 是相同的，所以仅凭 URI 指定缓存的资源是相当困难的。若在下载过程中出现连接中断、再连接的情况，都会依照 ETag 值来指定资源。

**强 ETag 值和弱 Tag 值**

ETag 中有强 ETag 值和弱 ETag 值之分。

强 ETag 值，不论实体发生多么细微的变化都会改变其值。

```plaintext
ETag: "usagi-1234"
```

弱 ETag 值只用于提示资源是否相同。只有资源发生了根本改变，产生差异时才会改变 ETag 值。这时，会在字段值最开始处附加 W/。

```plaintext
ETag: W/"usagi-1234"
```

### Location

```plaintext
Location: http://www.usagidesign.jp/sample.html
```

使用首部字段 Location 可以将响应接收方引导至某个与请求 URI 位置不同的资源。
基本上，该字段会配合 3xx ：Redirection 的响应，提供重定向的 URI。

几乎所有的浏览器在接收到包含首部字段 Location 的响应后，都会强制性地尝试对已提示的重定向资源的访问。


### Proxy-Authenticate

```plaintext
Proxy-Authenticate: Basic realm="Usagidesign Auth"
```

首部字段 Proxy-Authenticate 会把由代理服务器所要求的认证信息发送给客户端。

它与客户端和服务器之间的 HTTP 访问认证的行为相似，不同之处在于其认证行为是在客户端与代理之间进行的。而客户端与服务器之间进行认证时，首部字段 WWW-Authorization 有着相同的作用。

### Retry-After

```plaintext
Retry-After: 120
```

首部字段 Retry-After 告知客户端应该在多久之后再次发送请求。主要配合状态码 503 Service Unavailable 响应，或 3xx Redirect 响应一起使用。

字段值可以指定为具体的日期时间（Wed, 04 Jul 2012 06：34：24 GMT 等格式），也可以是创建响应后的秒数。

### Server

```plaintext
Server: Apache/2.2.17 (Unix)
```

首部字段 Server 告知客户端当前服务器上安装的 HTTP 服务器应用程序的信息。不单单会标出服务器上的软件应用名称，还有可能包括版本号和安装时启用的可选项。

```plaintext
Server: Apache/2.2.6 (Unix) PHP/5.2.5
```

### Vary

```plaintext
Vary: Accept-Language
```

首部字段 Vary 可对缓存进行控制。源服务器会向代理服务器传达关于本地缓存使用方法的命令。

从代理服务器接收到源服务器返回包含 Vary 指定项的响应之后，若再要进行缓存，仅对请求中含有相同 Vary 指定首部字段的请求返回缓存。即使对相同资源发起请求，但由于 Vary 指定的首部字段不相同，因此必须要从源服务器重新获取资源。

### WWW-Authenticate

```plaintext
WWW-Authenticate: Basic realm="Usagidesign Auth"
```

首部字段 WWW-Authenticate 用于 HTTP 访问认证。它会告知客户端适用于访问请求 URI 所指定资源的认证方案（Basic 或是 Digest）和带参数提示的质询（challenge）。状态码 401 Unauthorized 响应中，肯定带有首部字段 WWW-Authenticate。

上述示例中，realm 字段的字符串是为了辨别请求 URI 指定资源所受到的保护策略。有关该首部，请参阅本章之后的内容。

## 实体首部字段

实体首部字段是包含在请求报文和响应报文中的实体部分所使用的首部，用于补充内容的更新时间等与实体相关的信息。

### Allow

### Content-Encoding

### Content-Language

### Content-Length

### Content-Location

### Content-MD5

### Content-Range

### Content-Type

### Expires

### Last-Modified

## 为 Cookie 服务的首部字段

Cookie 的工作机制是用户识别及状态管理。Web 网站为了管理用户的状态会通过 Web 浏览器，把一些数据临时写入用户的计算机内。接着当用户访问该 Web 网站时，可通过通信方式取回之前发放的
Cookie。

调用 Cookie 时，由于可校验 Cookie 的有效期，以及发送方的域、路径、协议等信息，所以正规发布的 Cookie 内的数据不会因来自其他 Web 站点和攻击者的攻击而泄露。

| 首部字段名   | 说明                               | 首部类型      |
|------------|-----------------------------------|--------------|
| Set-Cookie | 开始状态管理所使用的Cookie信息        | 响应首部字段  |
| Cookie     | 服务器接收到的Cookie信息              | 请求首部字段  |

### Set-Cookie

```plaintext
Set-Cookie: status=enable; expires=Tue, 05 Jul 2011 07:26:31 GMT; path=/; domain=.hackr.jp;
```

当服务器准备开始管理客户端的状态时，会事先告知各种信息。

下面的表格列举了 Set-Cookie 的字段值。

Set-Cookie 字段的属性

| 属性          | 说明                                     |
|--------------|-----------------------------------------|
| NAME=VALUE   | 赋予 Cookie 的名称和其值（必需项）            |
| expires=DATE | Cookie 的有效期（若不明确指定则默认为浏览器关闭前为止） |
| path=PATH    | 将服务器上的文件目录作为Cookie的适用对象（若不指定则默认为文档所在的文件目录） |
| domain=域名  | 作为 Cookie 适用对象的域名 （若不指定则默认为创建 Cookie 的服务器的域名） |
| Secure       | 仅在 HTTPS 安全通信时才会发送 Cookie            |
| HttpOnly     | 加以限制，使 Cookie 不能被 JavaScript 脚本访问  |


### Cookie

```plaintext
Cookie: status=enable
```

首部字段 Cookie 会告知服务器，当客户端想获得 HTTP 状态管理支持时，就会在请求中包含从服务器接收到的 Cookie。接收到多个 Cookie 时，同样可以以多个 Cookie 形式发送。



## 其他首部字段

