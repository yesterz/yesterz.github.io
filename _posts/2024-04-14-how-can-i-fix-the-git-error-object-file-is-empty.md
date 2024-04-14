---
title: 解决： fatal loose object 95xxxx (stored in .git/objects/95/7b7fxxx) is corrupt
date: 2024-04-14 21:09:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
img_path: 
---

```
> git status -z -uall
error: object file .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55 is empty
error: object file .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55 is empty
fatal: loose object 957b7fc04d50c424957691e6c2c7c95f2a4e7a55 (stored in .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55) is corrupt
```

```
git fsck --full --no-dangling
```

输出：

```
error: object file .git/objects/76/fca1a5afa3cfc8a9e30a4ad4ac7bcae453238c is empty
error: unable to mmap .git/objects/76/fca1a5afa3cfc8a9e30a4ad4ac7bcae453238c: No such file or directory
error: 76fca1a5afa3cfc8a9e30a4ad4ac7bcae453238c: object corrupt or missing: .git/objects/76/fca1a5afa3cfc8a9e30a4ad4ac7bcae453238c
error: object file .git/objects/93/2ce4d6cc0538f7f0c088cf93c5a9b770dedb1f is empty
error: unable to mmap .git/objects/93/2ce4d6cc0538f7f0c088cf93c5a9b770dedb1f: No such file or directory
error: 932ce4d6cc0538f7f0c088cf93c5a9b770dedb1f: object corrupt or missing: .git/objects/93/2ce4d6cc0538f7f0c088cf93c5a9b770dedb1f
error: object file .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55 is empty
error: unable to mmap .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55: No such file or directory
error: 957b7fc04d50c424957691e6c2c7c95f2a4e7a55: object corrupt or missing: .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55
error: object file .git/objects/98/382e6c80c8e42b7224dea7e0fde849176345ac is empty
error: unable to mmap .git/objects/98/382e6c80c8e42b7224dea7e0fde849176345ac: No such file or directory
error: 98382e6c80c8e42b7224dea7e0fde849176345ac: object corrupt or missing: .git/objects/98/382e6c80c8e42b7224dea7e0fde849176345ac
Checking object directories: 100% (256/256), done.
Checking objects: 100% (1597/1597), done.
error: object file .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55 is empty
error: object file .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55 is empty
fatal: loose object 957b7fc04d50c424957691e6c2c7c95f2a4e7a55 (stored in .git/objects/95/7b7fc04d50c424957691e6c2c7c95f2a4e7a55) is corrupt
```

直接看这个算了。。。。

<https://stackoverflow.com/questions/11706215/how-can-i-fix-the-git-error-object-file-is-empty?newreg=6de7386ccc32494ca01c05ac2eb66d58>