---
title: find 命令
date: 2024-06-26 12:36:00 +0800
author: 
categories: [Linux]
tags: [Linux]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/IntroductionToDPImages/
---

Linux 中的 find命令是一个非常强大的工具，可基于各种条件搜索文件系统中的文件和目录。

## **基本语法**

```plaintext
find 目录 [选项] [表达式]
```

**目录**：指定要查找的文件所在的目录

**选项**：指定查找的条件

**表达式**：查找匹配指定条件的文件或目录

> find 命令的语法和其他 Unix 命令不同，其选项并不是那种典型的连字符加上单字母，后面再跟上若干参数。find 命令的选项看起来像是简短的单词 ，依照逻辑顺序出现，并描述要查找哪些文件以及如何处理找到的文件（如果存在的话）。这种像单词一样的选项通常称为**谓词**（predicate）。但是 man find 上写的是 find 命令的表达式选项（expression option）、测试条件（test）或操作（action）。
{: .prompt-info }

## **常用选项**

- -name：根据文件名查找
- -type：根据文件类型查找
- -size：根据文件大小查找
- -mtime 用文件最后的修改时间来匹配（modified）
- -uid：按照文件所有者查找
- -gid 根据文件组所有者查找
- -perm 根据文件权限查找（permission）
- -exec 对搜索的结果执行命令（execute）

## **find 命令的常用表达式**

- *****：匹配任意字符
- **?**：匹配任意单个字符
- **[字符集]**：匹配字符集中的任意字符
- **{字符串}**：匹配字符串

## **常用用法汇总**

**1. 按名称搜索文件**

- 查找`/path/to/somewhere`{: .filepath}目录下的 MP4 视频文件：

```bash
find /path/to/somewhere -name '*.mp4' -print -exec mv '{}' ~/Videos \;
```

find 命令的第一个参数是待搜索的目录。典型用法是用点号（.）代表当前目录，不过你也可以提供一个目录列表，甚至通过指定根目录（/）来搜索整个文件系统（只要权限允许）。

第一个选项（谓词 -name）指定了要搜索的文件模式。其语法和 bash 的模式匹配语法差不多，因此 *.mp4 能够匹配所有以“.mp4”结尾的文件名。匹配该模式的文件被认为返回的是真（true），接着将其交给下一个谓词进行处理。

find 会遍历文件系统，将找到的文件名交给谓词测试。如果谓词返回真，就通过。如果返回假，则不再继续往下进行，会接着处理下一个文件名。

谓词 -print 很简单。它总是返回真，同时会将文件名打印到标准输出，因此，能在谓词序列中通过测试而到达这一步的文件都会输出其名称。

-exec 就有点怪异了。到达这一步的文件名都会变成接下来要执行的命令的一部分。剩下一直到 `\;` 的这部分就是命令，其中的 {} 会被替换成已查找到的文件名。

**2. 按类型搜索**

b 块设备文件，c 字符设备文件，d 目录，p 管道（或fifo），f 普通文件，l 符号链接，s 套接字，D 门。

```
b      block (buffered) special

c      character (unbuffered) special

d      directory

p      named pipe (FIFO)

f      regular file

l      symbolic link; this is never true if the -L option or the
       -follow  option is in effect, unless the symbolic link is
       broken.  If you want to search for symbolic links when -L
       is in effect, use -xtype.
       
s      socket

D      door (Solaris)
```

- 查找`/path/to/somewhere`{: .filepath}目录下的所有目录

```bash
find /path/to/somewhere -type d
```

- 查找`/path/to/somewhere`{: .filepath}目录下的所有文件

```bash
 find /path/to/somewhere -type f 
```

**3. 按文件大小搜索**

```
`b'    for  512-byte blocks (this is the default if no suffix is
     used)

`c'    for bytes

`w'    for two-byte words

`k'    for kibibytes (KiB, units of 1024 bytes)

`M'    for mebibytes (MiB, units of 1024 * 1024 = 1048576 bytes)

`G'    for gibibytes (GiB,  units  of  1024  *  1024  *  1024  =
     1073741824 bytes)
```

+表示大于，-表示小于

- 查找`/path/to/somewhere`{: .filepath}目录下小于 10MB 的文件

```bash
 find /path/to/somewhere -size -10M -print
```

- 查找`/path/to/somewhere`{: .filepath}目录中占用空间最大的文件

```bash
 find /path/to/somewhere -size +3000k -print
```

> 文件大小还包含了单位 k（千字节）。如果单位是 c，则表示字节（或字符）。如果使用 b 作为单位或者不写任何单位，则表示块。（一个块为 512 字节，历史上是 Unix 系统中的通用单位。）这里我们要找的是大于 3MB 的文件。
{: .prompt-info }

然后把它删了就用`-delete`

```
find /path/to/somewhere -size +3000k -print -delete
```

**4. 按修改时间搜索**

关于文件的属性，有如下三个时间，可以更清晰的了解你的文件是否被人碰过。

创建时间：代表这个文件什么时间被创建（ctime）

访问时间：代表这个文件什么时间被访问（atime）

修改时间：代表这个文件什么时间被修改（mtime）

- 查找`/path/to/somewhere`{: .filepath}目录下过去 7 天内修改过的文件

```bash
 find /path/to/somewhere '*.jpg' -mtime -7 -print
```

- 查找`/path/to/somewhere`{: .filepath}目录下 7 天前修改过**并且不超过14天**的文件

