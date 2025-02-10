---
title: pstree 打印进程的树状结构
date: 2024-04-03 21:09:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
media_subpath: 
---

```bash
pstree [-A|U] [-up]
```

选项与参数：

`-A` 各进程树之间的连接以 ASCII 字符来连接；

`-U` 各进程树之间的连接以万国码的字符来连接。在某些终端接口下可能会有错误；

`-p` 并同时列出每个 process 的 PID；

`-u` 并同时列出每个 process 的所属账号名称。

## 列出目前系统上面所有的进程树的相关性

```bash
pstree -A
```

输出

```bash
systemd-+-ModemManager---2*[{ModemManager}]
        |-NetworkManager---2*[{NetworkManager}]
```

前面有数字，代表子进程的数量！

## 同时打印出 PID 与 users

```bash
pstree -Aup
```

输出

```bash
systemd(1)-+-ModemManager(1400)-+-{ModemManager}(1456)
           |                    `-{ModemManager}(1465)
           |-NetworkManager(1312)-+-{NetworkManager}(1403)
           |                      `-{NetworkManager}(1404)
```

在括号 () 内的即是 PID 以及该进程的 owner 喔！一般来说，如果该进程的所有人与父进程同，就不会列出，但是如果与父进程不一样，那就会列出该进程的拥有者！

由 pstree 的输出我们也可以很清楚的知道，所有的进程都是依附在 systemd 这支进程底下的！ 

仔细看一下，这支进程的 PID 是一号喔！因为他是由 Linux 核心所主动呼叫的第一支程序！

所以 PID 就是一号了。 这也是我们刚刚提到僵尸进程时有提到，为啥发生僵尸进程需要重新启动？ 因为

systemd 要重新启动，而重新启动 systemd 就是 reboot 啰！

如果还想要知道 PID 与所属使用者，加上 -u 及 -p 两个参数即可。我们前面不是一直提到， 如果子进程挂点或者是老是砍不掉子进程时，该如何找到父进程吗？

**Ans:** 当然是用这个 pstree 

## Reference

1. pstree - display a tree of processes. <https://www.man7.org/linux/man-pages/man1/pstree.1.html>
2. 《鸟哥的 Linux 私房菜》