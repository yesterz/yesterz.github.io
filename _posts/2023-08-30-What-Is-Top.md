---
title: Top 命令
categories:
  - Linux
tags:
  - Linux
toc: true
---
# Top 命令

## man top

https://man7.org/linux/man-pages/man1/top.1.html

## top 然后按下h

![img](https://fpfl3bbe49.feishu.cn/space/api/box/stream/download/asynccode/?code=YWYyZmZlYTVkMmMyZjE3NDk5NGFlZTJlNGMzMzU2NWZfSnNITlhuNXgyRlN4UWJwcUxOWTFoSFVXb3IzQk9OVDRfVG9rZW46QjNibWJjZzR4b00zNXh4Y2dFVWNCVkRablhiXzE2OTU3MTExNDc6MTY5NTcxNDc0N19WNA)

## SUMMARY Display

这块就是顶部信息的含义

```C
top - 11:25:31 up 1 day,  1:15,  1 user,  load average: 2.81, 1.98, 1.86
Tasks: 527 total,   2 running, 523 sleeping,   0 stopped,   2 zombie
%Cpu(s):  3.3 us,  2.0 sy,  2.2 ni, 91.9 id,  0.5 wa,  0.0 hi,  0.1 si,  0.0 st
MiB Mem :  15712.8 total,    652.8 free,   9137.5 used,   5922.5 buff/cache
MiB Swap:  16212.0 total,  13956.2 free,   2255.8 used.   3878.9 avail Mem 
```

### UPTIME and LOAD Averages

第1行字段分别表示，这些字段用逗号分隔

- 当前时间 & 系统已运行时间 `11:25:31 up 1 day` 
- 当前登录用户的数量 `1 user`
- 相应最近1、5和15分钟内的系统平均