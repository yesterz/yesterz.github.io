---
title: adb & 抓包
date: 2023-04-01 10:51:00 +0800
author: 
categories: [Python]
tags: [Python, App Reverse]
pin: false
math: true
mermaid: false
img_path: /assets/images/
---



## 1 逆向基本流程

```python
# 1 获取目标app(官网，豌豆荚)，安装到手机上
# 2 使用抓包工具抓包分析（charles，fiddler，Wireshark。。）
# 3 使用反编译工具（JADX、JD-GUI），反编译apk成java代码，分析代码，定位代码位置
# 4 使用动态分析工具，如Frida、Xposed Framework等，在运行时跟踪应用程序的行为和交互。理解应用程序的运行逻辑和处理过程
# 5 使用python还原代码，模拟发送请求
```



## 2 ADB配置和使用

### 2.1 ADB是什么？

```python
「adb」即 Android Debug Bridge ，亦称安卓调试桥，是谷歌为安卓开发者提供的开发工具之一，可以让你的电脑以指令窗口的方式控制手机。

可以在安卓开发者网页中的 SDK 平台工具页面下直接下载对应系统的 adb 配置文件，大小只有几十MB

# 1 下载地址(下载对应平台的adb)最新版：
	https://developer.android.com/studio/releases/platform-tools?hl=zh-cn
# 2 各平台历史版本下载地址：
	https://androidmtk.com/download-android-sdk-platform-tools
  
# 3 对应平台压缩包下载后，解压即可（配置好环境变量：在任意位置可以执行adb命令）
	内含：adb工具和fastboot工具
```

### 2.2 ADB版本的选择

```python
# 目前最新版本
	34.0.1（2023 年 3 月）
  
# 建议选择  30.0.5，亲测刷机pixel 2xl，使用高版本不成功

# 下载地址：
链接: https://pan.baidu.com/s/1JxmjfGhWqWjpkprqi6GGrQ 
提取码: yyhx
# 其它资料包---》adb-platform-tools
platform-tools_r34.0.3-windows.zip
platform-tools_r30.0.5-windows.zip
platform-tools_r30.0.5-mac.zip
platform-tools_r30.0.5-linux.zip
```



### 2.3 ADB 安装和配置

#### 2.3.1 win 平台安装

```python
# 1 下载压缩包后，解压 到C:\soft\platform-tools
# 2 把该路径加入到环境变量：我的电脑---》属性---》高级系统设置---》环境变量
# 3 在cmd中验证(以管理员身份打开)
	adb version
```

![image-20230613154453483](./assets/image-20230613154453483.png)

#### 2.3.2 mac/linux平台安装配置

```python
# 1 下载压缩包platform-tools_r30.0.5-mac.zip，解压到：/Users/lqz/soft/platform-tools
# 2 把上述路径加入到环境变量
vi .zprofile
export PATH=${PATH}:/Users/lqz/soft/platform-tools
# 3 让配置生效
source .zprofile

# 4 打开终端测试
	adb version

```

 <img src="./assets/image-20230613155903570.png" alt="image-20230613155903570" style="zoom:50%;" />

#### 2.3.3 环境变量介绍

```python
环境变量是操作系统中用于存储系统级别配置信息的一种机制，可以为应用程序提供统一的配置和运行环境

路径在环境变量下，该路径下的可执行文件，可以在任意路径下执行
```



### 2.4 ADB 操作手机

#### 2.4.1 开启USB调试

```python
# 1 点击Settings(设置) ->  About phone(关于手机) ->版本号(最底部)--->点击7次（开启usb调试）
# 2 点击Settings(设置) -> 系统---> 高级--->开发者选项--》进入
  -开启USB调试
# 3 数据线连接电脑，按照下图提示操作
```

<img src="./assets/image-20230613155951855.png" alt="image-20230613155951855" style="zoom:50%;" />

<img src="./assets/image-20230613160021349.png" alt="image-20230613160021349" style="zoom:50%;" />

<img src="./assets/image-20230613160045440.png" alt="image-20230613160045440" style="zoom:50%;" />

<img src="./assets/image-20230613160134616.png" alt="image-20230613160134616" style="zoom:50%;" />

### 2.5 ADB常用命令

