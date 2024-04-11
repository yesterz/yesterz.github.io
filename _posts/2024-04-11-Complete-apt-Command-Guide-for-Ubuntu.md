---
title: Ubuntu 的 apt 命令用法
date: 2024-04-11 18:09:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
img_path: /assets/images/2024-04-11-Complete-apt-Command-Guide-for-Ubuntu
---

## 安装软件包
要安装一个软件包，使用以下命令：

```bash
sudo apt install <pkg_name>
```

例如，要安装Firefox浏览器，可以运行：

```bash
sudo apt install firefox
```

## 更新软件包列表

安装或更新软件包之前，最好先更新本地软件包列表。

运行以下命令：

```bash
sudo apt update
```

## 更新已安装的软件包

要更新已安装的软件包到最新版本，可以运行：

```bash
sudo apt upgrade
```

这会安装所有可用的更新。

## 搜索软件包

要搜索特定软件包，可以使用 apt的搜索功能。

例如，搜索名为 example 的软件包，可以运行：

```bash
apt search example
```

## 显示软件包信息

要查看软件包的详细信息，可以使用 apt 的`show`命令。

例如，要查看名为 example 的软件包信息，可以运行：

```bash
apt show example
```

## 移除软件包

要移除一个已安装的软件包，可以使用 apt 的`remove`命令。

例如，要移除名为 example 的软件包，可以运行：

```bash
sudo apt remove example
apt-get -purge remove # 把配置文件也删了
```

## 清理无用的安装包

apt 还可以清理系统中已下载的安装包文件。

运行以下命令：

```bash
sudo apt autoclean
```

将已经删除了的软件的安装文件从硬盘中删除掉。

## 清理无用的依赖项

如果系统中存在不再使用的依赖项，可以通过运行以下命令进行清理：

```bash
sudo apt autoremove
```

这会删除不再被其他软件包依赖的软件包。