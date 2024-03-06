---
title: 反汇编工具和 Hook 框架
date: 2023-04-02 10:51:00 +0800
author:
categories: [Python]
tags: [Python, App Reverse]
pin: false
math: true
mermaid: false
img_path: /assets/images/
---

## 一 反编译工具

### 1.1 常见反编译工具

```python
常见的反编译工具：jadx（推荐）、jeb、GDA
反编译工具依赖于java环境，所以我们按照jdk
```

### 1.2 JDK环境安装

```python
# 官方地址：（需要注册-最新java 21）
https://www.oracle.com/java/technologies/downloads/

# 下载地址
链接: https://pan.baidu.com/s/1JxmjfGhWqWjpkprqi6GGrQ 
提取码: yyhx
```

![image-20230615154720045](Disassembly-tool-and-Hook-framework/image-20230615154720045.png)

#### 1.2.1 win平台安装

```python
# 1 下载jdk-8u371-windows-x64.exe
# 2 双击安装
```

#### 1.2.2 mac平台安装

```python
# 1 下载jdk-8u371-macosx-x64.dmg
# 2 双击安装
```

#### 1.2.3 验证是否安装成功

```python
java -version  # 看到打印安装成功
'''
java version "1.8.0_371"
Java(TM) SE Runtime Environment (build 1.8.0_371-b11)
'''
```

### 1.3 jdax安装

#### 1.3.1 下载地址

```python
# 1 官网
https://github.com/skylot/jadx/releases

# 2 提供的地址
链接: https://pan.baidu.com/s/1JxmjfGhWqWjpkprqi6GGrQ 
提取码: yyhx

# 最新：1.4.7 推荐：1.2.0，后期都会用
```

![image-20230615155149828](Disassembly-tool-and-Hook-framework/image-20230615155149828.png)

#### 1.3.2 安装

```python
# 下载直接解压即可（注意不要放在有中文的路径）
# 把apk直接拖入软件即可
```

![image-20230615155407729](Disassembly-tool-and-Hook-framework/image-20230615155407729.png)

![image-20230615155504155](Disassembly-tool-and-Hook-framework/image-20230615155504155.png)



## 二 反编译后代码定位

### 2.1 抓包

```python
# 打开app，运行，使用抓包工具抓包，发现密码是加密的
# 这时候咱们需要，反编译后，定位到代码位置
```

![image-20230615155818493](Disassembly-tool-and-Hook-framework/image-20230615155818493.png)

### 2.2 反编译定位位置

```python
# 通过：URL网址 或 参数关键字  `pwd`   `"pwd"`    put("pwd    等关键字搜索
# https://dealercloudapi.che168.com/tradercloud/sealed/login/login.ashx

```

![image-20230615160044899](Disassembly-tool-and-Hook-framework/image-20230615160044899.png)

![image-20230615160201891](Disassembly-tool-and-Hook-framework/image-20230615160201891.png)

![image-20230615160242472](Disassembly-tool-and-Hook-framework/image-20230615160242472.png)

![image-20230615160257337](Disassembly-tool-and-Hook-framework/image-20230615160257337.png)

![image-20230615160312466](Disassembly-tool-and-Hook-framework/image-20230615160312466.png)

```python
## 我们发现，定位到代码，但是读不懂什么意思，只能靠猜测和比较
import hashlib
str='1234567'
res=hashlib.md5(str.encode('utf-8')).hexdigest()
print(res)

## 注意：这个过程需要掌握Java和安卓开发。所以后期我们要学习java知识和安卓开发
```

## 三hook框架frida



```python
Hook 框架是一种技术，用于在运行时拦截和修改应用程序的行为。
通过 Hook，你可以劫持应用程序的方法调用、修改参数、篡改返回值等，以达到对应用程序的修改、增强或调试的目的
# 常见的有：
Xposed Framework：Xposed 是一个功能强大的开源 Hook 框架，可以在不修改应用程序源代码的情况下，对应用程序进行各种修改。它允许你编写模块来拦截和修改应用程序的方法调用，修改应用程序的行为和逻辑。

Frida：Frida 是一个跨平台的动态 Hook 框架，支持安卓和其他操作系统。它提供了一个强大的 JavaScript API，可以在运行时对应用程序进行 Hook，包括方法拦截、参数修改、调用注入等。Frida 可以用于安全研究、逆向工程和应用程序调试等方面。
```

### 3.1 下载安装

```python
# 注意：需要电脑端[电脑端要安装python解释器环境]和手机端同时安装，版本必须对应
```

#### 3.1.1 电脑端安装

