---
title: Install openjdk-17-source
author: 
date: 2024-12-06 11:17:06 +0800
categories: [Uncategorized]
tags: [Uncategorized]
pin: false
math: false
mermaid: false
---

```shell
➜  java-17-openjdk-amd64 apt-get -h
apt 2.4.13 (amd64)
用法： apt-get [选项] 命令
　　　 apt-get [选项] install|remove 软件包1 [软件包2 ...]
　　　 apt-get [选项] source 软件包1 [软件包2 ...]

apt-get 可以从认证软件源下载软件包及相关信息，以便安装和升级软件包，
或者用于移除软件包。在这些过程中，软件包依赖会被妥善处理。

常用命令：
  update - 取回更新的软件包列表信息
  upgrade - 进行一次升级
  install - 安装新的软件包（注：软件包名称应当类似 libc6 而非 libc6.deb）
  reinstall - 重新安装软件包（注：软件包名称应当类似 libc6 而非 libc6.deb）
  remove - 卸载软件包
  purge - 卸载并清除软件包的配置
  autoremove - 卸载所有自动安装且不再使用的软件包
  dist-upgrade - 发行版升级，见 apt-get(8)
  dselect-upgrade - 根据 dselect 的选择来进行升级
  build-dep - 为源码包配置所需的编译依赖关系
  satisfy - 使系统满足依赖关系字符串
  clean - 删除所有已下载的包文件
  autoclean - 删除已下载的旧包文件
  check - 核对以确认系统的依赖关系的完整性
  source - 下载源码包文件
  download - 下载指定的二进制包到当前目录
  changelog - 下载指定软件包，并显示其变更日志（changelog）

参见 apt-get(8) 以获取更多关于可用命令的信息。
程序配置选项及语法都已经在 apt.conf(5) 中阐明。
欲知如何配置软件源，请参阅 sources.list(5)。
软件包及其版本偏好可以通过 apt_preferences(5) 来设置。
关于安全方面的细节可以参考 apt-secure(8).
                                         本 APT 具有超级牛力。
➜  java-17-openjdk-amd64 apt -h
apt 2.4.13 (amd64)
用法： apt [选项] 命令

命令行软件包管理器 apt 提供软件包搜索，管理和信息查询等功能。
它提供的功能与其他 APT 工具相同（像 apt-get 和 apt-cache），
但是默认情况下被设置得更适合交互。

常用命令：
  list - 根据名称列出软件包
  search - 搜索软件包描述
  show - 显示软件包细节
  install - 安装软件包
  reinstall - 重新安装软件包
  remove - 移除软件包
  autoremove - 卸载所有自动安装且不再使用的软件包
  update - 更新可用软件包列表
  upgrade - 通过 安装/升级 软件来更新系统
  full-upgrade - 通过 卸载/安装/升级 来更新系统
  edit-sources - 编辑软件源信息文件
  satisfy - 使系统满足依赖关系字符串

参见 apt(8) 以获取更多关于可用命令的信息。
程序配置选项及语法都已经在 apt.conf(5) 中阐明。
欲知如何配置软件源，请参阅 sources.list(5)。
软件包及其版本偏好可以通过 apt_preferences(5) 来设置。
关于安全方面的细节可以参考 apt-secure(8).
                                         本 APT 具有超级牛力。
➜  java-17-openjdk-amd64 apt search openjdk-17
正在排序... 完成
全文搜索... 完成
openjdk-17-dbg/jammy-security,jammy-updates 17.0.13+11-2ubuntu1~22.04 amd64
  Java runtime based on OpenJDK (debugging symbols)

openjdk-17-demo/jammy-security,jammy-updates 17.0.13+11-2ubuntu1~22.04 amd64
  Java runtime based on OpenJDK (demos and examples)

openjdk-17-doc/jammy-security,jammy-updates 17.0.13+11-2ubuntu1~22.04 all
  OpenJDK Development Kit (JDK) documentation

openjdk-17-jdk/jammy-security,jammy-updates,now 17.0.13+11-2ubuntu1~22.04 amd64 [已安装]
  OpenJDK Development Kit (JDK)

openjdk-17-jdk-headless/jammy-security,jammy-updates,now 17.0.13+11-2ubuntu1~22.04 amd64 [已安装，自动]
  OpenJDK Development Kit (JDK) (headless)

openjdk-17-jre/jammy-security,jammy-updates,now 17.0.13+11-2ubuntu1~22.04 amd64 [已安装，自动]
  OpenJDK Java 运行时环境，使用 Hotspot JIT

openjdk-17-jre-headless/jammy-security,jammy-updates,now 17.0.13+11-2ubuntu1~22.04 amd64 [已安装，自动]
  OpenJDK Java runtime, using Hotspot JIT (headless)

openjdk-17-jre-zero/jammy-security,jammy-updates 17.0.13+11-2ubuntu1~22.04 amd64
  Alternative JVM for OpenJDK, using Zero

openjdk-17-source/jammy-security,jammy-updates 17.0.13+11-2ubuntu1~22.04 all
  OpenJDK Development Kit (JDK) source files

➜  java-17-openjdk-amd64 apt install openjdk-17-source
E: 无法打开锁文件 /var/lib/dpkg/lock-frontend - open (13: 权限不够)
E: 无法获取 dpkg 前端锁 (/var/lib/dpkg/lock-frontend)，请查看您是否正以 root 用户运行？
➜  java-17-openjdk-amd64 sudo apt install openjdk-17-source
[sudo] risk 的密码：
对不起，请重试。
[sudo] risk 的密码：
对不起，请重试。
[sudo] risk 的密码：
正在读取软件包列表... 完成
正在分析软件包的依赖关系树... 完成
正在读取状态信息... 完成
下列【新】软件包将被安装：
  openjdk-17-source
升级了 0 个软件包，新安装了 1 个软件包，要卸载 0 个软件包，有 0 个软件包未被升级。
需要下载 46.8 MB 的归档。
解压缩后会消耗 51.9 MB 的额外空间。
获取:1 http://mirrors.aliyun.com/ubuntu jammy-security/universe amd64 openjdk-17-source all 17.0.13+11-2ubuntu1~22.04 [46.8 MB]
已下载 46.8 MB，耗时 3秒 (15.6 MB/s)
正在选中未选择的软件包 openjdk-17-source。
(正在读取数据库 ... 系统当前共安装有 131196 个文件和目录。)
准备解压 .../openjdk-17-source_17.0.13+11-2ubuntu1~22.04_all.deb  ...
正在解压 openjdk-17-source (17.0.13+11-2ubuntu1~22.04) ...
正在设置 openjdk-17-source (17.0.13+11-2ubuntu1~22.04) ...
➜  java-17-openjdk-amd64
```
