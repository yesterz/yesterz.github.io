---
title: 通配符和特殊符号
date: 2024-06-20 20:06:00 +0800
author: 
categories: [Linux]
tags: [Linux]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/
---

# 通配符和特殊符号

首先，以于超老师的的编程经验告诉新人，学通配符，或是正则，请记住

- 正则、通配符是为了解决某问题
- 先有问题场景，再琢磨如何写通配符
- 不要先去写奇怪的通配符或正则，再去琢磨它是什么含义，这是外星人的做法。

## 什么是通配符

- 当你在查找特定文件名，却不记得如何拼写时，通配符是帮你寻找的神器。
- 通配符是专门用于处理文件名的特殊字符，而不是文件内容！
- 可以方便查找类似、但是不相同的文件名。
- 通配符是shell的内置语法、大部分linux命令都认识通配符

| 基本字符 | 通配符 | 模糊匹配的字符内容 |
| -------- | ------ | ------------------ |
| yu       | *      | yuchao             |
|          |        | yucccc             |
|          |        | yuuuuuuu           |
|          |        | yuddididididi      |
| chao     | ?      | chaog              |
|          |        | chao1              |
|          |        | chao-              |
|          |        | chao.              |
|          |        | chao_              |

注意，文件名一般是不带`特殊字符的`

## 通配符语法

| **字符** | **说明**                                                     | **示例**                                                     |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| *        | 匹配任意字符数。 您可以在字符串中使用星号 (*****)。          | “**wh\***”将找到 what、white 和 why，但找不到 awhile 或 watch。 |
| ?        | 在特定位置中匹配单个字母。                                   | “**b?ll** ”可以找到 ball、bell 和 bill。                     |
| [ ]      | 匹配方括号中的字符。                                         | “**b[ae]ll**”将找到 ball 和 bell，但找不到 bill。            |
| !        | 在方括号中排除字符。                                         | “**b[!ae]ll**”将找到 bill 和 bull，但找不到 ball 或 bell。“**Like “[!a]\*”**”将找到不以字母 a 开头的所有项目。 |
| -        | 匹配一个范围内的字符。 记住以升序指定字符（A 到 Z，而不是 Z 到 A）。 | “**b[a-c]d**”将找到 bad、bbd 和 bcd。                        |
|          |                                                              |                                                              |
| ^        | 同感叹号、在方括号中排除字符                                 | `b[^ae]ll`，找不到ball,找不到bell，能找到bcll                |
|          |                                                              |                                                              |


\* 匹配任意（0或多个）字符串，包括空字符串

? 匹配任意1个字符，且只有一个字符

[abcd] 匹配方括号里的abcd任意一个字符，abcd可以是其他不连续的字符如[aqwd]

[a-z] 匹配方括号里a到z之间的任意一个字符，也可以是连续的数字[1-9]

[!abcd] 不匹配方括号里的任意字符，也可以写为连续的字符，如[!a-z]，也就是不匹配a到z任意的一个字符，且!符可以用^替代，写成\[^abcd]


## 1. 练习通配符

```console
[yuchao-linux-242 root /tmp]#mkdir /test ;cd /test
[yuchao-linux-242 root /test]#
[yuchao-linux-242 root /test]#touch yuchao.txt yuc.txt cc.txt yuchao01.log yuyu.log cc.sh
```

### * 匹配任意字符

Asterisk

找出所有txt结尾的文件

```console
[yuchao-linux-242 root /test]#ls *.txt
cc.txt  yuchao.txt  yuc.txt
```

查看以sh结尾的文件

```console
[yuchao-linux-242 root /test]#ls *.sh
cc.sh
```

查看以yu开头、txt结尾的文件

```console
[yuchao-linux-242 root /test]#ls yu*.txt
yuchao.txt  yuc.txt
```

查看以yu开头、log结尾的文件

```console
[yuchao-linux-242 root /test]#ls yu*.log
yuchao01.log  yuyu.log
```

查看所有以yu开头的文件

```console
[yuchao-linux-242 root /test]#ls yu*
yuchao01.log  yuchao.txt  yuc.txt  yuyu.log
```

找出以c开头的文件
```console
[yuchao-linux-242 root /test]#ls c*
cc.sh  cc.txt
```

### ? 匹配任意一个字符（用得少）