```python
# 指定版本安装
pip install frida==16.0.1
pip install frida-tools==12.0.1

# 安装最新版
pip install frida        # 16.0.9
pip install frida-tools  # 12.1.2


# 正常都可以顺利安装，若安装出现错误，下载源码包安装
#### 必须根据 ：frida版本 + Python版本 + 操作系统 来选择下载响应的egg或whl文件。
https://pypi.doubanio.com/simple/frida/

pip install frida-16.0.1-cp37-abi3-macosx_10_9_x86_64.whl
```

![image-20230615161449757](Disassembly-tool-and-Hook-framework/image-20230615161449757.png)

#### 3.1.2 手机端安装frida-server

```python
# 1 先查看手机架构
adb shell getprop ro.product.cpu.abi
# arm64-v8a

# 2 下载frida-server
https://github.com/frida/frida/releases

# 3 解压，上传到手机 /data/local/tmp/ 目录下
	-解压得到文件，把文件上传到手机
 adb push ./今日软件/frida-server/frida-server-16.0.19-android-arm64  /data/local/tmp/

# 4 赋予可执行权限
adb shell  # 进入手机命令行
su        # 切换为超级用户
cd /data/local/tmp/
chmod 755 frida-server-16.0.19-android-arm64  # 加入执行权限
ls -al   # 查看权限

## 5 
```

![image-20230615162238083](Disassembly-tool-and-Hook-framework/image-20230615162238083.png)

### 3.2 启动并hook应用

### 3.2.1 手机端启动frida服务端

```python
# 切换到手机的/data/local/tmp目录下
adb shell
su
cd /data/local/tmp
./frida-server-16.0.19-android-arm64
```

**报错解决**

```python
方案一:重启手机
方案二:运行adb shell setenforce 0
```



![image-20230615163240601](Disassembly-tool-and-Hook-framework/image-20230615163240601.png)

#### 3.2.2 电脑端配置

##### 3.2.2.1 配置端口转发

```python
# 方式一：命令行中敲
adb forward tcp:27042 tcp:27042
adb forward tcp:27043 tcp:27043

# 方式二：使用python执行
import subprocess

subprocess.getoutput("adb forward tcp:27042 tcp:27042")
subprocess.getoutput("adb forward tcp:27043 tcp:27043")
```

##### 3.2.2.2 编写python代码，打印手机中的进程

```python
# 枚举手机上的所有进程 & 前台进程
import frida

# 获取设备信息
rdev = frida.get_remote_device()

# 枚举所有的进程
processes = rdev.enumerate_processes()
for process in processes:
    print(process)

# 获取在前台运行的APP
front_app = rdev.get_frontmost_application()
print(front_app)
```

**错误**

```python
# 没有配置端口转发
adb forward tcp:27042 tcp:27042
adb forward tcp:27043 tcp:27043
```



![image-20230615163609652](Disassembly-tool-and-Hook-framework/image-20230615163609652.png)



### 3.3 hook 某智赢的加密算法encodeMD5

```python
import frida
import sys
# 连接手机设备
rdev = frida.get_remote_device()

# 包名：com.che168.autotradercloud
# 车智赢+
session = rdev.attach("车智赢+")
scr = """
Java.perform(function () {
    //找到类 反编译的首行+类名：com.autohome.ahkit.utils下的
    var SecurityUtil = Java.use("com.autohome.ahkit.utils.SecurityUtil");

    //替换类中的方法
    SecurityUtil.encodeMD5.implementation = function(str){
        console.log("参数：",str);
        var res = this.encodeMD5(str); //调用原来的函数
        console.log("返回值：",res);
        return str;
    }
});
"""

script = session.create_script(scr)

def on_message(message, data):
    print(message, data)

script.on("message", on_message)
script.load()
sys.stdin.read()

```

### 3.4  Python Hook方式

```python
# Spawn 方式适应场景：Spawn 方式是在目标应用程序启动时直接注入 Frida 的 Agent 代码

需要在应用程序启动的早期阶段进行 Hook。
需要访问和修改应用程序的内部状态，例如应用程序的全局变量、静态变量等。
需要 Hook 应用程序的初始化过程，以实现对应用程序的自定义初始化逻辑。
需要在应用程序的上下文中执行代码，并与其他模块或库进行交互。

# Attach 方式适应场景：Attach 方式是在目标应用程序已经运行的过程中动态地连接并注入 Frida 的 Agent 代码
需要对已经运行的应用程序进行 Hook，即动态地连接到正在运行的进程。
需要在应用程序运行时拦截和修改特定的方法调用。
需要实时监视和修改应用程序的行为，例如参数修改、返回值篡改等。
需要对应用程序进行调试和分析，以查找潜在的问题和漏洞。
```



#### 3.4.1 attach方式（手动操作）

