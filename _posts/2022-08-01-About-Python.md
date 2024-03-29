---
title: Python基础内容
date: 2023-08-01 15:01:00 +0800
author: 
categories: [Python]
tags: [Python, Notes]
pin: false
math: true
mermaid: false
---

# Python基础内容

## 一. Python3 Cheat Sheet

Python 3 Cheat Sheet latest version <https://perso.limsi.fr/pointal/python:memento>

![img](/assets/images/Python3CheatSheet.jpg)

![img](/assets/images/Python3CheatSheet2.jpg)

Python Tips <https://book.pythontips.com/en/latest/index.html>

## 二. 关于爬虫的特殊性

爬虫是一个很蛋疼的东西, 可能今天讲解的案例. 明天就失效了. 所以, 不要死盯着一个网站干.  要学会见招拆招(爬虫的灵魂)
爬虫程序如果编写的不够完善. 访问频率过高. 很有可能会对服务器造成毁灭性打击, 所以, 不要死盯着一个网站干. 请放慢你爬取的速度. 为你好, 也为网站好. 



腾讯, 阿里, 字节的网站, 反爬手段很**残忍**. 新手不要去挑战这种大厂. 等你有实力了. 慢慢研究(哪个都要研究很久....)



gov的网站, 非必要, 不爬取. 非要爬取. 请一定降低访问频率. 为你好....

P

不要以为gov的网站好欺负. 那是地方性的网站. 中央的很多重要网站都有非常强力的防护措施(瑞数等...) 这种. 愿意搞的. 自己研究. 樵夫搞不定....

网站防护很强. 但是服务器很垃圾. 



**爬虫只能爬 你看得见的东西!!!!!** 

**个人信息不能碰.**  

**不要妨碍人家网站服务器的正常运营.** 



网站的多变性: 这个是爬虫的魅力. 我们要全方位的去思考. 就像找漏洞一样. 思维逻辑不可能是固定的. 达到目的即可. 不要死磕牛角尖. 要不然, 你会死的很惨.... **要学会见招拆招**. 



关于憋代码这个事.  要憋. 一定要憋. 让你憋主要有两个原因. 

1. **简单的语法使用错误. 不憋记不住**
2. **复杂的程序逻辑. 不憋培养不出来独立思考能力.** 
3. **一定要有独立解决问题的能力.** 





## 三. 必须要掌握的py基础

### 3.1 基础语法相关

 1. if条件判断

    ```python
    if 条件:
        # 事情1
    else:
        # 事情2
    ```

    上面就是if的最基础的语法规则. 含义是, 如果条件为真, 去执行`事情1`, 如果条件不真, 去执行`事情2`. 这东西. 我就不拆开聊了. 关于if. 你要记住的事情是, `它是用来做条件判断的`. 以后你的程序里,  如果需要条件判断了. 就用它....

    举例,

    在写爬虫的时候. 我们会遇到这样的两种情况 

    情况一, 数据里有一些我们并不需要的内容

    ```python
    data = "10,英雄本色,1500万"   # 正常你需要的数据
    data = "11,-,-"  # 你不需要的数据
    
    # 伪代码, 理解含义(思路)
    if data里有你不需要的数据:
    	再见
    else:
     	保留
    
    ```

    

    情况二, 页面结构不统一, 会有两种页面结构

    ```python
    # 伪代码, 理解含义(思路)
    提取器1 = xxxx  #  用来提取页面中内容的
    提取器2 = xxxxxx
    
    # 页面有可能是不规则的。 张飞， 潘长江 
    结果1 = 提取器1.提取(页面)
    if 结果1:
        有结果. 存起来
    else:
        没有结果. 
        结果2 = 提取器2.提取(页面)
    ```

    相信我, 上面的逻辑并不难. 但是, 到了后面很多小伙伴容易踩坑. 我们完全没必要用一个提取器获取所有的数据. 完全没必要.....

    

 2. while循环
    关于循环, 我们必须要知道一个事情. 

    ```python
    while 条件:
        循环体
    ```

    如果条件为真, 就执行循环体, 然后再次判断条件.....直到条件为假. 结束循环. 

    反复的执行一段代码

    

 3. 关于True和False

    True, 是真的意思. 翻译成人话:  对的, OK, 没毛病. 确定

    False, 是假的意思. 翻译成人话: 不对劲, 错误, No. 有瑕疵. 不对劲

    这个应该都能看懂. 

    但是下面这个, 需要各位去记住

    ```python
    # 几乎所有能表示为空的东西. 都可以认为是False
    print(bool(0))
    print(bool(""))
    print(bool([]))
    print(bool({}))
    print(bool(set()))
    print(bool(tuple()))
    print(bool(None))
    # 上面这一坨全是False, 相反的. 都是真. 利用这个特性. 我们可以有以下的一些写法
    
    # 伪代码, 理解逻辑. 
    结果 = 提取器.提取(页面)
    if 结果:
        有结果. 我要保存结果
    else:
        没结果. ......
    ```

    

