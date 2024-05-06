---
title: Urllib 与 Requests
date: 2023-01-30 10:51:00 +0800
author: 
categories: [Python]
tags: [Python, Web Crawler]
pin: false
math: true
mermaid: false
img_path: /assets/images/
---

## 一、urllib 的学习

##### 学习目标

了解 urllib 的基本使用 

### 1、urllib 介绍

除了 requests 模块可以发送请求之外，urllib 模块也可以实现请求的发送，只是操作方法略有不同!

urllib 在 Python 中分为 urllib 和 urllib2，在 Python3 中为 urllib

下面以 Python3 的 urllib 为例进行讲解

### 2、urllib 的基本方法介绍

#### 2.1 urllib.Request

1. 构造简单请求

    ```python
    import urllib

    # 构造请求
    request = urllib.request.Request("http://www.baidu.com")
    # 发送请求获取响应
    response = urllib.request.urlopen(request)

    ```

2. 传入headers参数

    ```python
    import urllib

    # 构造headers
    headers = {
        "User-Agent": "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
    }
    # 构造请求
    request = urllib.request.Request(url, headers=headers)
    # 发送请求
    response = urllib.request.urlopen(request)

    ```

3. 传入data参数 实现发送post请求（示例）

   ```python
   import urllib.request
   import urllib.parse
   import json
   
   url = 'https://ifanyi.iciba.com/index.php?c=trans&m=fy&client=6&auth_user=key_ciba&sign=99730f3bf66b2582'
   
   headers = {
       'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15'   
   }
   data = {
       'from': 'zh',
       'to': 'en',
       'q': 'lucky 是一个帅气的老'
   }
   # 使用post方式
   # 需要
   data = urllib.parse.urlencode(data).encode('utf-8')
   req = urllib.request.Request(url, data=data, headers=headers)
   res = urllib.request.urlopen(req)
   print(res.getcode())
   print(res.geturl())
   data = json.loads(res.read().decode('utf-8'))
   print(data)
   ```

#### 2.2 response.read()

获取响应的 html 字符串，bytes 类型

```python
#发送请求
response = urllib.request.urlopen("http://www.baidu.com")
#获取响应
response.read()
```

### 3、urllib 请求百度首页的完整例子

```python
import urllib

url = "http://www.baidu.com"
# 构造 headers
headers = {
    "User-Agent": "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
}
# 构造请求
request = urllib.request.Request(url, headers=headers)
# 发送请求
response = urllib.request.urlopen(request)
# 获取 html 字符串
html_str = response.read().decode("utf-8")
print(html_str)
```

### 4、小结

1. urllib.request 中实现了构造请求和发送请求的方法
2. urllib.request.Request(url,headers,data) 能够构造请求
3. urllib.request.urlopen 能够接受 request 请求或者 url 地址发送请求，获取响应
4. response.read() 能够实现获取响应中的 bytes 字符串

# requests 模块的入门使用

## 一、requests 模块的入门使用

##### 学习目标：

1. 了解 requests 模块的介绍
2. 掌握 requests 的基本使用
3. 掌握 response 常见的属性
4. 掌握 requests.text 和 content 的区别
5. 掌握 解决网页的解码问题
6. 掌握 requests 模块发送带 headers 的请求
7. 掌握 requests 模块发送带参数的 get 请求

### 1、为什么要重点学习 requests 模块，而不是 urllib

- 企业中用的最多的就是 requests
- requests 的底层实现就是 urllib
- requests 在 Python2 和 Python3 中通用，方法完全一样
- requests 简单易用

### 2、requests 的作用与安装

作用：发送网络请求，返回响应数据

命令： `pip install requests`

requests 模块发送简单的 get 请求、获取响应

需求：通过 requests 向百度首页发送请求，获取百度首页的数据

```python
import requests

# 目标url
url = 'https://www.baidu.com'

# 向目标url发送get请求
response = requests.get(url)

# 打印响应内容
print(response.text)
```