```python
# 开启关闭adb服务
  adb start-server     启动ADB
  adb kill-server		   关闭ADB
  adb devices          查看已连接的设备
  
# 上传和下载文件
  adb -s 设备id号 push C:\demo.txt  /sdcard
  adb -s 设备id号 pull /sdcard/demo.txt C:\

# 安装和卸载app
  adb  install C:\2345Downloads\xianyu.apk
  adb  uninstall  包名称
  adb  shell pm list packages 		  		  # 查看包列表
  adb  shell pm list packages	-e 关键字   	# 查看包列表（搜索）

# 查看处理器（32位/64位）
  adb shell -s 设备id号 getprop ro.product.cpu.abi 
  adb shell getprop ro.product.cpu.abi
 	'''
 	armeabi-v7a（32位ARM设备）
  arm64-v8a  （64位ARM设备）
 	'''


# 进入系统命令(跟linux命令完全一致)，
# 本身adb操作是不需要root的，但是如果不root手机，不能切换到root用户
adb shell  # 进入命令行
taimen:/ $ su # 切换为root用户，必须root
taimen:/ # ls
'''
acct        data           firmware         odm          sdcard
apex
'''


# 其他
  - 查看手机设备：adb devices
  - 查看设备型号：adb shell getprop ro.product.model
  - 查看电池信息：adb shell dumpsys battery
  - 查看设备ID：adb shell settings get secure android_id
  - 查看设备IMEI：adb shell dumpsys iphonesubinfo
  - 查看Android版本：adb shell getprop ro.build.version.release
  - 查看手机网络信息：adb shell ifconfig
  - 查看设备日志：adb logcat
  - 重启手机设备：adb reboot
  - 安装一个apk：adb install /path/demo.apk
  - 卸载一个apk：adb uninstall <package>
  - 查看系统运行进程：adb shell ps
  - 查看系统磁盘情况：adb shell ls /path/
  - 手机设备截屏：adb shell screencap -p /sdcard/aa.png
  - 手机文件下载到电脑：adb pull /sdcard/aa.png ./
  - 电脑文件上传到手机：adb push aa.png /data/local/
  - 手机设备录像：adb shell screenrecord /sdcard/ab.mp4
  - 手机屏幕分辨率：adb shell wm size
  - 手机屏幕密度：adb shell wm density
  - 手机屏幕点击：adb shell input tap xvalue yvalue
  - 手机屏幕滑动：adb shell input swipe 1000 1500 200 200
  - 手机屏幕带时间滑动：adb shell input swipe 1000 1500 0 0 1000
  - 手机文本输入：adb shell input text xxxxx
  - 手机键盘事件：adb shell input keyevent xx


```



## 3 通过ABD线刷手机及root手机

### 3.1 Recovery介绍

```python
# 1 TWRP是国外Android爱好者开发的一款工具，全名是：（Team Win Recovery Project）。TWRP的主要作用包括刷机，备份，恢复等。安卓修复的时候TWRP是必不可少的工具。是一款知名第三方recovery刷机工具，功能强大，支持触屏操作。

# 2 recovery相当于Windows PE微型系统，在recovery里我们也可以挂载磁盘，修改系统分区，使用adb命令，等一系列功能

# 3 它是一种自定义恢复模式，与设备自带的恢复模式相比，TWRP提供了更多的功能和选项，使用户能够更灵活地管理和操作他们的Android设备。

# 4 recovery相当于Windows PE微型系统，在recovery里我们也可以挂载磁盘，修改系统分区，使用adb命令，等一系列功能
# 5 TWRP具有以下主要特点：
完整的触摸操作界面：TWRP提供了易于导航的触摸操作界面，用户可以使用手指滑动和点击来浏览和选择不同的选项。
完整的备份和恢复功能：TWRP允许用户对整个系统进行完整的备份，包括操作系统、应用程序、数据和设置。用户可以随时使用这些备份来恢复设备到先前的状态。
安装第三方固件和补丁：使用TWRP，用户可以安装自定义固件、ROM、补丁和MOD。这使得用户能够个性化和定制他们的设备，并享受各种功能和优化。
分区管理：TWRP提供了对设备分区的灵活管理。用户可以查看和操作不同的分区，包括系统分区、数据分区、缓存分区和恢复分区。
刷入ZIP文件：通过TWRP，用户可以轻松地刷入ZIP格式的文件，如应用程序、主题、内核等
```



### 3.2 root手机方案一(twrp recovery方式)