### 3.2  字符串  (万恶之源, 必须要会的, 而且要熟..)

字符串在`爬虫`里. 必须要知道的几个操作:

  1. 索引和切片
     索引, 就是第几个字符. 它从0开始. 
     切片, 从字符串中提取n个字符. 

     ```python
     s = "我爱黎明,黎明爱我"
     print(s[1])
     print(s[0])
     
     print(s[2:4])  从第2个, 到第4个(取不到4)
     ```

     

  2. strip()

     我们从网页上提取的数据. 很多都是带有一些杂质的(换行, 空格),怎么去掉?

     strip()可以去掉字符串`左右两端`的空白(空格, 换行\n, 回车\r, 制表符\t)

     ```python
     s = "    \t\t\t我的天哪\r\r      \n\n  "  # 够乱的字符串
     s1 = s.strip()
     print(s1)  # 好了 `我的天哪`
     ```

     

  3. split()

     split,  做切割的. 

     ```python
     s = "10,男人本色,100000万"  # 你在网页上提取到这样的一段数据. 现在我需要电影名称
     tmps = s.split(",")
     name = tmps[1]
     print(name)  # 男人本色
     
     id, name, money = s.split(",")  # 切割后. 把三个结果直接怼给三个变量
     print(id)
     print(name)
     print(money)
     ```

     

  4. replace()

     replace, 字符串替换

     ```python
     s = "我      \t\t\n\n爱   黎       明    "   # 这是你从网页上拿到的东西
     s1 = replace(" ", "").replace("\t", "").replace("\n", "")  # 干掉空格, \t, \n
     print(s1)  # 我爱黎明
     ```

     

  5. join()

     join, 将列表拼接为一个完整的字符串

     ```python
     lst = ["我妈", "不喜欢", "黎明"]  # 有时,由于网页结构的不规则, 导致获取的数据是这样的. 
     s1 = "".join(lst)  # 用空字符串把lst中的每一项拼接起来
     print(s1)  # 我妈不喜欢黎明
     
     lst2 = ["\n\r","\n\r","周杰伦\n\r", "\n不认识我\r"] 
     s2 = "".join(lst2).replace("\n", "").replace("\r", "")
     print(s2)  # 周杰伦不认识我
     
     ```

  6. f-string

     格式化字符串的一种方案

     ```python
     s = "周杰伦"
     s1 = f"我喜欢{s}"  #  它会把一个变量塞入一个字符串
     print(s1)  # 我喜欢周杰伦
     
     k = 10085
     s2 = f"我的电话号是{k+1}" # 它会把计算结果赛入一个字符串
     print(s2)  # 我的电话号是10086
     
     # 综上, f-string的大括号里, 其实是一段表达式.能计算出结果即可
     
     ```

     

### 3.3  列表