**response 的常用属性：**

- `response.text` 响应体 str 类型

- `response.encoding`  从 HTTP header 中猜测的响应内容的编码方式

- `respones.content` 响应体 bytes 类型

- `response.status_code` 响应状态码

- `response.request.headers` 响应对应的请求头

- `response.headers` 响应头

- `response.cookies` 响应的 cookie（经过了set-cookie动作）

- `response.url ` 获取访问的 url

- `response.json()`  获取 json 数据，得到内容为字典 (如果接口响应体的格式是json格式时)

- `response.ok` 

  如果 status_code 小于等于 200，response.ok 返回 True。

  如果 status_code 大于 200，response.ok 返回 False。

**思考：text 是 response 的属性还是方法呢？**

- 一般来说名词，往往都是对象的属性，对应的动词是对象的方法

##### 3.1 response.text 和 response.content 的区别

- `response.text`
  - 类型：str
  - 解码类型： requests模块自动根据HTTP 头部对响应的编码作出有根据的推测，推测的文本编码
  - 如何修改编码方式：`response.encoding="gbk/UTF-8"`
- `response.content`
  - 类型：bytes
  - 解码类型： 没有指定
  - 如何修改编码方式：`response.content.deocde("utf8")`

获取网页源码的通用方式：

1. `response.content.decode()`
2. `response.content.decode("UTF-8")`
3. `response.text`

以上三种方法从前往后尝试，能够100%的解决所有网页解码的问题

所以：更推荐使用`response.content.deocde()`的方式获取响应的html页面

##### 3.2 练习：把网络上的图片保存到本地

> 我们来把`www.baidu.com`的图片保存到本地

**思考：**

- 以什么方式打开文件
- 保存什么格式的内容

**分析：**

- 图片的 url: https://www.baidu.com/img/bd_logo1.png
- 利用 requests 模块发送请求获取响应
- 以二进制写入的方式打开文件，并将 response 响应的二进制内容写入

```python
import requests

# 图片的 url
url = 'https://www.baidu.com/img/bd_logo1.png'

# 响应本身就是一个图片，并且是二进制类型
response = requests.get(url)

# print(response.content)

# 以二进制+写入的方式打开文件
with open('baidu.png', 'wb') as f:
    # 写入 response.content bytes 二进制类型
    f.write(response.content)
```

### 4、发送带 header 的请求

* 我们先写一个获取百度首页的代码

```python
import requests

url = 'https://www.baidu.com'

response = requests.get(url)

print(response.content)

# 打印响应对应请求的请求头信息
print(response.request.headers)
```

##### 4.1 思考

对比浏览器上百度首页的网页源码和代码中的百度首页的源码，有什么不同？

代码中的百度首页的源码非常少，为什么？

##### 4.2 为什么请求需要带上 header？

模拟浏览器，欺骗服务器，获取和浏览器一致的内容

##### 4.3 header 的形式：字典

```python
headers = {
  "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36"
  }
```

##### 4.4 用法

```python
requests.get(url, headers=headers)
```

##### 4.5 完整的代码

```python
import requests

url = 'https://www.baidu.com'

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36"}

# 在请求头中带上 User-Agent，模拟浏览器发送请求
response = requests.get(url, headers=headers)

# print(response.content)

# 打印请求头信息
print(response.request.headers)
```

### 5、发送带参数的请求

我们在使用百度搜索的时候经常发现 url 地址中会有一个 `?`，那么该问号后边的就是请求参数，又叫做查询字符串

##### 5.1 什么叫做请求参数：

例1： http://www.webkaka.com/tutorial/server/2015/021013/

例2：https://www.baidu.com/s?**wd=python&a=c**

例 1 中没有请求参数！

例 2 中 ? 后边的就是请求参数

##### 5.2 请求参数的形式：字典

```python
kw = {'wd':'长城'}
```

##### 5.3 请求参数的用法

