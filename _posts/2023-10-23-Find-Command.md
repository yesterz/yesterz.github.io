---
title: 文件查找命令 find
date: 2023-10-23 20:10:00 +0800
author: 
categories: [Linux]
tags: [Shell]
pin: false
math: true
mermaid: false
---

## 文件查找命令 find

find 路径 查找条件 [补充条件]

如果想要找出更多的内容就需要**通配符，正则表达式**

* 精确匹配

```shell
cd /etc
find passwd
find /etc -name passwd
```

* 使用正则表达式，通配符

```shell
find /etc -name pass*
-regex
man find # /regex .*wd$
find /etc -regex .*wd
find /etc -regex .etc.*wd$
```

* 查找指定的文件类型

f 普通文件
d 目录

```shell
find /etc -type f -regex .*wd
```

* 按照时间来匹配

atime 文件的访问时间，文件访问了一次这个atime就会更新

ctime 文件i节点的时间，文件i节点发生变化，这个ctime就会变化

mtime 文件的内容

```shell
# 8小时内访问的
find /etc/ -atime 8
echo 123 > filea
stat filea
LANG=C stat filea
```

* 以某一个用户来查找

-user root -uid 0

* 找到文件后批量删除，查找到的文件

```shell
touch /tmp/{1..9}.txt
ls /tmp/*.txt
# -exec -ok
find *txt -exec rm -v {} \;
# -delete
```

上面用了一个转义字符`\`

```shell
grep pass /root/anaconda-ks.cfg
grep pass /root/anaconda-ks.cfg | cut -d " " -f 1
grep pass /root/anaconda-ks.cfg | cut -d " " -f 2
grep pass /root/anaconda-ks.cfg | cut -d " " -f 3
```

```shell
cut -d ":" -f7 /etc/passwd
cut -d ":" -f7 /etc/passwd | uniq -c
# uniq -c 只会对相邻的相同的行进行统计
cut -d ":" -f7 /etc/passwd | sort | uniq -c
cut -d ":" -f7 /etc/passwd | sort | uniq -c | sort -r
```