列表, 我们未来遇见的仅次于字符串的一种数据类型. 它主要是能承载大量的数据. 理论上. 你的内存不炸. 它就能一直存

1. 索引, 切片

   列表的索引和切片逻辑与字符串完全一致

   ```python
   lst = ["赵本山", "王大陆", "大嘴猴", "马后炮"]
   item1 = lst[2]  # 大嘴猴
   item2 = lst[1]  # 王大陆
   
   lst2 = lst[2:]
   print(lst2)  # ["大嘴猴", "马后炮"]
   
   # 注意, 如果列表中没有数据. 取0会报错
   lst = []
   print(lst[0])  # 报错, Index out of bounds
   
   # 注意, 如果给出的索引下标超过了列表的最大索引. 依然会报错
   lst = ["123", "456"]
   print(lst[9999])  # 报错, Index out of bounds
   
   ```

   

2. 增加

   给列表添加数据. 

   ```python
   lst = [11,22]
   lst.append(33)
   lst.append(44)
   print(lst)  # [11,22,33,44]
   ```

   

3. 删除

   删除数据(不常用, 好不容易爬到的数据. 为什么要删)

   ```python
   lst.remove("周润发")  #  把周润发删掉
   ```

   

4. 修改

   ```python
   lst = ["赵本山", "王大陆", "大嘴猴", "马后炮"]
   lst[1] = "周杰伦"
   print(lst)  # ["赵本山", "周杰伦", "大嘴猴", "马后炮"]
   ```

   

5. range

   用for循环数数的一个东西

   ```python
   for i in range(10):
       print(i)   # 从0数到9
      
   for i in range(5, 10):
       print(i)  # 从5 数到 9
   ```

6. 查询(必会!!!!)

   ```python
   lst = ["赵本山", "周杰伦", "大嘴猴", "马后炮"]
   print(lst[0])
   print(lst[1])
   print(lst[2])
   print(lst[3])
   
   # 循环列表的索引
   for i in range(len(lst)):
       print(lst[i])
   # 循环列表的内容
   for item in lst:
       print(item)
   ```

   

### 3.4  字典

字典可以成对儿的保存数据. 

1. 增加

   ```python
   dic = {}
   dic['name'] = '樵夫'
   dic['age'] = 18
   
   print(dic)  # {"name": "樵夫", "age": 18}
   ```
   
   
   
2. 修改

   ```python
   dic = {"name": "樵夫", "age": 18}
   dic['age'] = 19
   print(dic)  # {"name": "樵夫", "age": 19}
   ```

   

3. 删除(不常用)

   ```python
   dic = {"name": "樵夫", "age": 18}
   dic.pop("age")
   print(dic)  # {'name': '樵夫'}
   ```

   

4. 查询(重点)

   ```python
   dic = {"name": "樵夫", "age": 18}
   
   a = dic['name']  # 查询'name'的值
   print(a)  # 樵夫
   
   b = dic['age']  # 拿到dic中age对应的值
   print(b)  # 18
   
   c = dic['哈拉少']   # 没有哈拉少. 报错
   d = dic.get("哈拉少")  # 没有哈拉少, 不报错. 返回None. 它好. 它不报错
   
   ```

   循环

   ```python
   dic = {"name": "樵夫", "age": 18}
   for k in dic:  # 循环出所有的key
       print(k)  
       print(dic[k])  # 获取到所有的value并打印
       
   ```

   嵌套

   ```python
   dic = {
       "name": "王峰",
       "age": 18,
       "wife": {
           "name": "章子怡",
           "age": 19,
       },
       "children": [
           {'name':"胡一菲", "age": 19},
           {'name':"胡二菲", "age": 18},
           {'name':"胡三菲", "age": 17},
       ]
   }
   
   # 王峰的第二个孩子的名字
   print(dic['children'][1]['name'])
   # 王峰所有孩子的名称和年龄
   for item in dic['children']:
       print(item['name'])
       print(item['age'])
   ```

   
   
   