```console
[yuchao-linux-242 root /test]#ls ?.sh
ls: cannot access ?.sh: No such file or directory
```

这个报错了，为什么？因为没有一个文件叫做 ?.sh

除非你去创建一个

```console
[yuchao-linux-242 root /test]#touch c.sh
[yuchao-linux-242 root /test]#ls ?.sh
c.sh
```

所以，作用不大，只用于特定场景。

如何查找特定字符数量的文件？
比如找出sh脚本文件
```console
[yuchao-linux-242 root /test]#ls *.sh
cc.sh  c.sh
```

你只能多写几个问号

```console
[yuchao-linux-242 root /test]#ls ?.sh
c.sh
[yuchao-linux-242 root /test]#
[yuchao-linux-242 root /test]#ls ??.sh
cc.sh
```

再比如找出所有txt

```console
[yuchao-linux-242 root /test]#ls ??.txt
cc.txt
[yuchao-linux-242 root /test]#ls ??????.txt
yuchao.txt
[yuchao-linux-242 root /test]#
[yuchao-linux-242 root /test]#ls ???.txt
yuc.txt
```

### []  匹配方括号里的内容

创建测试数据，如

```console
[yuchao-linux-242 root /test]#touch {a..g}.log
[yuchao-linux-242 root /test]#ls
a.log  b.log  cc.sh  cc.txt  c.log  c.sh  d.log  e.log  f.log  g.log  yuchao01.log  yuchao.txt  yuc.txt  yuyu.log
[yuchao-linux-242 root /test]#
```

找出文件名是a-z之间任意一个字符的txt

```console
[yuchao-linux-242 root /test]#ls [a-z].txt
ls: cannot access [a-z].txt: No such file or directory
```

报错了，因为没有


找出a-z之间任意一个字符的log

```console
[yuchao-linux-242 root /test]#ls [a-z].log
a.log  b.log  c.log  d.log  e.log  f.log  g.log
```

找出a-c之间任意一个字符的log

```console
[yuchao-linux-242 root /test]#ls [a-c].log
a.log  b.log  c.log
```

创建测试数据

```console
[yuchao-linux-242 root /test]#touch yu{1..5}.log
[yuchao-linux-242 root /test]#touch yc{1..5}.log
[yuchao-linux-242 root /test]#
[yuchao-linux-242 root /test]#ls
a.log  cc.sh   c.log  d.log  f.log  yc1.log  yc3.log  yc5.log  yu2.log  yu4.log  yuchao01.log  yuc.txt
b.log  cc.txt  c.sh   e.log  g.log  yc2.log  yc4.log  yu1.log  yu3.log  yu5.log  yuchao.txt    yuyu.log
[yuchao-linux-242 root /test]#
```

找出以yu1  yu2 yu3 相关的log文件

```console
[yuchao-linux-242 root /test]#ls yu[1-3].log
yu1.log  yu2.log  yu3.log
```

找出以y开头相关的log

```console
[yuchao-linux-242 root /test]#ls y*.log
yc1.log  yc2.log  yc3.log  yc4.log  yc5.log  yu1.log  yu2.log  yu3.log  yu4.log  yu5.log  yuchao01.log  yuyu.log
```

只找出文件名是三个字母的log文件

```console
[yuchao-linux-242 root /test]#ls [a-z][a-z][a-z0-9].log
yc1.log  yc2.log  yc3.log  yc4.log  yc5.log  yu1.log  yu2.log  yu3.log  yu4.log  yu5.log
[yuchao-linux-242 root /test]#
```

### [!abcd]   取反方括号的内容

```console
[yuchao-linux-242 root /test]#ls
a.log  cc.sh   c.log  d.log  f.log  yc1.log  yc3.log  yc5.log  yu2.log  yu4.log  yuchao01.log  yuc.txt
b.log  cc.txt  c.sh   e.log  g.log  yc2.log  yc4.log  yu1.log  yu3.log  yu5.log  yuchao.txt    yuyu.log
```

找出除了以abcd开头的log文件

```console
[yuchao-linux-242 root /test]#ls [!abcd]*.log
e.log  f.log  g.log  yc1.log  yc2.log  yc3.log  yc4.log  yc5.log  yu1.log  yu2.log  yu3.log  yu4.log  yu5.log  yuchao01.log  yuyu.log
```