```python
# 1 下载最新版面具(Magisk)
https://github.com/topjohnwu/Magisk/releases

# 2 下载后，复制一份apk，后缀名改为 .zip

# 3 把Magisk-v26.1.apk安装在手机上
	adb install -r /Users/lqz/soft/Magisk-v26.1.apk
  # 显示安装成功
  Performing Streamed Install
	Success
  # 此时打开Magisk，看到超级用户栏是无法点选的，因为没有root
  
# 4 把Magisk-v26.1.zip推送到手机上
adb push /Users/lqz/soft/Magisk-v26.1.zip  /sdcard/Download
# 推送成功
/Users/lqz/soft/Magisk-v26.1.zip: 1 fi.... 23.9 MB/s (11411692 bytes in 0.455s)

# 5 在手机的文件管理器中能看到该zip

# 6 重启手机，fastboot模式
	adb reboot bootloader
  # 又见到了熟悉的界面
# 7 查看fastboot是否正常连接手机
	fastboot devices
  
# 8 刷入recovery（临时刷入，重启后会没有了）
	fastboot boot /Users/lqz/soft/twrp-3.6.2_9-0-taimen.img # 注意img文件的路径正确
  Sending 'boot.img' (40960 KB)                      OKAY [  0.972s]
  Booting                                            OKAY [  0.001s]
  Finished. Total time: 1.013s
  
# 9 手机会自动重启，进入recovery模式【在手机上操作】

# 10 选择 Install – 找到目录 /sdcard/Download – 选择 Magisk-v26.1.zip 文件 – 弹出安装界面 – 直接滑动底部的滑条 Swipe to confirm Flash 安装： 

# 11 安装完成后，手机开机，打开面具软件Magisk，会提示如下图
	点击修复---》直接安装---》等待修复成功，重启手机就root了
  
  
##### 详细步骤：参照https://www.cnblogs.com/liuqingzheng/p/17462146.html
```

### 3.2 root 手机方案二（刷机改img方式）

```python
# 1 下载Magisk给手机root
	地址： https://github.com/topjohnwu/Magisk/releases
  
# 2 下载 Magisk-v26.1.apk
# 3 把Magisk-v26.1.apk安装在手机上
	adb install -r /Users/lqz/soft/Magisk-v26.1.apk
  # 显示安装成功
  Performing Streamed Install
	Success
  # 此时打开Magisk，看到超级用户栏是无法点选的，因为没有root
  
# 4 解压压缩包，刚刚装系统的压缩包解压后有image-taimen-rp1a.201005.004.a1.zip，把它解压
	'''
  bootloader-taimen-tmz30m.img
  flash-all.bat
  flash-all.sh
  flash-base.sh
  image-taimen-rp1a.201005.004.a1.zip
  radio-taimen-g8998-00034-2006052136.img
	'''
  
# 5 文件如下
  '''
  android-info.txt
  boot.img         # 引导镜像
  dtbo.img
  system_other.img
  system.img
  vbmeta.img
  vendor.img
  '''
# 6 把引导镜像[boot.img]，使用Magisk修补[一定要注意文件路径]
	adb push ./boot.img /sdcard/Download
  
# 7 在手机上打开Magisk，选择安装--》选择修补一个文件---》选择上传的 boot.img ---》点击开始---》修补完成后变成
	adb pull /sdcard/Download/magisk_patched-26100_0DQpw.img /Users/lqz/soft
  # 从手机拖到电脑上了 
  
# 8 手机进入fastboot模式
adb reboot bootloader
fastboot devices
# 9 执行 
fastboot flash boot /Users/lqz/soft/magisk_patched-26100_0DQpw.img

# 10 重启手机，root完成
adb reboot bootloader

# 11 设备有A/B分区的话，需要执行
fastboot flash boot_a /Users/lqz/soft/magisk_patched-26100_0DQpw.img
fastboot flash boot_b /Users/lqz/soft/magisk_patched-26100_0DQpw.img
# 重启设备
fastboot reboot


# 12 开启手机，打开Magisk，发现root成功



# 详细流程参照:https://www.cnblogs.com/liuqingzheng/p/17462127.html
```





## 4 数据包抓取

### 4.1 抓包工具选择

