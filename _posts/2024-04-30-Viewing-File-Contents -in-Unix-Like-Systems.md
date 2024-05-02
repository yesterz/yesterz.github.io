---
title: 查看文件内容
date: 2024-04-30 17:18:00 +0800
author: 
categories: [Operating System]
tags: [Operating System, Coreutils]
pin: false
math: false
mermaid: false
img_path: 
---

## Preview

1. `at` 由第一行开始显示文件内容
2. `tac` 从最后一行开始显示，可以看出 tac 是 cat 的倒着写！
3. `nl` 显示的时候，顺道输出行号！
4. `more` 一页一页的显示文件内容
5. `less` 与 `more` 类似，但是比 `more` 更好的是，他可以往前翻页！
6. `head` 只看头几行
7. `tail` 只看尾巴几行
8. `od` 以二进制的方式读取文件内容！

## cat (concatenate)

```Bash
cat [-AbEnTv] file
```

选项与参数：

`-A` 相当于 -vET 的整合选项，可列出一些特殊字符而不是空白而已；

`-b` 列出行号，仅针对非空白行做行号显示，空白行不标行号！

`-E` 将结尾的断行字符 $ 显示出来；

`-n` 打印出行号，连同空白行也会有行号，与 -b 的选项不同；

`-T` 将 [tab] 按键以 ^I 显示出来；

`-v` 列出一些看不出来的特殊字符

## nl (添加行号打印)

```Bash
nl [-bnw] file
```

选项与参数：

`-b`  指定行号指定的方式，主要有两种：

1. `-b a`  表示不论是否为空行，也同样列出行号(类似 cat -n)；
2. `-b t`  如果有空行，空的那一行不要列出行号(默认值)；

`-n`  列出行号表示的方法，主要有三种：

1. `-n ln`  行号在屏幕的最左方显示；
2. `-n rn`  行号在自己字段的最右方显示，且不加 0 ；
3. `-n rz`  行号在自己字段的最右方显示，且加 0 ；

`-w` 行号字段的占用的字符数。

## more/less

- more

1. 空格键 (space)：代表向下翻一页；
2. Enter：代表向下翻『一行』
3. /字符串：代表在这个显示的内容当中，向下搜寻『字符串』这个关键词；
4. :f：立刻显示出文件名以及目前显示的行数；
5. q：代表立刻离开 more ，不再显示该文件内容。
6. b 或 [ctrl]-b：代表往回翻页，不过这动作只对文件有用，对管线无用。

- Less

1. 空格键：向下翻动一页；
2. [pagedown]：向下翻动一页；
3. [pageup] ：向上翻动一页；
4. /字符串：向下搜寻『字符串』的功能；
5. ?字符串：向上搜寻『字符串』的功能；
6. n：重复前一个搜寻 (与 / 或 ? 有关！)
7. N：反向的重复前一个搜寻 (与 / 或 ? 有关！)
8. g：前进到这个资料的第一行去；
9. G：前进到这个数据的最后一行去 (注意大小写)；
10. q：离开 less 这个程序；

## head/tail

head 取出前面几行

tail 取出后面几行

tail -f filename 持续监测文件内容

head/tail -n 正数：头开始数多少行，尾开始数多少行；还可以是负数，就是反过来

## od 查看非纯文本文档 

octal dump

od - dump files in octal and other formats

```Bash
od [-t TYPE] file
```

选项或参数：

`-t` 后面可以接各种『类型 (TYPE)』的输出，例如：

1. `a` 利用默认的字符来输出；
2. `c` 使用 ASCII 字符来输出
3. `d[size]` 利用十进制(decimal)来输出数据，每个整数占用 size bytes ；
4. `f[size]` 利用浮点数(floating)来输出数据，每个数占用 size bytes ；
5. `o[size]` 利用八进制(octal)来输出数据，每个整数占用 size bytes ；
6. `x[size]` 利用十六进制(hexadecimal)来输出数据，每个整数占用 size bytes ；

## 修改文件时间/新建文件

那么三个时间的意义是什么呢？

- modification time (mtime)

当该文件的『内容数据』变更时，就会更新这个时间！内容数据指的是文件的内容，而不是文件的属性或权限喔！

- status time (ctime)

当该文件的『状态 (status)』改变时，就会更新这个时间，举例来说，像是权限与属性被更改了，都会更新这个时间啊。

- access time (atime)

当『该文件的内容被取用』时，就会更新这个读取时间 (access)。举例来说，我们使用 cat 去读取某文件， 就会更新该文件的 atime 了。

```Bash
touch [-acdmt] file
```

选项与参数：

`-a` 仅修订 access time；

`-c` 仅修改文件的时间，若该文件不存在则不建立新文件；

`-d` 后面可以接欲修订的日期而不用目前的日期，也可以使用 --date="日期或时间"

`-m` 仅修改 mtime ；

`-t` 后面可以接欲修订的时间而不用目前的时间，格式为[YYYYMMDDhhmm]