### 3.5  字符集和bytes

字符集, 记住两个字符集就够了. 一个是utf-8, 一个是gbk. 都是支持中文的. 但是utf-8的编码数量远大于gbk. 我们平时使用的最多的是utf-8

```python
# 把字符串转化成字节
bs = "我的天哪abcdef".encode("utf-8")
print(bs)  #  b'\xe6\x88\x91\xe7\x9a\x84\xe5\xa4\xa9\xe5\x93\xaaabcdef'
# 一个中文在utf-8里是3个字节. 一个英文是一个字节. 所以英文字母是正常显示的

# 把字节还原回字符串
bs = b'\xe6\x88\x91\xe7\x9a\x84\xe5\xa4\xa9\xe5\x93\xaaabcdef'
s = bs.decode("utf-8")
print(s)

```

记住, bytes不是给人看的. 是给机器看的. 我们遇到的所有文字, 图片, 音频, 视频. 所有所有的东西到了计算机里都是字节. 





### 3.6 文件操作

python中. 想要处理一个文件. 必须用open()先打开一个文件

语法规则

```python
f = open(文件名, mode="模式", encoding='文件编码')
f.read()|f.write()
f.close()

```

文件名就不解释了. 

模式: 
	我们需要知道的主要有4个. 分别是: r, w, a, b

1. r  只读模式. 含义是, 当前这一次open的目的是读取数据. 所以, 只能读. 不能写
2. w 只写模式. 含义是, 当前这一次open的目的是写入数据. 所以, 只能写, 不能读
3. a 追加模式. 含义是, 当前这一次open的目的是向后追加. 所以, 只能写, 不能读
4. b 字节模式. 可以和上面三种模式进行混合搭配. 目的是. 写入的内容或读取的内容是字节. 

问: 

1. 如果我想保存一张图片. 应该用哪种模式?
2. 我想读取txt文件, 用哪种模式?
3. 我想复制一个文件. 应该用哪种模式?

encoding: 文件编码. 只有处理的文件是文本的时候才能使用. 并且mode不可以是`b`.   99%的时候我们用的是`utf-8`

另一种写法:

```python
with open(文件名, mode=模式, encoding=编码) as f:
    pass
```

这种写法的好处是, 不需要我们手动去关闭`f`

读取一个文本文件:

```python
with open("躺尸一摆手.txt", mode="r", encoding="utf-8") as f:
    for line in f:  # for循环可以逐行的进行循环文件中的内容
        print(line)
```



### 3.7  关于函数

在代码量很少的时候, 我们并不需要函数. 但是一旦代码量大了. 一次写个几百行代码. 调试起来就很困难. 此时, 建议把程序改写成一个一个具有特定功能的函数. 方便调试. 也方便代码的重用

```python
def 函数名(形式参数):
    # 函数体
    return 返回值
```

上面是编写一个函数的固定逻辑. 但是, 编写好的函数是不会自己运行的. 必须有人调用才可以

```python
函数名(实际参数)
```

写一个试试:

```python
def get_page_source(url):
    print("我要发送请求了. 我要获取到页面源代码啊")
    return "页面源代码"

pg_one = get_page_source("baidu.com")
pg_two = get_page_source("koukou.com")
```

再来一个

```python
def download_image(url, save_path):
    print(f"我要下载图片{url}了", f"保存在{save_path}")

donwload_image("https://www.baidu.com/abc/huyifei.jpg", "胡二飞.jpg")
donwload_image("https://www.baidu.com/aaa/dagedagefeifeifei.jpg", "大哥大哥飞飞飞.jpg")

```

总结, 函数的好处就是, 以后需要该功能. 不用再写重复代码了. 



### 3.8 关于模块

模块是啥? 模块就是已经有人帮我们写好了的一些代码, 这些代码被保存在一个py文件或者一个文件夹里. 我们可以拿来直接用

在python中有三种模块.

第一种, python内置模块

​	不用安装. 直接导入就能用

