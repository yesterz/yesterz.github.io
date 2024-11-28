---
title: ssh & scp 如何配置跳板机？
author: someone
date: 2024-11-28 14:50:00 +0800
categories: [Uncategorized]
tags: [Uncategorized]
pin: false
math: false
mermaid: false
---


## 1. SSH通过跳板机登录远程主机

```shell
ssh -J username@jump_server_ip_or_name:port username@endpoint_server_ip_or_name -p port
```

举例来说，跳板机的用户名为user1，IP为1.2.3.4，端口为22，目的服务器用户名为user2，IP为5.6.7.8，SSH端口为22，则命令为：

ssh -J user1@1.2.3.4:22 user2@5.6.7.8 -p 22

当然，如果端口默认就是22，也可以缩略如下：

ssh -J user1@1.2.3.4 user2@5.6.7.8

回车之后，只需要分别输入登录跳板服务器的用户的密码及登录目的服务器的用户的密码就可以了。


如果需要通过多个跳板机则以 `,` 分割：

```bash
ssh username@destination -p 22 -J username1@jump_server_1:22,username2@jump_server_2:22
```

其实就是使用SSH的`-J`参数，跟别的堡垒机的方法有所不同的是，这样可以大部分主机无需改动而直接进行当做跳板机使用。比如说我这种情况，无法直接从本地登录目的服务器，但是可以通过可以访问目的服务器的中间服务器进行登录目的服务器。

## 2. SCP通过跳板机登录远程主机

既然可以SSH通过跳板服务器登录远程服务器，那如果我们使用SCP进行上传下载是否也可以使用相同的方式连接呢？

摸索了一下，发现还真的可以，格式如下：

```shell
scp -P endpoint_server_port -o 'ProxyJump user1@jump_server_ip_or_name -p port' file.txt user2@endpoint_server_ip_or_name:~
```

举个例子就是：

```shell
scp -P 22 -o 'ProxyJump user@1.2.3.4 -p 22' file.txt user2@5.6.7.8:~
```

省略一些参数就是：

```shell
scp -o 'ProxyJump user@1.2.3.4' file.txt user2@5.6.7.8:~
```

其余跟普通scp命令一致，没啥特别的。

这种方法除了适用我上述说的本地无法直接访问目的服务器的方法之外，还能作为一个中转节点对文件上传下载进行加速，比如说，本地下载目的服务器上一个大文件，而本地到目的服务器网络并不是很理想，就可以找一个中转服务器加速本地到目的服务器之间的网络连接。

## 3. config, sshd_config配置

正常来说，上述命令是可以直接使用的，但是如果遇到不能直接将中间服务器当做跳板机的情况，可以检查一下跳板机的sshd_config文件，记得将如下内容的值改成如下形式：

```shell
# vim /etc/ssh/sshd_config
AllowTcpForwarding yes
PermitTunnel yes
```

改完之后重启一下跳板机的SSH服务端就好了（systemctl restart sshd.service）。

如果你觉得每次都需要加上 `-J` 的配置很多麻烦，可以写到配置文件里。修改配置文件 `~\.ssh\config`，默认没有需要自己创建。增加以下内容：

```bash
Host target    # 代表目标机器的名字
    HostName destination    # 这个是目标机器的 IP
    Port 22    # 目标机器 ssh 的端口
    User username_target    # 目标机器的用户名
    ProxyJump username@jump_server:port

Host 10.10.0.*    # 使用通配符 * 代表 10.10.0.1 - 10.10.0.255
    Port 22    # 服务器端口
    User username    # 服务器用户名
    ProxyJump username@jump_server:port
```

也可以为跳板机器一个“别名”方便使用：

```bash
Host tiaoban1    # 代表跳板机 1
    HostName # 跳板机 1 的 IP
    Port 22    # ssh 连接端口
    User username1    # 跳板机 1 的用户名

Host tiaoban2    # 代表跳板机 2
    HostName # 跳板机 2 的 IP
    Port 22    # ssh 连接端口
    User username2    # 跳板机 2 的用户名

Host target    # 代表目标机器的名字
    HostName # 目标机器 IP    # 这个是目标机器的 IP
    Port 22    # 目标机器 ssh 的端口
    User username_target    # 目标机器的用户名
    ProxyJump tiaoban1,tiaoban2

Host 10.10.0.*    # 使用通配符 * 代表 10.10.0.1 到 10.10.0.255
    Port 22    # 服务器端口
    User username    # 服务器用户名
    ProxyJump tiaoban1,tiaoban2
```

使用方法：

```bash
ssh target
ssh 10.10.0.1
ssh username@target -p22
ssh username@10.10.0.1 -p22
```