作用同上，必须是连续的数字

```console
[yuchao-linux-242 root /test]#ls [!a-d]*.log
```

找出除了abcd开头的单个字母的log文件

```console
[yuchao-linux-242 root /test]#ls [!abcd].log
e.log  f.log  g.log
```

排除所有名字里包含y和u的文件

```console
[yuchao-linux-242 root /test]#ls [!yu]*
a.log  b.log  cc.sh  cc.txt  c.log  c.sh  d.log  e.log  f.log  g.log
```

排除所有名字里包含y和u的sh文件

```console
[yuchao-linux-242 root /test]#ls [!yu]*.sh
cc.sh  c.sh
```

## 2.通配符 find 综合练习

搜索/etc下所有包含hosts相关字符的文件

```console
[lamp-server root ~]$find /etc/ -type f -name '*hosts*'
/etc/hosts
/etc/hosts.allow
/etc/hosts.deny
```

搜索/etc下的以ifcfg开头的文件（网卡配置文件）

```console
[lamp-server root ~]$find /etc/ -type f -name 'ifcfg*'
/etc/sysconfig/network-scripts/ifcfg-lo
/etc/sysconfig/network-scripts/ifcfg-ens33
```

只查找以数字结尾的网卡配置文件

```console
[lamp-server root ~]$find /etc/ -type f -name 'ifcfg*[0-9]'
/etc/sysconfig/network-scripts/ifcfg-ens33
```

找到系统中的第一块到第四块磁盘，注意磁盘的语法命名

```console
[yuchao-linux01 root ~]$find /dev -name  'sd[a-d]'
/dev/sdd
/dev/sdc
/dev/sdb
/dev/sda
```

找找sdb硬盘有几个分区，多种写法

```console
[yuchao-linux01 root ~]$ls /dev/sdb?
/dev/sdb1  /dev/sdb2  /dev/sdb3  /dev/sdb4  /dev/sdb5  /dev/sdb6  /dev/sdb7

[yuchao-linux01 root ~]$ls /dev/sdb[0-9]
/dev/sdb1  /dev/sdb2  /dev/sdb3  /dev/sdb4  /dev/sdb5  /dev/sdb6  /dev/sdb7
```

注意*是和上面不同的

```console
[yuchao-linux01 root ~]$ls /dev/sdb*
/dev/sdb  /dev/sdb1  /dev/sdb2  /dev/sdb3  /dev/sdb4  /dev/sdb5  /dev/sdb6  /dev/sdb7
```

### 通配符练习二

测试数据源准备

```console
[yuchao-linux01 root ~/test_shell]$touch {a..h}.log
[yuchao-linux01 root ~/test_shell]$touch {1..10}.txt
[yuchao-linux01 root ~/test_shell]$ls
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt  a.log  b.log  c.log  d.log  e.log  f.log  g.log  h.log
[yuchao-linux01 root ~/test_shell]$
```


找出a到e的log文件

```console
[yuchao-linux01 root ~/test_shell]$ls [a-e].log
a.log  b.log  c.log  d.log  e.log
```

找出除了3到5的txt文件

```console
[yuchao-linux01 root ~/test_shell]$ls [!3-5].txt
1.txt  2.txt  6.txt  7.txt  8.txt  9.txt
```

找出除了2,5,8,9的txt文件

```console
[yuchao-linux01 root ~/test_shell]$ls [!2,5,8,9].txt
1.txt  3.txt  4.txt  6.txt  7.txt
```

同理写法

```console
[yuchao-linux01 root ~/test_shell]$ls [^2,5,8,9].txt
1.txt  3.txt  4.txt  6.txt  7.txt
```

找出除了a,e,f的log文件

```console
[yuchao-linux01 root ~/test_shell]$ls [!a,e,f].log
b.log  c.log  d.log  g.log  h.log
```

同理写法

```console
[yuchao-linux01 root ~/test_shell]$ls [^a,e,f].log
b.log  c.log  d.log  g.log  h.log
```

## 3.特殊符号

### 什么是特殊符号

比起通配符来说，linux的特殊符号更加杂乱无章，但是一个专业的linux运维

**孰能生巧，这些都不是问题**


### 路径相关