第二种, 第三方模块

​	需要安装. 安装后. 导入就可以用了

第三种, 自定义模块(新手先别自己定义模块)

​	直接导入就能用

导入模块的语法

```python
import 模块
from 模块 import 功能
from 模块.子模块 import 功能

举例子, 
import os
import sys
from urllib.parse import urljoin
from bs4 import BeautifulSoup
```

搞爬虫.必须要了解的一些python内置模块

1. time模块

   ```python
   import time
   time.time()  # 这个是获取到时间戳
   time.sleep(999)  # 让程序暂停999秒
   ```

   

2. os模块

   ```python
   import os
   # 判断文件是否存在
   os.path.exists()  #  判断文件或者文件夹是否存在
   os.path.join()    # 路径拼接
   os.makedirs()     # 创建文件夹
   
   ```

   

3. json模块(重中之重)

   现在的网站不同于从前了. 习惯性用json来传递数据. 所以, 我们必须要知道json是啥, 以及python如何处理json. 

   json是一种类似字典一样的东西.  对于python而言, json是字符串. 

   

   例如, 

   ```python
   s = '{"name": "jay", "age": 18}'
   ```

   你看. 这破玩意就是`json`

   如何来转化它. 

   **<span style="background-color:yellow;color:red;">json字符串 => python字典</span>**

   ```python
   import json
   s = '{"name": "jay", "age": 18}'
   dic = json.loads(s)
   print(type(dic))
   ```

   **<span style="background-color:yellow;color:red;">python字典 => json字符串</span>**

   ```python
   import json
   dic = {"name": "jay", "age": 18}
   s = json.dumps(dic)
   print(type(s))
   ```

   

4. random模块

   随机. 没别的用处.生成随机数

   ```python
   import random
   i = random.randint(1, 10)  # 1~10的随机数
   print(i)   # 多跑两次.效果更加
   ```

   

5. 异常处理

   这个是重点. 我们在写爬虫的时候. 非常容易遇到问题. 但这些问题本身并不是我们程序的问题. 

   比如, 你在抓取某网站的时候. 由于网络波动或者他服务器本身压力太大. 导致本次请求失败. 这种现象太常见了. 此时, 我们程序这边就会崩溃. 打印一堆红色的文字. 让你难受的一P.  怎么办?

   我们要清楚一个事情. 我们平时在打开一个网址的时候. 如果长时间没有反应, 或者加载很慢的时候. 我们习惯性的会刷新网页. 对吧. 这个逻辑就像: `程序如果本次请求失败了. 能不能重新来一次`. OK, 我们接下来聊的这个异常处理. 就是干这个事儿的. 

   ```python
   try: # 尝试...
       print("假如, 我是一段爬虫代码, 请求到对方服务器")
       print("我得出事儿啊")
       print(1/0)  # 出事儿了
   except Exception as e:  # 出错了. 我给你兜着
       print(e)  # 怎么兜?  打印一下. 就过去了
       
   print("不论上面是否出错. 我这里, 依然可以执行")
   ```

   看懂了么? 程序执行的时候. 如果`try`中的代码出现错误. 则自动跳到`except`中. 并执行`except`中的代码. 然后程序正常的, 继续执行

   有了这玩意. 我们就可以写出一段很漂亮的代码逻辑:

   ```python
   while 1:
       try:
           我要发送请求了. 我要干美国CIA的总部. 我要上天
           print("我成功了!!")
           break  # 成功了.就跳出循环
       except Exception as e:
           print("失败了")
           print("我不怕失败")
           print("再来")
          
   ```

   改良版:

   ```python
   import time
   for i in range(10):
       try:
           我要发送请求了. 我要干美国CIA的总部. 我要上天
           print("我成功了!!")
           break  # 成功了.就跳出循环
       except Exception as e:
           print("失败了")
           print("我不怕失败")
           print("再来")
           time.sleep(i * 10)
          
   ```