```python
# Wireshark：Wireshark 是一个开源的网络抓包工具，可以在多个平台上运行，支持多种协议的抓取和分析。

# Fiddler：Fiddler 是一个跨平台的抓包工具，可以用于捕获和分析 HTTP 和 HTTPS 流量。它提供了强大的调试和排查功能。

# Charles Proxy：Charles Proxy 是一款跨平台的代理服务器工具，可以捕获并分析 HTTP 和 HTTPS 流量。它具有图形化界面和丰富的功能，适用于移动设备和桌面应用程序的抓包。

# Tcpdump：Tcpdump 是一个命令行抓包工具，适用于 Linux 和 Unix 系统。它可以捕获和分析网络流量，并提供灵活的过滤和输出选项
```

![image-20230613164819832](./assets/image-20230613164819832.png)



### 4.2 charles安装和配置

#### 4.2.1 mac安装配置

```python
# 1 下载软件：Charles_4.5.6_xclient.info.dmg
# 2 双击安装
# 3 打开软件，输入sn码破解
```



#### 4.2.2 win安装配置

```python
# 1 下载软件：charles-proxy-4.5.6-win64.msi
# 2 一路下一步安装
# 3 打开软件，输入sn码破解
```



#### 4.2.3 sn账号

```python
Name: Just For Testing
Serial: 230ADA2020DFBD108E

Name: TEAM MESMERiZE
Serial: FC91D362FB19D6E6CF

Name: MSJ
Serial: 1101CAF6A1989C62AC
```



### 4.3 使用charles抓取手机http包

```python
# 配置步骤
【电脑】安装并运行抓包工具 charles
【手机】配置手机系统代理
```

#### 4.3.1 配置模拟器抓包

```python
# 1  打开charles，点击：proxy--》proxy Settings---》如下图1
# 2  打开charles，点击：help--》Local ip address-->查看本机地址--》下图2--》
	或执行命令查看：
  win：ipconfig
  mac：ifconfig
  # 我的是192.168.1.173
# 3 打开mumu模拟器---》设置--》wlan---》长按---》配置代理
```

<img src="./assets/image-20230613165253305.png" alt="image-20230613165253305" style="zoom:50%;" />

<img src="./assets/image-20230613165650846.png" alt="image-20230613165650846" style="zoom:50%;" />

<img src="./assets/image-20230613174205569.png" alt="image-20230613174205569" style="zoom:50%;" />



#### 4.3.2 配置真机抓包

```python
# 1  打开charles，点击：proxy--》proxy Settings---》如下图1
# 2  打开charles，点击：help--》Local ip address-->查看本机地址--》下图2--》
	或执行命令查看：
  win：ipconfig
  mac：ifconfig
  # 我的是192.168.1.173
# 3 打开真机---》设置--》wlan---》长按---》配置代理
```

<img src="./assets/image-20230613174433898.png" alt="image-20230613174433898" style="zoom:50%;" />

#### 4.3.3 抓取http包案例(爱学生app)

```python
import requests
data={"code":"","password":"lqz12345","username":"18953675221","uuid":""}
res=requests.post('http://parentsystem.aixuesheng.net/app/v1/patriarchLogin/1',json=data)
print(res.text)
```



### 4.4 使用charles抓取手机https包（手机需要root）

#### 4.4.1 模拟器安装charles证书

```python
手机或模拟器只能抓取http请求的数据包，https无法抓取。
想要抓取，就需要在手机上安装charles的证书。

### 注意：
	安卓7 以下设备，安装完证书就可以使用，不用移动证书
	安卓7以上设备，安装完证书后，为用户证书，必须把用户证书，移动成系统证书，需要借助于magisk刷move cert模块,需要root权限
```

```python
###### 模拟器安装（模拟器版本低于7，不需要做证书迁移） ######
# 1 打开charles--》help---》SSLProxying---》InstallCharles Root Certificate on a Mobile...
# 2 访问网址  chls.pro/ssl
# 3 手机设置完代理，才能访问
# 4 下载安装证书

# 5 就可以抓取http的包了

```

![image-20230613174851004](./assets/image-20230613174851004.png)

![image-20230613175000594](./assets/image-20230613175000594.png)

#### 4.4.2  真机安装charles证书

```python
# 1 真机配置好代理后
# 2 浏览器访问：chls.pro/ssl
# 3 下载后，手机打开：安全---》加密与凭据---》安装证书---》安装完成
# 4 手机打开：安全--》加密与凭据---》信任的凭据
	-此时可以看到用户证书和系统证书
```