```python
requests.get(url, params=kw)
```

##### 5.4 关于参数的注意点

在 url 地址中， 很多参数是没有用的，比如百度搜索的 url 地址，其中参数只有一个字段有用，其他的都可以删除 如何确定那些请求参数有用或者没用：挨个尝试！ 对应的,在后续的爬虫中，越到很多参数的 url 地址，都可以尝试删除参数

##### 5.5 两种方式：发送带参数的请求

+ 对`https://www.baidu.com/s?wd=python`发起请求可以使用`requests.get(url, params=kw)`的方式

  ```python
  # 方式一：利用 params 参数发送带参数的请求
  import requests

  headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36"}

  # 这是目标 url
  # url = 'https://www.baidu.com/s?wd=python'

  # 最后有没有问号结果都一样
  url = 'https://www.baidu.com/s?'

  # 请求参数是一个字典 即 wd=python
  kw = {'wd': 'python'}

  # 带上请求参数发起请求，获取响应
  response = requests.get(url, headers=headers, params=kw)

  # 当有多个请求参数时，requests 接收的 params 参数为多个键值对的字典，比如 '?wd=python&a=c'-->{'wd': 'python', 'a': 'c'}

  print(response.content)
  ```

+ 也可以直接对`https://www.baidu.com/s?wd=python`完整的 url 直接发送请求，不使用 params 参数

  ```python
  # 方式二：直接发送带参数的url的请求
  import requests
  
  headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36"}
  
  url = 'https://www.baidu.com/s?wd=python'
  
  # kw = {'wd': 'python'}
  
  # url中包含了请求参数，所以此时无需params
  response = requests.get(url, headers=headers)
  ```

### 6、小结

1. requests 模块的介绍：能够帮助我们发起请求获取响应
2. requests 的基本使用：`requests.get(url)`
3. 以及 response 常见的属性：
   - `response.text` 响应体 str 类型
   - `respones.content` 响应体 bytes 类型
   - `response.status_code` 响应状态码
   - `response.request.headers` 响应对应的请求头
   - `response.headers` 响应头
   - `response.request._cookies` 响应对应请求的 cookie
   - `response.cookies` 响应的 cookie（经过了set-cookie动作）
4. 掌握 requests.text 和 content 的区别：text 返回 str 类型，content 返回 bytes 类型
5. 掌握 解决网页的解码问题：
   - `response.content.decode()`
   - `response.content.decode("UTF-8")`
   - `response.text`
6. 掌握 requests 模块发送带 headers 的请求：`requests.get(url, headers={})`
7. 掌握 requests 模块发送带参数的 get 请求：`requests.get(url, params={})`



## 二、requests 模块的深入使用

##### 学习目标：

1. 能够应用 requests 发送 post 请求的方法
2. 能够应用 requests 模块使用代理的方法
3. 了解代理 ip 的分类

### 1、使用 requests 发送 POST 请求

**思考：哪些地方我们会用到 POST 请求？**

1. 登录注册（ POST 比 GET 更安全）
2. 需要传输大文本内容的时候（ POST 请求对数据长度没有要求）

所以同样的，我们的爬虫也需要在这两个地方回去模拟浏览器发送 post 请求

##### 1.1 requests 发送 post 请求语法：

- 用法：

  ```python
  response = requests.post("http://www.baidu.com/", data = data, headers=headers)
  ```

- data 的形式：字典

##### 1.2 POST请求练习

下面面我们通过金山翻译的例子看看post请求如何使用：

地址：https://www.iciba.com/fy

##### 思路分析

1. 抓包确定请求的 url 地址

   ![Packet_Capture_to_Determine_Request_URL_Address.png](UrllibAndRequests/Packet_Capture_to_Determine_Request_URL_Address.png)


2. 确定请求的参数

   ![Determine_Request_Parameters](UrllibAndRequests/Determine_Request_Parameters.png)

3. 确定返回数据的位置

   ![image-20220420152404175](UrllibAndRequests/image-20220420152404175.png)

