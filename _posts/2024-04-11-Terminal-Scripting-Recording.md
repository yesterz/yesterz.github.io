---
title: script：记录终端会话
date: 2024-04-11 21:19:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
media_subpath: /assets/images/2024-04-11-Complete-apt-Command-Guide-for-Ubuntu
---


script：记录终端会话

script 命令允许你在 Linux 终端中记录所有输入和输出的交互过程。启动它就像开启了一场终端对话的录音，每一步操作都将被记录。

使用示例：

```bash
script -tsession.timing session.log
```

这条命令会启动会话录制，并将所有终端的输入输出保存到 session.log 文件中。你可以像平常一样在终端中操作，所有操作都会被记录下来。直到输入`exit`或关闭终端，录制才会结束。

`-t`选项的使用及说明如下：

`-t[file]`, `--timing[=file]`，表示将计时数据输出到 file 文件，这个文件用于记录每个命令之间的时间间隔，以便回放时能够按照原始速度进行。


scriptreplay：回放终端历史

有了 script 记录下的会话日志，scriptreplay 就能发挥作用了。它能读取这些日志文件，并按照原始的时间间隔和速度进行回放。

使用示例：

```bash
scriptreplay session.timing session.log
```

这里，session.timing 和 session.log 是通过 script 命令创建的计时文件和终端输入输出记录文件。执行以上命令后，你将在终端中看到此前的操作过程如电影般一幕幕重现。

常用选项：

`-d`, `--divisor number`：调整回放速度。number 是一个浮点数，用原始速度除以这个值，number>1 加快回放速度。

`-m`, `--maxdelay number`：设置回放过程中最大延迟秒数。number 是一个浮点数，这可以用来避免回放中的长时间暂停。

例如：录制会话时，假如有执行 sleep 6，回放时正常将停顿5秒，使用 -d 2 停顿时间减半，使用 -m 2 最长停顿 2 秒。