<img src="./assets/image-20230613181740583.png" alt="image-20230613181740583" style="zoom:50%;" />

<img src="./assets/image-20230613181808528.png" alt="image-20230613181808528" style="zoom:50%;" />

<img src="./assets/image-20230613181904592.png" alt="image-20230613181904592" style="zoom:50%;" />

<img src="./assets/image-20230613181957192.png" alt="image-20230613181957192" style="zoom:50%;" />

<img src="./assets/image-20230613182126084.png" alt="image-20230613182126084" style="zoom:50%;" />

#### 4.4.3 用户证书和系统证书解释

```python
在 Android 系统中，有两种类型的证书：用户证书（User Certificates）和系统证书（System Certificates）。

用户证书（User Certificates）：用户证书是由特定用户生成或颁发的数字证书。这些证书通常用于用户身份验证和安全通信。用户证书可以用于加密和解密数据，数字签名以及建立安全连接。用户证书通常由用户自己创建，例如，用于加密电子邮件、VPN连接或身份验证。

系统证书（System Certificates）：系统证书是由 Android 系统或设备制造商预装的证书。这些证书通常用于系统级别的安全功能，如应用程序签名验证、SSL/TLS 连接等。系统证书通常用于验证应用程序的真实性和完整性，以确保它们没有被篡改或恶意修改。这些证书由 Android 操作系统或设备制造商管理和维护。

系统证书包括以下几种类型：

代码签名证书：用于验证应用程序的签名，以确保应用程序的真实性和完整性。
安全通信证书：用于建立 SSL/TLS 连接，保护设备和服务器之间的通信安全。
根证书：根证书用于验证其他证书的真实性。Android 系统预装了一组根证书，用于验证 SSL/TLS 通信中的服务器证书。
用户证书和系统证书在安全和身份验证方面扮演不同的角色。用户证书由用户自己管理，用于个人身份验证和加密通信。而系统证书由操作系统或设备制造商管理，用于验证应用程序和保护系统级别的通信安全。
```

#### 4.4.4 把用户证书转成系统证书

```python
# 1 将move cert压缩包传到手机（任意好找的一个目录 `/sdcard/Download/`）
adb push /Users/lqz/soft/movecert-1.9-4.zip  /sdcard/Download
# 2 使用面具，刷入
	按照下图步骤
  
# 3 重启手机

# 4 手机打开：安全--》加密与凭据---》信任的凭据
	-此时可以看到用户级别证书移动到系统级别了
  
# 5 此时可以愉快抓https包了

```



<img src="./assets/image-20230613182733476.png" alt="image-20230613182733476" style="zoom:50%;" />

<img src="./assets/image-20230613182527697.png" alt="image-20230613182527697" style="zoom:50%;" />

<img src="./assets/image-20230613182815594.png" alt="image-20230613182815594" style="zoom:50%;" />

<img src="./assets/image-20230613182834375.png" alt="image-20230613182834375" style="zoom:50%;" />

#### 4.4.5 案例：抓取https包(今日南川app)

![image-20230613181028791](./assets/image-20230613181028791.png)

```python
import requests

data = {
    'appId': '32',
    'hashSign': '133bcb5e7330257a8823747b492d28b2',
    'imgUrl': '',
    'lat': '29.568295',
    'lng': '106.559123',
    'loginName': '18953645221',
    'nickName': '',
    'openId': '',
    'place': '重庆',
    'pwd': '827ccb0eea8a706c4c34a16891f84e7b',
    'sessionId': '392032c5-09c8-4c3c-bb17-16a1dc49f7fc',
    'token': "",
    'type': '',
}
headers = {
    'appid': '32',
    'sessionid': '392032c5-09c8-4c3c-bb17-16a1dc49f7fc',
    'token': '',
    't': '1686650472124',
    'sign': '90b5afeaed045a4c5ac9b13f693c7023',
    'cqlivingappclienttype': '1',
    'cqlivingappclientversion': '2029',
    'content-type': 'application/x-www-form-urlencoded',
    'content-length': '249',
    'accept-encoding': 'gzip',
    'user-agent': 'okhttp/4.10.0',
}
res = requests.post('https://api.cqliving.com/login.html', data=data, verify=False,headers=headers)
print(res.text)
```



