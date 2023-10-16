---
title: 常用 git 操作
date: 2023-10-16 20:10:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Sort]
pin: false
math: true
mermaid: false
---




git clean -f    # 删除 untracked files

git clean -fd   # 连 untracked 的目录也一起删掉

git clean -xfd  # 连 gitignore 的untrack 文件/目录也一起删掉 （慎用，一般这个是用来删掉编译出来的 .o之类的文件用的）

# 在用上述 git clean 前，强烈建议加上 -n 参数来先看看会删掉哪些文件，防止重要文件被误删
git clean -nf
git clean -nfd
git clean -nxfd