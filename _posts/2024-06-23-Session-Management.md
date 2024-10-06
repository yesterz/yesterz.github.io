---
title: 会话管理
date: 2024-06-23 11:15:00 +0800
author: 
categories: []
tags: []
pin: false
math: false
mermaid: false
---

* HTTP的基本性质

1. HTTP是简单的
2. HTTP是可扩展的
3. HTTP是无状态的，有会话的



* Cookie

是服务器发送到浏览器，并**保存在浏览器端的一小块数据**。浏览器下次访问该服务器时，会自动携带块该数据，将其发送给服务器，



* Session

是 JavaEE 的标准，用于**在服务端记录客户端信息**。

数据存放在服务端更加安全，但是也会增加服务端的内存压力。

## HTTP 是无状态，有会话的

HTTP是无状态的:在同一个连接中，两个执行成功的请求之间是没有关系的。这就带来了一个问题，用户没有办法在同一个网站中进行连续的交互，比如在一个电商网站里，用户把某个商品加入到购物车，切换一个页面后再次添加了商品，这两次添加商品的请求之间没有关联，浏览器无法知道用户最终选择了哪些商品。而使用HTTP的头部扩展，HTTPCookies就可以解决这个问题。把Cookies添加到头部中，创建一个会话让每次请求都能共享相同的上下文信息，达成相同的状态。

注意，HTTP 本质是无状态的，使用 Cookies 可以创建有状态的会话。

## HTTP Cookie

HTTP Cookie（也叫 Web Cookie 或浏览器 Cookie）是服务器发送到用户浏览器并保存在本地的一小块数据，它会在浏览器下次向同一服务器再发起请求时被携带并发送到服务器上。通常，它用于告知服务端两个请求是否来自同一浏览器，如保持用户的登录状态。Cookie 使基于无状态的 HTTP 协议记录稳定的状态信息成为了可能。

Cookie 主要用于以下三个方面:

1. 会话状态管理(如用户登录状态、购物车、游戏分数或其它需要记录的信息)
2. 个性化设置(如用户自定义设置、主题等)
3. 浏览器行为跟踪(如跟踪分析用户行为等)

Cookie 曾一度用于客户端数据的存储，因当时并没有其它合适的存储办法而作为唯一的存储手段，但现在随着现代浏览器开始支持各种各样的存储方式，Cookie 渐渐被淘汰。由于服务器指定 Cookie 后，浏览器的每次请求都会携带 Cookie 数据，会带来额外的性能开销(尤其是在移动环境下)。新的浏览器 API 已经允许开发者直接将数据存储到本地，如使用 Web storage API（本地存储和会话存储）或 IndexedDB

## Session 会话

1. 用户 Login 以后，为他创建一个session 对象；
2. 并把 session_key 返回给浏览器，让浏览器存储起来；
3. 浏览器将该值记录在浏览器的 cookie 里面；
4. 用户每次向服务器发送的访问，都会自动带上该网站所有的 cookie；
5. 此时服务器拿到 cookie 中的 session_key，在 Session Table 中检测是否存在，是否过期。

* Session Table

| Field       | Type        | Description                   |
| ----------- | ----------- | ----------------------------- |
| session_key | string      | 1个 hash 值，全局唯一，无规律 |
| user_id     | Foreign key | 指向 User Table               |
| expire_at   | timestamp   | 什么时候过期                  |

> **Cookie：**HTTP 协议中浏览器和服务器的沟通机制，服务器把一些用于标记用户身份的信息，传递给浏览器，浏览器每次访问任何网页链接的时候，都会在 HTTP 请求中带上所有的该网站相关的 Cookie 信息。Cookie 可以理解为一个 Client 端的 hash table.
{: .prompt-info }

## Session 三问

1. Session 记录过期以后,服务器会主动删除么？
2. 只支持在一台机器登陆和在多台机器同时登陆的区别是什么？
3. Session 适合存在什么数据存储系统中

## Read Later

1. <https://jakarta.ee/specifications/servlet/5.0/apidocs/jakarta/servlet/http/httpsession>
2. <https://jakarta.ee/specifications/platform/8/apidocs/> JDK1.8 -> javax.servlet.http -> Interface HttpSession
3. <https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html>
