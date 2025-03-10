---
title: 群晖NAS 怎么配置 SSH 公钥免密登录
categories: [Uncategorized]
tags: [Uncategorized]
toc: true
media_subpath: 
---

控制面板 -> 用户与群组 -> 高级设置 -> 家目录

启动家目录服务，打勾

首先 **SSH** 登录群晖，检测群晖当前用户主目录下是否有 .ssh 文件夹，如果没有使用下列命令创建：

```bash
mkdir ~/.ssh
```

2. 使用 `vim ~/.ssh/authorized_keys` 将自己的 **SSH** 公钥粘贴进去，按 `ESC` 输入 `wq` 并回车保存。
3. 如果没有公钥的话，需要在自己电脑上使用 `ssh-keygen -t rsa -C "MyName"` 创建一个密钥，然后使用 `cat ~/.ssh/id_rsa.pub`获取公钥信息，粘贴到**群晖**的 `~/.ssh/authorized_keys` 文件中。
4. 设置权限：

```bash
chmod 755 ~
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

**Ps: 群晖用户目录权限默认为 777，必须要修改为755才能免密登录**

5.修改 `sshd_config` 配置文件:

```bash
sudo vim /etc/ssh/sshd_config
```

修改上述文件中以下几个配置：

```text
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
```

6. 在群晖`控制面板 -> 终端机和 SNMP` 关闭再开启 `SSH`，即可免密登录群晖。
7. 如果设置成功后为了安全起见，建议在保存好 `密钥对（id_rsa 和 id_rsa.pub）`的情况下，关闭密码登录群晖 `SSH`。

修改 `sshd_config` 配置文件:

```bash
sudo vim /etc/ssh/sshd_config
```

修改上述文件中以下配置：

```text
PasswordAuthentication no
```

然后步骤 6 重启群晖 `SSH` 即可关闭密码登录群晖 `SSH`。