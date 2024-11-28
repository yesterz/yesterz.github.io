---
title: Java™ Servlet 标准规范
author: someone
date: 2024-11-27 08:24:00 +0800
categories: [Uncategorized]
tags: [Uncategorized]
pin: false
math: false
mermaid: false
---

Java Servlet Specification <https://javaee.github.io/servlet-spec/>

## The Servlet Interface

## Overview

Q: Servlet 是什么？

Servlet 是一个基于 Java 技术实现的 Web 组件，它由容器进行管理，主要功能用来生成动态内容。如同其他基于 Java 技术的组件一样，servlet 是独立于平台的 Java 类被编译成平台无关的字节码，由 Java 技术的 Web 服务端动态加载和运行。容器又叫做 servlet 引擎，是 Java 服务端的扩展，可以提供 servlet 功能。Servlet 容器实现了 Servlet 与 Web 客户端通过request/response 进行交互通信。

## The Request

## Servlet Context

## The Response

## Filtering

## Sessions

## Annotations and pluggability

## Dispatching Requests

## Web Applications

## Application Lifecycle Events

## Mapping Requests to Servlets

## Security

## Deployment Descriptor

## Requirements related to other Specifications