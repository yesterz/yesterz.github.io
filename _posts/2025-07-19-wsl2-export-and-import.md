---
title: WSL2子系统的备份与还原
date: 2025-07-19 16:28:00 +0800
author: 
categories: [WSL]
tags: [WSL]
pin: false
math: false
mermaid: false
---

## 1. 准备工作

打开CMD，输入`wsl -l -v`查看WSL的名称与状态；

```
$ wsl -l -v
  NAME            STATE           VERSION
* Ubuntu-24.04    Running         2
```

本机的WSL全称为Ubuntu-24.04，输入 `wsl --shutdown` 使其停止运行，再次使用`wsl -l -v`确保其处于stopped状态。



## 2. 导出/恢复备份

在D盘创建一个目录用来存放新的WSL，比如我创建了一个 `G:\Ubuntu_WSL` 。

①导出它的备份（比如命名为Ubuntu.tar)

```text
wsl --export Ubuntu-24.04 G:\Ubuntu_WSL\Ubuntu.tar
```

②确定在此目录下可以看见备份Ubuntu.tar文件之后，注销原有的wsl

```text
wsl --unregister Ubuntu-24.04
```

③将备份文件恢复到`G:\Ubuntu_WSL`中去

```text
wsl --import Ubuntu-24.04 G:\Ubuntu_WSL G:\Ubuntu_WSL\Ubuntu.tar
```

这时候启动WSL，发现好像已经恢复正常了，但是用户变成了root，之前使用过的文件也看不见了。

## 3. 恢复默认用户

在CMD中，输入 `Linux发行版名称 config --default-user 原本用户名`

例如：

```bash
Ubuntu2204 config --default-user xxx
```

请注意，这里的发行版名称的版本号是纯数字，比如Ubuntu-24.04就是Ubuntu2404；

这时候再次打开WSL，你会发现一切都恢复正常了。

```
wsl --export Ubuntu-24.04 G:\Ubuntu_WSL\Ubuntu.tar
```



## 命令记录

```bash
C:\Users\Administrator>"G:\DevApp\Git\bin\bash.exe" --login

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl -l -v
  NAME            STATE           VERSION
* Ubuntu-24.04    Running         2

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --shutdown

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl -l -v
  NAME            STATE           VERSION
* Ubuntu-24.04    Stopped         2

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --export Ubuntu-24.04 G:\Ubuntu_WSL\Ubuntu.tar
正在导出，这可能需要几分钟时间。 (3847 MB): ./var/lib/docker/volumes/minikube/_data/lib/kubelet/device-plugins/kubelet.sock: pax
 format cannot archive sockets: ./var/lib/docker/volumes/minikube/_data/lib/kubelet/pod-resources/kubelet.sock: pax format canno
t archi (11016 MB)

操作成功完成。

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --unregister Ubuntu-24.04
正在注销。
操作成功完成。


Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --import Ubuntu-24.04 G:\Ubuntu_WSL G:\Ubuntu_WSL\Ubuntu.tar
系统找不到指定的文件。
错误代码: Wsl/ERROR_FILE_NOT_FOUND

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --import Ubuntu-24.04 G:\Ubuntu_WSL G:\Ubuntu_WSLUbuntu.tar
系统找不到指定的文件。
错误代码: Wsl/ERROR_FILE_NOT_FOUND

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --import Ubuntu-24.04 G:\Ubuntu_WSL G:\Ubuntu_WSLUbuntu.tar
[============              21.8%                           ]

操作成功完成。

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --unregister Ubuntu-24.04
正在注销。
操作成功完成。


Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --import Ubuntu-24.04 G:\Ubuntu_WSL G:\Ubuntu_WSL\Ubuntu.tar
系统找不到指定的文件。
错误代码: Wsl/ERROR_FILE_NOT_FOUND

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --import Ubuntu-24.04 G:\Ubuntu_WSL G:\Ubuntu_WSLUbuntu.tar
系统找不到指定的文件。
错误代码: Wsl/ERROR_FILE_NOT_FOUND

Administrator@DESKTOP-THB59EH MINGW64 ~
$ wsl --import Ubuntu-24.04 G:\Ubuntu_WSL G:\Ubuntu_WSLUbuntu.tar
操作成功完成。

Administrator@DESKTOP-THB59EH MINGW64 ~
$ ubuntu2404.exe config --default-user xxxx

Administrator@DESKTOP-THB59EH MINGW64 ~
$
```