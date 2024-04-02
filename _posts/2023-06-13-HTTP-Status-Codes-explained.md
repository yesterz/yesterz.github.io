---
title: 返回结果的 HTTP 状态码
date: 2023-06-13 21:09:00 +0800
author: 
categories: [Computer Networking]
tags: [Computer Networking]
pin: false
math: false
mermaid: false
---

## 1xx: Informational

状态码告知从服务器端返回的请求结果

状态码的职责是当客户端向服务器端发送请求时，描述返回的请求结果。

**状态码构成：**

- 3位数字和原因短语组成，如 `200 OK`
- 第 1 位指定了响应类别，后两位无分类

**状态码的类别**

|      | 类别                             | 原因短语                   |
| ---- | -------------------------------- | -------------------------- |
| 1XX  | Informational（信息性状态码）    | 接收的请求正在处理         |
| 2XX  | Success（成功状态码）            | 请求正常处理完毕           |
| 3XX  | Redirection（重定向状态码）      | 需要进行附加操作以完成请求 |
| 4XX  | Client Error（客户端错误状态码） | 服务器无法处理请求         |
| 5XX  | Server Error（服务器错误状态码） | 服务器处理请求出错         |

## 2xx: Success

2XX 的响应结果表明请求被正确处理了

- 200 OK

- 204 No Content

  该状态码代表服务器接受的请求已成功处理，但在返回的响应报文中不含实体的主体部分。另外，也不允许返回任何实体的主体。一般在只需要从客户端往服务器发送信息，而对客户端不需要发送新信息内容的情况下使用。

- 206 Partial Content

  该状态码表示客户端进行了范围请求，而服务器成功执行了这部分的 GET 请求。响应报文中包含由 Content-Range 指定范围的实体内容。

## 3xx: Redirection

3XX 响应结果表明浏览器需要执行某些特殊的处理以正确处理请求

- 301 Moved Permanently

  永久性重定向。该状态码表示请求的资源已被分配了新的 URI，以后应使用资源现在所指的 URI。

- 302 Found

  临时性重定向。该状态码表示请求的资源已被分配了新的 URI，希望用户（本次）能使用新的 URI 访问。

- 303 See Other

  该状态码表示由于请求对应的资源存在着另一个 URI，应使用 GET 方法定向获取请求的资源。

- 304 Not Modified

  该状态码表示客户端发送附带条件的请求时，服务器端允许请求访问资源，但未满足条件的情况。304 状态码返回时，不包含任何响应的主体部分。

- 307 Temporary Redirect

  临时重定向。该状态码与 302 Found 有着相同的含义。

## 4xx: Client error

4XX 的响应结果表明客户端时发生错误的原因所在。

- 400 Bad Request

  该状态码表示请求报文中存在语法错误。

- 401 Unauthorized

  该状态码表示发送的请求需要有通过 HTTP 认证（BASIC 认证、DIGEST 认证）的认证信息。另外若之前已进行过 1 次请求，则表示用户认证失败。

- 403 Forbidden

  该状态码表明对请求资源的访问被服务器拒绝了。

- 404 Not Found

  该状态码表明服务器上无法找到请求的资源。除此之外，也可以在服务器端拒绝请求且不想说明理由时使用。

## 5xx: Server error

5XX 的响应结果表明服务器本身发生错误

- 500 Internal Server Error

  表明服务器端在执行请求时发生了错误。也有可能是 Web 应用存在的 Bug 或某些临时的故障。

- 503 Service Unavailable

  表明服务器暂时处于超负载或正在进行停机维护，现在无法处理请求。如果事先得知解除以上状况需要的时间，最好写入 RetryAfter 首部字段再返回给客户端。

> 有时候状态码和状况不一致，服务器发生错误，但依然返回 200 OK

## Reference

HTTP Status Codes <https://http.dev/status>