4. 模拟浏览器获取数据

   ```python
   import requests
   import json
   
   headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36"}
   
   url = 'https://ifanyi.iciba.com/index.php?c=trans&m=fy&client=6&auth_user=key_ciba&sign=99730f3bf66b2582'
   
   data = {
       'from': 'zh',
       'to': 'en',
       'q': 'lucky 是一个帅气的老师'
   }
   
   res = requests.post(url, headers=headers, data=data)
   # print(res.status_code)
   
   # 返回的是json字符串 需要在进行转换为字典
   data = json.loads(res.content.decode('UTF-8'))
   # print(type(data))
   print(data)
   print(data['content']['out'])
   ```

#### 1.3 小结

在模拟登陆等场景，经常需要发送post请求，直接使用`requests.post(url,data)`即可

### 2、使用代理

##### 2.1 为什么要使用代理

1. 让服务器以为不是同一个客户端在请求
2. 防止我们的真实地址被泄露，防止被追究

##### 2.2 理解使用代理的过程

![Process_of_Using_Proxies](UrllibAndRequests/Process_of_Using_Proxies.png)

##### 2.3 理解正向代理和反向代理的区别

![Differences_Between_Forward_Proxy_and_Reverse_Proxy](UrllibAndRequests/Differences_Between_Forward_Proxy_and_Reverse_Proxy.png)

通过上图可以看出：

- 正向代理：对于浏览器知道服务器的真实地址，例如 VPN
- 反向代理：浏览器不知道服务器的真实地址，例如 nginx

**详细讲解：**

正向代理：客户端与正向代理客户端在同一局域网，客户端发出请求，正向代理 替代客户端向服务器发出请求。服务器不知道谁是真正的客户端，正向代理隐藏了真实的请求客户端。

反向代理：服务器与反向代理在同一个局域网，客服端发出请求，反向代理接收请求 ，反向代理服务器会把我们的请求分转发到真实提供服务的各台服务器Nginx就是性能非常好的反向代理服务器，用来做负载均衡

![20190715113403480](UrllibAndRequests/20190715113403480.png)

##### 2.4 代理的使用

- 用法：

  ```python
  requests.get("http://www.baidu.com",  proxies = proxies)
  ```

- proxies的形式：字典

- 例如：

  ```python
   proxies = {
        "http": "http://12.34.56.79:9527",
        "https": "https://12.34.56.79:9527",
  }
  ```

##### 2.5 代理 IP 的分类

根据代理 ip 的匿名程度，代理 IP 可以分为下面四类：

- 透明代理(Transparent Proxy)：透明代理的意思是客户端根本不需要知道有代理服务器的存在，但是它传送的仍然是真实的IP。使用透明代理时，对方服务器是可以知道你使用了代理的，并且他们也知道你的真实IP。你要想隐藏的话，不要用这个。透明代理为什么无法隐藏身份呢?因为他们将你的真实IP发送给了对方服务器，所以无法达到保护真实信息。
- 匿名代理(Anonymous Proxy)：匿名代理隐藏了您的真实IP，但是向访问对象可以检测是使用代理服务器访问他们的。会改变我们的请求信息，服务器端有可能会认为我们使用了代理。不过使用此种代理时，虽然被访问的网站不能知道你的ip地址，但仍然可以知道你在使用代理，当然某些能够侦测ip的网页也是可以查到你的ip。
- 高匿代理(Elite proxy或High Anonymity Proxy)：高匿名代理不改变客户机的请求，这样在服务器看来就像有个真正的客户浏览器在访问它，这时客户的真实IP是隐藏的，完全用代理服务器的信息替代了您的所有信息，就象您就是完全使用那台代理服务器直接访问对象，同时服务器端不会认为我们使用了代理。IPDIEA覆盖全球240＋国家地区ip高匿名代理不必担心被追踪。

在使用的使用，毫无疑问使用高匿代理效果最好