| 符号 | 作用                                       |
| ---- | ------------------------------------------ |
| ~    | 当前登录用户的家目录                       |
| -    | 上一次工作路径                             |
| .    | 当前工作路径，或表示隐藏文件 .yuchao.linux |
| ..   | 上一级目录                                 |

### 引号相关

```console
'' 单引号、所见即所得
"" 双引号、可以解析变量及引用命令
`` 反引号、可以解析命令
   无引号，一般我们都省略了双引号去写linux命令，但是会有歧义，比如空格，建议写引号
```

### 重定向符号

```console
>          stdout覆盖重定向
>>         stdout追加重定向

<            stdin重定向

2>   stderr重定向
2>>  stderr追加重定向
```

### 命令执行

```console
command1 && command2      #  command1成功后执行command2
command1 || command2      #  command1失败后执行command2
command1 ; command2         #  无论command1成功还是失败、后执行command2
\                # 转义特殊字符，还原字符原本含义
$()            # 执行小括号里的命令
``     # 反引号，和$()作用一样
|             # 管道符
{}         # 生成序列
```

## 4.引号练习

### 单引号

例如使用date练习

单引号是无法识别date命令的

```console
[yuchao-linux01 root ~/test_shell]$date
Sat Apr  2 17:06:01 CST 2022
[yuchao-linux01 root ~/test_shell]$
[yuchao-linux01 root ~/test_shell]$echo 'date'
date
[yuchao-linux01 root ~/test_shell]$echo '$(date)'
$(date)
```

结论、单引号是所见即所得，单引号里面是什么，输入就是什么，没有任何改变，特殊符号也都失去了其他作用。

### 反引号

反引号中的linux命令是可以执行的，且反引号中只能写可执行的命令

```console
# 依然是date命令

[yuchao-linux01 root ~/test_shell]$date
Sat Apr  2 17:32:56 CST 2022
[yuchao-linux01 root ~/test_shell]$
[yuchao-linux01 root ~/test_shell]$echo `date`
Sat Apr 2 17:32:59 CST 2022
[yuchao-linux01 root ~/test_shell]$echo `pwd`
/root/test_shell

[yuchao-linux01 root ~/test_shell]$echo "于超老师的外号是`echo 超哥`"
于超老师的外号是超哥
```

**总结**

系统会首先执行反引号里的命令，然后再进行下一步的处理。

### 双引号

```console
[yuchao-linux01 root ~/test_shell]$echo "date"
date
[yuchao-linux01 root ~/test_shell]$echo "`date`"
Sat Apr  2 17:39:52 CST 2022
[yuchao-linux01 root ~/test_shell]$
[yuchao-linux01 root ~/test_shell]$echo "$PATH"
/opt/jdk/BIN:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/bin:/opt/jdk/bin:/root/bin
[yuchao-linux01 root ~/test_shell]$

[yuchao-linux01 root ~/test_shell]$name="超哥"
[yuchao-linux01 root ~/test_shell]$
[yuchao-linux01 root ~/test_shell]$echo "于超老师的外号是$name"
于超老师的外号是超哥

[yuchao-linux01 root ~/test_shell]$echo "于超老师的外号是$name，当前的linux工作路径是$PWD"
于超老师的外号是超哥，当前的linux工作路径是/root/test_shell
```

**结论**

当输出双引号内的内容是，如果内容里有linux命令、或者变量、特殊转义符等

会优先解析变量、命令、转义字符，然后得到最终的内容

### 无引号

没有引号、很难确定字符串的边界，很容易出现各种故障

```console
[yuchao-linux01 root ~/test_shell]$echo 于超老师的外号是 $name
于超老师的外号是 超哥

[yuchao-linux01 root ~/test_shell]$echo 于超老师的外号是 $name 当前的工作路径是 $PWD
于超老师的外号是 超哥 当前的工作路径是 /root/test_shell

[yuchao-linux01 root ~/test_shell]$echo "于超老师的外号是 $name 当前的工作路径是 $PWD"
于超老师的外号是 超哥 当前的工作路径是 /root/test_shell


[yuchao-linux01 root ~/test_shell]$echo '于超老师的外号是 $name 当前的工作路径是 $PWD'
于超老师的外号是 $name 当前的工作路径是 $PWD
```

## 5.特殊符号练习

### 重定向符号

之前讲过重定向符号、以及数据流的结合用，这里就不重复了。

### ; 分号

