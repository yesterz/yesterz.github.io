---
title: 检验软件文件指纹
date: 2024-04-03 21:09:00 +0800
author: 
categories: [Operating System]
tags: [Operating System]
pin: false
math: false
mermaid: false
img_path: 
---

| md5sum    | md5sum - compute and check MD5 message digestPrint or check MD5 (128-bit) checksums. |
| --------- | ------------------------------------------------------------ |
| sha1sum   | sha1sum - compute and check SHA1 message digestPrint or check SHA1 (160-bit) checksums. |
| sha256sum | sha256sum - compute and check SHA256 message digestPrint or check SHA256 (256-bit) checksums. |

```bash
md5sum/sha1sum/sha256sum [-bct] filename
md5sum/sha1sum/sha256sum [--status|--warn] --check filename
```

选项与参数：

`-b` 使用 binary 的读档方式，默认为 Windows/DOS 文件型态的读取方式；

`-c` 检验文件指纹；

`-t` 以文字型态来读取文件指纹。