从请求使用的协议可以分为：

- http代理
- https代理
- socket 代理等

不同分类的代理，在使用的时候需要根据抓取网站的协议来选择

### 识别一个 IP 是不是代理 IP

主要有以下四种方法：

一、反向探测技术

扫描IP是不是开通了 80，8080 等代理服务器经常开通的端口，显然一个普通的用户IP不太可能开通如上的端口。

二、HTTP 头部的 X_Forwarded_For

开通了 HTTP 代理的 IP 可以通过此法来识别是不是代理 IP；如果带有 XFF 信息，该 IP 是代理 IP 无疑。

三、Keep-alive 报文

如果带有 Proxy-Connection 的 Keep-alive 报文，该 IP 毫无疑问是代理 IP。

四、查看 IP 上端口

如果一个 IP 有的端口大于 10000，那么该 IP 大多也存在问题，普通的家庭 IP 开这么大的端口几乎是不可能的。

这四种代理 IP 检测的方法几乎都是公开的，一些大公司为了避免恶意 IP 还会采取其他方法。比如利用网络爬虫爬取代理 IP 并作以标记，更有甚者，会通过业务建模收集恶意 IP，然后再通过协议扫描的方式来判断这些 IP 是不是代理 IP。

##### 2.6 代理 IP 使用的注意点

- 反反爬

  使用代理 ip 是非常必要的一种`反反爬`的方式

  但是即使使用了代理 ip，对方服务器任然会有很多的方式来检测我们是否是一个爬虫，比如：

  - 一段时间内，检测 IP 访问的频率，访问太多频繁会屏蔽

  - 检查 Cookie，User-Agent，Referer 等 header 参数，若没有则屏蔽

  - 服务方购买所有代理提供商，加入到反爬虫数据库里，若检测是代理则屏蔽

    所以更好的方式在使用代理 ip 的时候使用随机的方式进行选择使用，不要每次都用一个代理 ip

- 代理 ip 池的更新

  购买的代理ip很多时候大部分（超过60%）可能都没办法使用，这个时候就需要通过程序去检测哪些可用，把不能用的删除掉。

+ 代理服务器平台的使用：

  当然还有很多免费的，但是大多都不可用需要自己尝试

  + <http://www.66ip.cn>
  + <https://ip.jiangxianli.com/?page=1>
  + <https://www.zdaye.com>
  + <https://www.kuaidaili.com/free>

### 3、配置

+ 浏览器配置代理

  右边三点\==> 设置\==> 高级\==> 代理\==> 局域网设置\==> 为LAN使用代理==> 输入ip和端口号即可

  参考网址：<https://jingyan.baidu.com/article/a681b0dece76407a1843468d.html>

+ 代码配置

  urllib

  ```python
  handler = urllib.request.ProxyHandler({'http': '114.215.95.188:3128'})
  opener = urllib.request.build_opener(handler)
  # 后续都使用 opener.open 方法去发送请求即可
  ```

  requests

  ```python
  # 用到的库
  import requests
  # 写入获取到的 ip 地址到 proxy
  # 一个 ip 地址
  proxy = {
      'http':'http://221.178.232.130:8080'
  }
  """
  # 多个 ip 地址
  proxy = [
    {'http':'http://221.178.232.130:8080'},
    {'http':'http://221.178.232.130:8080'}
  ]
  import random
  proxy = random.choice(proxy)
  """
  
  # 使用代理
  proxy = {
      'http': 'http://58.20.184.187:9091'
  }
  
  result = requests.get("http://httpbin.org/ip", proxies=proxy)
  
  print(result.text)
  ```

### 4、小结

1. requests 发送 post 请求使用`requests.post`方法，带上请求体，其中请求体需要时字典的形式，传递给 data 参数接收
2. 在 requests 中使用代理，需要准备字典形式的代理，传递给`proxies`参数接收
3. 不同协议的 url 地址，需要使用不同的代理去请求