- 表示命令的结束
- 多个命令之间的分隔符
- 某些配置文件的注释符

```console
[yuchao-linux01 root ~/test_shell]$pwd;mkdir hehe;cd hehe;pwd
/root/test_shell
/root/test_shell/hehe
[yuchao-linux01 root ~/test_shell/hehe]$
```

### # 符

注释符号
如命令的注释

```console
[yuchao-linux01 root ~/test_shell/hehe]$# hello super man
[yuchao-linux01 root ~/test_shell/hehe]$
[yuchao-linux01 root ~/test_shell/hehe]$# ls /opt
```

如配置文件的注释符

```console
# nginx.conf

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;
```

### | 管道符

如生活中的管道，能够传输物质

Linux管道符 | 用于传输数据，对linux命令的处理结果再次处理，直到得到最终结果

```console
[yuchao-linux01 root ~/test_shell/hehe]$ifconfig |grep inet
        inet 192.168.0.240  netmask 255.255.255.0  broadcast 192.168.0.255
        inet6 fe80::4913:8ad0:3a1:c439  prefixlen 64  scopeid 0x20<link>
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>


[yuchao-linux01 root ~/test_shell/hehe]$netstat -tunlp|grep ssh
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1063/sshd
tcp6       0      0 :::22                   :::*                    LISTEN      1063/sshd
```

能一次出结果的命令，尽量不要二次加工，效率并不高

### && 符

创建目录成功后，才执行后面的命令

```console
[yuchao-linux01 root ~/test_shell/hehe]$mkdir /chaoge_data && cd /chaoge_data
[yuchao-linux01 root /chaoge_data]$
[yuchao-linux01 root /chaoge_data]$
[yuchao-linux01 root /chaoge_data]$mkdir /chaoge_data && cd /chaoge_data
mkdir: cannot create directory ‘/chaoge_data’: File exists
```

如果前面命令失败，后面命令不执行

```console
[yuchao-linux01 root /chaoge_data]$mkdir /chaoge_data && pwd
mkdir: cannot create directory ‘/chaoge_data’: File exists
```

只有前面成功，后面才执行

```console
[yuchao-linux01 root /chaoge_data]$mkdir /chaoge_data2 && pwd
/chaoge_data
```

### || 符

只有前面命令失败、才执行后面命令

```console
[yuchao-linux01 root /chaoge_data]$mkdir /chaoge_data ||  pwd
mkdir: cannot create directory ‘/chaoge_data’: File exists
/chaoge_data
```

前面成功了，后面不执行

```console
[yuchao-linux01 root /chaoge_data]$mkdir /chaoge_data222 ||  pwd
```

### $() 符

引用系统时间，创建文件名，脚本常见做法

```console
[yuchao-linux01 root /chaoge_data]$touch nginx_access_$(date +%F).log
[yuchao-linux01 root /chaoge_data]$
[yuchao-linux01 root /chaoge_data]$ll
total 0
-rw-r--r-- 1 root root 0 Apr  2 18:03 nginx_access_2022-04-02.log
```

找到当前的txt文件，然后删掉

```console
[yuchao-linux01 root ~/test_shell]$rm -f $(find . -name '*.txt')
```

等同写法

```console
[yuchao-linux01 root ~/test_shell]$rm -f `find . -name '*.log'`
```

### {} 符

生成连续的数字序列

```console
[yuchao-linux01 root ~/test_shell]$echo {1..30}
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
```


生成字母序列

```console
[yuchao-linux01 root ~/test_shell]$echo {a..z}
a b c d e f g h i j k l m n o p q r s t u v w x y z
```

特殊用法，拷贝文件的简写

```console
[yuchao-linux01 root ~/test_shell]$ll /etc/sysconfig/network-scripts/ifcfg-ens33*
-rw------- 1 root root 408 Mar 19 14:59 /etc/sysconfig/network-scripts/ifcfg-ens33
-rw-r--r-- 1 root root 408 Apr  2 18:17 /etc/sysconfig/network-scripts/ifcfg-ens33.bak
```

作为变量的分隔符

```console
[yuchao-linux01 root ~/test_shell]$touch ${name}_`date +%F`.log
[yuchao-linux01 root ~/test_shell]$ll
total 0
-rw-r--r-- 1 root root 0 Apr  2 18:18 超哥_2022-04-02.log
```