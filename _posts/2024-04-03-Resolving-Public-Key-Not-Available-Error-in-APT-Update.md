---
title: 解决："The following signatures couldn't be verified..."
date: 2024-04-03 21:09:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
img_path: 
---

执行 apt update 时，会出现

```bash
The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 40976EAF437D05B5 NO_PUBKEY 3B4FE6ACC0B21F32
```

解决方法：

```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
```

然后再执行 apt update 就正常了

**From ChatGPT as follows:**

 在Linux系统中，APT（Advanced Package Tool）是一个包管理工具，用于安装、更新和删除软件包。当您运行apt update命令时，系统会尝试从软件源中下载软件包列表，并验证这些软件包的签名以确保其完整性和安全性。

在您遇到的情况中，出现了"The following signatures couldn’t be verified because the public key is not available"的错误提示，这意味着系统无法验证软件包的签名，因为缺少相应的公钥。每个软件包都有一个相关的公钥，用于验证其签名。

通过运行`sudo apt-key adv --keyserver ``keyserver.ubuntu.com`` --recv-keys 40976EAF437D05B5`命令，您实际上是在从指定的keyserver（密钥服务器）下载并导入缺失的公钥。这样，系统就可以使用这个公钥来验证软件包的签名，从而解决了签名验证失败的问题。

一旦导入了缺失的公钥，再次运行apt update命令时，系统就能够正确验证软件包的签名，从而正常更新软件包列表。这样可以确保您下载的软件包是完整和安全的。