```bash
 find /path/to/somewhere '*.jpg' -mtime +7 -a -mtime -14 -print
```

> find 的逻辑运算及其优先级（从高到低），括号 `( expr )` 但是在shell中圆括号有特殊含义（命名组，子Shell），所以要转义一下写成这样子`\(...\)`，`-not expr` Same as `! expr` ，再就是-a 表示 AND，-o 表示 OR，逗号`expr1 , expr2`expr1会被丢弃，用expr2的结果。
{: .prompt-info }

**5. 按权限搜索**

- 查找`/path/to/somewhere`{: .filepath}目录下权限为644的文件

```bash
find /path/to/somewhere '*.jpg' -perm 644
```

**6. 按用户和组搜索**

- 查找`/path/to/somewhere`{: .filepath}目录下特定用户拥有的文件

```bash
find /path/to/somewhere -user username
```

- 查找`/path/to/somewhere`{: .filepath}目录下特定组拥有的文件

```bash
find /path/to/somewhere -group groupname
```

**7. 结合 exec 执行操作**

```sh
-exec command {} +
```

`{}`只允许存在一个，如果由shell调用这个的话，则需要加引号`'{}'`来防止它被shell解析。

- 删除`/path/to/somewhere`{: .filepath}目录下搜到的demo.txt文件

```bash
find /path/to/somewhere -name "demo.txt" -exec rm {} \;
```

- 将搜索到的文件复制到另一个目录，将`/path/to/somewhere`{: .filepath}搜索到的demo.txt复制到`/path/to/destination`{: .filepath}目录下

```bash
find /path/to/somewhere -name "demo.txt" -exec cp {} /path/to/destination/ \;
```

**8. 排除特定目录**

- 搜索`/path/to/somewhere`{: .filepath}目录，但`/path/to/somewhere/skipdir`{: .filepath}该目录排除掉不作搜索，来找到 demo.txt 文件

```bash
find /path/to/somewhere -path /path/to/somewhere/skipdir -prune -o -name "demo.txt" -print
```

**9. 结合使用多个条件**

- 搜索特定类型且大小在特定范围内的文件：搜索`/path/to/somewhere`{: .filepath}下为文件类型，且文件大小大于10M，小于等于100M

```bash
find /path/to/somewhere -type f -size +10M -size -100M
```

**10. 按深度搜索**

- 限制搜索深度：搜索当前目录`/path/to/somewhere`{: .filepath}，其直接子目录及其子目录下的所有文件：

```bash
find /path/to/somewhere -maxdepth 2 -name "demo.txt"
```

补充 `-maxdepth` 选项的示例：

- 查找当前目录及其直接子目录下的所有文件：

```
find . -maxdepth 1
```

- 查找当前目录、其直接子目录及其子目录下的所有文件：

```
find . -maxdepth 2
```

- 查找当前目录下的所有文件，但不搜索子目录：

```
find . -maxdepth 0
```

- 不限制搜索的深度：

```
find . -maxdepth -1
```

**11. find 和 xargs的配合使用**

- 当 `find` 命令的输出需要作为另一个命令的参数时，`xargs` 就显得非常有用。例如，你可以使用 `find` 来查找文件，然后使用 `xargs` 将这些文件传递给 `grep`、`rm`、`cp` 等命令。

```bash
#搜索并删除文件：这个命令查找所有 .tmp 文件，并删除它们。
find /path/to/somewhere -name "*.tmp" -print | xargs rm 

#搜索文件并计算它们的总行数：这个命令会查找所有 .py 文件，并计算出这些文件的总行数。
find /path/to/somewhere -name "*.py" -print | xargs wc -l 
```

- **使用 `-exec` 与 `xargs` 的区别**

`find` 命令本身就提供了 `-exec` 选项来对找到的文件执行命令，这让人不禁疑惑为什么还要使用 `xargs`。实际上，`-exec` 在每次找到匹配的文件时都会启动一个新的进程来执行命令，而 `xargs` 会尽可能地将多个文件名作为参数传递给一个命令，从而减少了进程的创建。因此，在处理大量文件时，使用 `xargs` 可能会更有效率。

- **处理奇怪的字符**

> Unix 用户口中的怪异（odd）字符是指“除小写字母和数字之外的任何字符”。因此，大写字母、空格、标点符号、声调字符统统都属于怪异字符，但是你会发现很多歌曲名中的怪异字符远不止这些。
{: .prompt-info }

在使用 `find ... | xargs ...` 组合时，如果文件名包含空格、换行符或其他特殊字符，可能会导致问题。为了解决这个问题，可以使用 `-print0` 选项与 `xargs -0` 配合使用，这样文件名之间就会用空字符（而非空格）分隔，从而更安全地处理复杂的文件名：

```bash
find /path/to/somewhere -name "*.txt" -print0 | xargs -0 grep "search_text" 
```

这个命令会在所有 `.txt` 文件中搜索包含 "search_text" 的行，即使文件名中包含空格或其他特殊字符。

-print0 告诉 find 不要用空白字符，而是改用空字符（null character）（\0）作为输出的文件名之间的分隔符。-0 告诉 xargs 输入分隔符是空字符。两者配合的效果不错，但并非所有系统都支持这两个命令。

## 快速查找

你想查找文件，但又不想等待冗长的 find 结束，或是需要查找包含特定内容的文件。

用 `locate`, `slocate`