```python
import frida
import sys
# 连接手机设备
rdev = frida.get_remote_device()

# 包名：com.che168.autotradercloud
# 车智赢+
session = rdev.attach("车智赢+")
scr = """
Java.perform(function () {
    //找到类 反编译的首行+类名：com.autohome.ahkit.utils下的
    var SecurityUtil = Java.use("com.autohome.ahkit.utils.SecurityUtil");

    //替换类中的方法
    SecurityUtil.encodeMD5.implementation = function(str){
        console.log("参数：",str);
        var res = this.encodeMD5(str); //调用原来的函数
        console.log("返回值：",res);
        return str;
    }
});
"""

script = session.create_script(scr)

def on_message(message, data):
    print(message, data)

script.on("message", on_message)
script.load()
sys.stdin.read()
```



#### 3.4.2 spawn方式（自动重启app，适用于在应用程序启动的早期阶段进行）

```python
import frida
import sys

rdev = frida.get_remote_device()
pid = rdev.spawn(["com.che168.autotradercloud"])
session = rdev.attach(pid)

scr = """
Java.perform(function () {
    // 包.类
    var SecurityUtil = Java.use("com.autohome.ahkit.utils.SecurityUtil");
    SecurityUtil.encodeMD5.implementation = function(str){
        console.log("明文：",str);
        var res = this.encodeMD5(str);
        console.log("md5加密结果=",res);
        return "305eb636-eb15-4e24-a29d-9fd60fbc91bf";
    }
});
"""
script = session.create_script(scr)


def on_message(message, data):
    print(message, data)


script.on("message", on_message)
script.load()
rdev.resume(pid)
sys.stdin.read()
```





### 3.5 js Hook方式javaScript+终端

```python
# 代码 hook.js
Java.perform(function () {
    // 包.类
    var SecurityUtil = Java.use("com.autohome.ahkit.utils.SecurityUtil");
    SecurityUtil.encodeMD5.implementation = function(str){
        console.log("明文：",str);
        var res = this.encodeMD5(str);
        console.log("md5加密结果=",res);
        return "305eb636-eb15-4e24-a29d-9fd60fbc91bf";
    }
});
```



#### 3.5.1 attach，先启动app，然后再在终端执行：

```
frida -UF -l hook.js  
```

#### 3.5.2 spwan，脚本自动重启APP并进行Hook

```python
frida -U -f com.che168.autotradercloud -l hook.js

# 注意：输入q + 再点击回车则退出
```



## 四 使用python还原算法

```python
# 加密分类
1、单向加密 ：MD5、sha系列不可逆
2、对称加密：AES、DES
3、非对称加密：RSA、DSA
4、补充算法：base64
```

## 4.1 md5

```python
import hashlib
m = hashlib.md5()
m.update('helloworld'.encode("utf8"))
print(m.hexdigest())
```



### 4.2 sha

```python
import hashlib
sha1 = hashlib.sha1()
data = 'helloword'
sha1.update(data.encode('utf-8'))
sha1_data = sha1.hexdigest()
print(sha1_data)
```

### 4.3 DES加密

```python
# pip3 install pycryptodomex -i https://pypi.douban.com/simple
# DES是一个分组加密算法，典型的DES以64位为分组对数据加密，加密和解密用的是同一个算法。它的密钥长度是56位（因为每个第8 位都用作奇偶校验），密钥可以是任意的56位的数，而且可以任意时候改变。

from Cryptodome.Cipher import DES
key = b'88888888'
data = "hello world"
count = 8 - (len(data) % 8)
plaintext = data + count * "="
des = DES.new(key, DES.MODE_ECB)
ciphertext = des.encrypt(plaintext.encode())
print(ciphertext)

plaintext = des.decrypt(ciphertext)
plaintext = plaintext[:(len(plaintext)-count)]
print(plaintext)
```



### 4.4 非对称加密算法-RSA

```python
# 安装模块
pip3 install rsa -i https://pypi.douban.com/simple

import rsa
# 返回 公钥加密、私钥解密
public_key, private_key = rsa.newkeys(1024)
print(public_key)
print(private_key)

# plaintext = b"hello world"
# ciphertext = rsa.encrypt(plaintext, public_key)
# print('公钥加密后：',ciphertext)
# plaintext = rsa.decrypt(ciphertext, private_key)
# print('私钥解密：',plaintext)

### 使用私钥签名
plaintext = b"hello world"
sign_message = rsa.sign(plaintext, private_key, "MD5")
print('私钥签名后：',sign_message)

## 验证私钥签名
plaintext = b"hello world"
# method = rsa.verify(b"hello world", sign_message, public_key)
method = rsa.verify(b"hello world1", sign_message, public_key) # 报错Verification failed
print(method)

```

### 4.5 base64

```python
import base64

# 编码
res=base64.b64encode(b'hello world')
print(res)

# 解码
res=base64.b64decode('aGVsbG8gd29ybGQ=')
print(res)
```



