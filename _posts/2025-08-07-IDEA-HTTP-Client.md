---
title: IDEA HTTP Client
date: 2025-08-07 16:12:00 +0800
author: 
categories: []
tags: []
pin: false
math: false
mermaid: false
---



IntelliJ IDEA HTTP Client 官方文档：<https://www.jetbrains.com/help/idea/2025.1/http-client-in-product-code-editor.html>



请求的语法基本上和 HTTP 协议内容是一致的，结构如下

```plaintext
### 使用三个 # 来分隔多个请求

GET/POST 请求地址（可拼接查询参数）
请求头键值对

请求体

> {% %}

# 响应处理
# 使用 >符号 打头，和 Shell 很像，然后用 {% %} 括起来的脚本内容
# 在脚本中可以使用 Javascript 原生语法，这就很强大了
# 脚本中有2个内置对象 client 表示当前客户端，response 表示响应结果
```

* client 会存储会话元数据，这些元数据可以在脚本内部进行修改。客户端的会话状态会一直保留，直到你关闭 IntelliJ IDEA。

* response 包含有关接收到的响应的信息，例如其内容类型、状态码、响应体等。



处理响应 -> 将脚本插入请求中

以 `>` 开头，然后把脚本包装在 `{%%}` 里面。

例如：

```
> {%
    client.test("Request executed successfully", function() {
        client.assert(response.status === 200, "Response status is not 200");
    });
    client.global.set("accessToken", response.body.results.accessToken);
    client.global.set("userDTOId", response.body.results.userDTO.id);
    client.log("accessToken: " + response.body.results.accessToken);
    client.log("userDTOId: " + response.body.results.userDTO.id);
%}
```

存储变量，通过 `client.global.set` 存储全局变量，通过 `client.global.get` 获取变量。还可以通过变量获取值`{{变量名}}`。

例如：

```plaintext
POST http://localhost:80/api/item?id=99
content-type: application/json;charset=UTF-8
Authorization: Bearer {{accessToken}}
uaaId: {{userDTOId}}

{
    "variable": "XXX",
    "otherVariable": "XXXXXX"
}
```
