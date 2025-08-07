---
title: RESTfull风格
date: 2025-07-01 09:28:00 +0800
author: Template
categories: [Template]
tags: [Template]
pin: false
math: false
mermaid: false
---



REST（Representational State Transfer）是 Roy Fielding 提出的一个描述互联系统架构风格的名词。REST 定义了一组体系架构原则，可以根据这些原则设计 Web 服务。

RESTfull 风格使用不同的 HTTP 方法来进行不同的操作，并且使用 HTTP 状态码来表示不同的结果。如 HTTP 的 GET 方法用于获取资源，HTTP 的 DELETE 方法用于删除资源。



HTTP 协议中，大致的请求方法如下：

1. GET：通过请求 URI 得到资源。

2. POST：用于添加新的资源。

3. PUT：用于修改某个资源，若不存在则添加。

4. DELETE：删除某个资源。

5. OPTIONS：询问可以执行哪些方法。

6. HEAD：类似于 GET，但是不返回 body 信息，用于检查资源是否存在，以及得到资源的元数据。

7. CONNECT：用于代理进行传输，如使用 SSL。

8. TRACE：用于远程诊断服务器。



在 RESTfull 风格中，资源的 CRUD 操作包括创建、读取、更新和删除操作，与 HTTP 方法之间有一个简单的对应关系：

1. 若要在服务器上创建资源，则应该使用 POST 方法。

2. 若要在服务器上检索某个资源，则应该使用 GET 方法。

3. 若要在服务器上更新某个资源，则应该使用 PUT 方法。

4. 若要在服务器上删除某个资源，则应该使用 DELETE 方法。
