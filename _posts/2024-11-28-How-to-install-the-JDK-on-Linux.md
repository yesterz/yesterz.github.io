---
title: Linux 环境安装 JDK17
author: someone
date: 2024-11-28 14:50:00 +0800
categories: [Uncategorized]
tags: [Uncategorized]
pin: false
math: false
mermaid: false
---

* Java SE 17 Archive Downloads <https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html>
* Previous Java releases <https://www.oracle.com/java/technologies/downloads/archive/>

先运行如下命令，查看待安装主机的系统架构，然后根据操作系统的系统架构选择合适的 Java JDK 压缩包进行下载

```shell
[root@iZ7xv0pw76zi75nqelv576Z ~]# arch
x86_64
[root@iZ7xv0pw76zi75nqelv576Z ~]#

```

选择 Linux x64 Compressed Archive 版本，下载并校验文件完整性。

```shell
wget https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.tar.gz
[root@iZ7xv0pw76zi75nqelv576Z ~]# wget https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.tar.gz
--2024-11-28 21:49:11--  https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.tar.gz
正在解析主机 download.oracle.com (download.oracle.com)... 23.48.228.98
正在连接 download.oracle.com (download.oracle.com)|23.48.228.98|:443... 已连接。
已发出 HTTP 请求，正在等待回应... 200 OK
长度：182799609 (174M) [application/x-gzip]
正在保存至: “jdk-17.0.12_linux-x64_bin.tar.gz”

100%[===================================================================================>] 182,799,609 1.97MB/s 用时 89s

2024-11-28 21:50:43 (1.97 MB/s) - 已保存 “jdk-17.0.12_linux-x64_bin.tar.gz” [182799609/182799609])

[root@iZ7xv0pw76zi75nqelv576Z ~]# sha256sum jdk-17.0.12_linux-x64_bin.tar.gz
311f1448312ecab391fe2a1b2ac140d6e1c7aea6fbf08416b466a58874f2b40f  jdk-17.0.12_linux-x64_bin.tar.gz
[root@iZ7xv0pw76zi75nqelv576Z ~]#

```

将压缩包解压到 /opt 目录：

```shell
[root@iZ7xv0pw76zi75nqelv576Z ~]# tar -zxf jdk-17.0.12_linux-x64_bin.tar.gz -C /opt

```

为 Java JDK 配置系统环境变量 vim /etc/profile 添加如下内容：

```shell
# update $PATH
export PATH=$PATH:/opt/jdk-17.0.12/bin
# set JAVA_HOME
export JAVA_HOME=/opt/jdk-17.0.12
# set CLASSPATH
export CLASSPATH=.:$JAVA_HOME/lib

```

然后我们需要执行 source 命令，让系统重新读取环境变量，让新的系统环境变量配置生效

```shell
[root@iZ7xv0pw76zi75nqelv576Z ~]# source /etc/profile
[root@iZ7xv0pw76zi75nqelv576Z ~]# java -version
java version "17.0.12" 2024-07-16 LTS
Java(TM) SE Runtime Environment (build 17.0.12+8-LTS-286)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.12+8-LTS-286, mixed mode, sharing)
[root@iZ7xv0pw76zi75nqelv576Z ~]#

```

创建/usr/bin/java软连接，有些程序会使用/usr/bin/java

```shell
[root@iZ7xv0pw76zi75nqelv576Z bin]# ln -sf /opt/jdk-17.0.12/bin/java /usr/bin/java
[root@iZ7xv0pw76zi75nqelv576Z bin]# ls -alh java
lrwxrwxrwx 1 root root 25 Nov 28 21:56 java -> /opt/jdk-17.0.12/bin/java
[root@iZ7xv0pw76zi75nqelv576Z bin]# whereis java
java: /usr/bin/java /opt/jdk-17.0.12/bin/java
[root@iZ7xv0pw76zi75nqelv576Z bin]#

```

至此 Java JDK 的系统环境变量配置成功。

```shell
ln - make links between files

   -f, --force
          remove existing destination files
   -s, --symbolic
          make symbolic links instead of hard links
```
