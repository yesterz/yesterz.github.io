---
title: 爬虫实战案例
date: 2023-02-01 10:51:00 +0800
author: 
categories: [Python]
tags: [Python, Web Crawler]
pin: false
math: true
mermaid: false
img_path: 
---

## 爬虫案例网址

| Website                                              | Link                                                                                         |
|------------------------------------------------------|----------------------------------------------------------------------------------------------|
| 豆瓣影评                                               | <https://movie.douban.com/review/best/>                                                       |
| 豆瓣电影 Top 250                                      | <https://movie.douban.com/top250?start=1>                                                     |
| 豆瓣电影                                               | <https://movie.douban.com/explore>                                                            |
| 三国演义                                               | <https://www.shicimingju.com/book/sanguoyanyi.html>                                            |
| 彼岸图网                                               | <http://pic.netbian.com>                                                                     |
| 站长之家                                               | <https://sc.chinaz.com/tupian/renwutupian.html>                                               |
| 雪球网（请求携带cookie）                                 | <https://xueqiu.com>                                                                         |
| 17k小说网                                              | <https://passport.17k.com/>                                                                  |
| 古诗文                                                | <https://so.gushiwen.cn>                                                                     |
| 梨视频                                                | <https://www.pearvideo.com/>                                                                 |
| 明朝那些事儿全集在线阅读                                 | <http://www.mingchaonaxieshier.com/>                                                         |
| 抽屉榜                                                | <https://dig.chouti.com>                                                                     |
| 亚洲大学排行                                            | <http://www.webometrics.info/en/Asia>                                                         |
| 笔趣阁小说                                              | <https://www.xbiquwx.la/>                                                                    |
| 图片之家                                               | <https://www.tupianzj.com/>                                                                  |
| 爱斗图                                                | <https://aidotu.com/bqb/oppmgyv.html>                                                        |
| 东方财富网股票                                           | <http://quote.eastmoney.com/center/gridlist.html#hs_a_board>                                   |
| 天涯论坛                                               | <https://bbs.tianya.cn/m/post-140-393974-6.shtml>                                              |
| 小米应用商店                                             | <https://app.mi.com>                                                                         |
| 金投网                                                | <https://cang.cngold.org/c/2022-06-14/c8152503.html>                                           |
| 2019中国票房                                            | <http://www.boxofficecn.com/boxoffice2019>                                                    |
| 四大名著                                               | <http://www.shicimingju.com/bookmark/sidamingzhu.html>                                         |
| 邮政编码查询                                             | <http://www.yb21.cn>                                                                         |
| 空气质量                                               | <https://www.aqistudy.cn/historydata/>                                                       |
| k58极速开奖                                           | <https://www.k581.com/pc/views/games/jspk10/lishikj.html>                                     |
| 鬼吹灯                                                | <https://www.51shucheng.net/daomu/guichuideng>                                                |
| 阅读文章网                                              | <https://www.3dst.cn/t/lizhigushi/>                                                           |
| 腾牛网图片                                              | <https://www.qqtn.com/wm/meinvtp_1.html>                                                      |
| 励志故事                                               | <https://www.3dst.cn/t/lizhigushi/>                                                           |
| 表情党图片                                              | <https://qq.yh31.com/xq/wq/>                                                                  |
| 笑话集                                                | <http://www.jokeji.cn/>                                                                      |
| ChinaUnix                                          | <http://bbs.chinaunix.net>                                                                    |
| 电影天堂                                              | <https://www.dytt8.net/html/gndy/dyzz/list_23_1.html>                                         |
| 天天基金                                               | <http://fundf10.eastmoney.com/jbgk_004400.html>                                                |
| 中信证券                                               | <http://www.cs.ecitic.com/newsite/cpzx/jrcpxxgs/zgcp/index.html>                               |
| 趣书网                                                | <https://www.qubook.cc/>                                                                      |
| 别逗了                                                | <https://www.biedoul.com/>                                                                    |
| 笑话网                                                | <https://www.xiaohua.com/>                                                                   |
| 桌面图片                                               | <https://desk.zol.com.cn/dongman/>                                                            |
| 读书                                                 | <https://www.dushu.com/book/1188_1.html>                                                      |
| 当当图书                                               | <http://category.dangdang.com/cp01.01.02.00.00.00.html>                                       |
| 星巴克                                                | <https://www.starbucks.com.cn/menu>                                                           |
| 站长之家                                               | <https://top.chinaz.com/hangyemap.html>                                                        |
| 冶金信息技术网数据抓取                                      | <http://www.metalinfo.cn/mi.html>                                                             |
| 优美图库                                               | <http://www.umeituku.com/bizhitupian/diannaobizhi/15120.htm>                                  |

## 1 金山词霸

```python
import requests
import json

# http://www.iciba.com/fy
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
}
# 异步加载的url
url = "http://ifanyi.iciba.com/index.php?c=trans&m=fy&client=6&auth_user=key_web_fanyi&sign=9cfdff94c4346abc"
# 携带的表单数据
data = {
    "from": "en",
    "to": "zh",
    "q": "lucky",
}
# 发起post请求 并携带表单数据
res = requests.post(url=url, data=data, headers=headers)
# print(res.json())
out_dict = json.loads(res.content.decode("UTF-8"))
# print(out_dict)
print(out_dict["content"]["out"])
```

## 2 金投网

```python
import requests
from lxml import etree


headers = {
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
}
url = "https://cang.cngold.org/c/2022-06-14/c8152503.html"
res = requests.get(url=url, headers=headers)
# 获取页面源码 进行解码
html = res.content.decode()
# 实例化etree对象
tree = etree.HTML(html)
# 获取table表格里面的所有的tr行
tr_list = tree.xpath("//table[2]/tbody/tr")
for tr in tr_list:
    print(tr.xpath("./td//text()"))
```

## 3 豆瓣选电影

```python
import requests

# https://movie.douban.com/explore

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
    "Referer": "https://movie.douban.com/explore",
    "Cookie": 'bid=Xnvpbf2UbNg; __utmz=30149280.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=5028ab4b8008b53a-220b4cdd1ed600d1:T=1662087122:RT=1662087122:S=ALNI_MaI55OFkTI5OzNkCDeyUH-1zy45GA; ll="108288"; __gpi=UID=000009611986ae99:T=1662087122:RT=1662343032:S=ALNI_MZVkkj-vdzxwX6USZE71UDU76THeA; gr_user_id=fd68f82d-ef5b-4795-af4d-659a761a5b01; ap_v=0,6.0; __utma=30149280.1908426674.1662087122.1675222882.1675258117.8; __utmb=30149280.0.10.1675258117; __utmc=30149280; dbcl2="217661198:AoacdqjqELA"; ck=DvZ3; push_noty_num=0; push_doumail_num=0; frodotk_db="f3dfd9567fbe2376db9f8c037f3a6a62"',
}
url = "https://m.douban.com/rexxar/api/v2/movie/recommend?refresh=0&start=0&count=20&selected_categories=%7B%7D&uncollect=false&tags=&ck=DvZ3"
res = requests.get(url, headers=headers)
items = res.json()["items"]
for m in items:
    print(m.get("title"))
```

## 4 豆瓣选电影下载封面

```python
import os.path
import random
import time
import requests

# https://movie.douban.com/explore

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
    "Referer": "https://movie.douban.com/explore",
    "Cookie": 'bid=Xnvpbf2UbNg; __utmz=30149280.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=5028ab4b8008b53a-220b4cdd1ed600d1:T=1662087122:RT=1662087122:S=ALNI_MaI55OFkTI5OzNkCDeyUH-1zy45GA; ll="108288"; __gpi=UID=000009611986ae99:T=1662087122:RT=1662343032:S=ALNI_MZVkkj-vdzxwX6USZE71UDU76THeA; gr_user_id=fd68f82d-ef5b-4795-af4d-659a761a5b01; ap_v=0,6.0; __utma=30149280.1908426674.1662087122.1675222882.1675258117.8; __utmb=30149280.0.10.1675258117; __utmc=30149280; dbcl2="217661198:AoacdqjqELA"; ck=DvZ3; push_noty_num=0; push_doumail_num=0; frodotk_db="f3dfd9567fbe2376db9f8c037f3a6a62"',
}
url = "https://m.douban.com/rexxar/api/v2/movie/recommend?refresh=0&start=0&count=20&selected_categories=%7B%7D&uncollect=false&tags=&ck=DvZ3"
res = requests.get(url, headers=headers)
items = res.json()["items"]
# 创建存储图片的文件夹
path = "img"
if not os.path.exists(path):
    os.mkdir(path)
# 循环获取下载
i = 0
for m in items:
    try:
        # 进行图片的下载
        res = requests.get(m["pic"]["large"], headers=headers)
        with open(f"./{path}/{i}.jpg", "wb") as f:
            f.write(res.content)
        print(i, "正在下载")
    except:
        pass
    # 给一个自省时间 防止给服务器造成太大的压力 避免服务器崩溃或者当前被封
    time.sleep(random.randint(1, 4))
    i += 1
```

## 5 豆瓣选电影抓取异步多页

```python
import os.path
import random
import time
import requests

# https://movie.douban.com/explore

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
    "Referer": "https://movie.douban.com/explore",
    "Cookie": 'bid=Xnvpbf2UbNg; __utmz=30149280.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=5028ab4b8008b53a-220b4cdd1ed600d1:T=1662087122:RT=1662087122:S=ALNI_MaI55OFkTI5OzNkCDeyUH-1zy45GA; ll="108288"; __gpi=UID=000009611986ae99:T=1662087122:RT=1662343032:S=ALNI_MZVkkj-vdzxwX6USZE71UDU76THeA; gr_user_id=fd68f82d-ef5b-4795-af4d-659a761a5b01; ap_v=0,6.0; __utma=30149280.1908426674.1662087122.1675222882.1675258117.8; __utmb=30149280.0.10.1675258117; __utmc=30149280; dbcl2="217661198:AoacdqjqELA"; ck=DvZ3; push_noty_num=0; push_doumail_num=0; frodotk_db="f3dfd9567fbe2376db9f8c037f3a6a62"',
}
# url = 'https://m.douban.com/rexxar/api/v2/movie/recommend?refresh=0&start=0&count=20&selected_categories=%7B%7D&uncollect=false&tags=&ck=DvZ3'
for i in range(0, 61, 20):
    # 拼凑完成多页的url
    url = f"https://m.douban.com/rexxar/api/v2/movie/recommend?refresh=0&start={i}&count=20&selected_categories=%7B%7D&uncollect=false&tags=&ck=DvZ3"
    res = requests.get(url, headers=headers)
    items = res.json()["items"]
    print(items)
    # 给一个自省时间 防止给服务器造成太大的压力 避免服务器崩溃或者当前被封
    time.sleep(random.randint(1, 5))
```

## 6 抓取豆瓣 top250 抓取一页

```python
import requests
from lxml import etree

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
    "Cookie": 'bid=Xnvpbf2UbNg; __utmz=30149280.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmz=223695111.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=5028ab4b8008b53a-220b4cdd1ed600d1:T=1662087122:RT=1662087122:S=ALNI_MaI55OFkTI5OzNkCDeyUH-1zy45GA; ll="108288"; _vwo_uuid_v2=D3251E8A7AE16574645A511B7AEFFED12|aa508dc6a83b9857208dc21b35585366; __gpi=UID=000009611986ae99:T=1662087122:RT=1662343032:S=ALNI_MZVkkj-vdzxwX6USZE71UDU76THeA; __yadk_uid=DNXarKIhgDs7OOPwHlDaxNA2wcOjE4aX; gr_user_id=fd68f82d-ef5b-4795-af4d-659a761a5b01; ap_v=0,6.0; __utmc=30149280; __utmc=223695111; dbcl2="217661198:AoacdqjqELA"; ck=DvZ3; push_noty_num=0; push_doumail_num=0; frodotk_db="f3dfd9567fbe2376db9f8c037f3a6a62"; _pk_ses.100001.4cf6=*; __utma=30149280.1908426674.1662087122.1675258117.1675260664.9; __utmb=30149280.0.10.1675260664; __utma=223695111.1605720037.1662087122.1675258117.1675260664.9; __utmt=1; _pk_id.100001.4cf6=6a8c066053743026.1662087122.9.1675260807.1675258543.; __utmb=223695111.10.10.1675260664',
}
# 同步抓取
url = "https://movie.douban.com/top250?start=0&filter="
res = requests.get(url, headers=headers)
html = res.content.decode()
# print(html)
tree = etree.HTML(html)
# 抓取每条数据
div_list = tree.xpath('//div[@class="item"]')
for div in div_list:
    # print(div)
    title = div.xpath('.//span[@class="title"]//text()')
    print(title)
```

## 7 抓取豆瓣 top250 抓取多页

```python
import random
import time

import requests
from lxml import etree

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
    "Cookie": 'bid=Xnvpbf2UbNg; __utmz=30149280.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmz=223695111.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=5028ab4b8008b53a-220b4cdd1ed600d1:T=1662087122:RT=1662087122:S=ALNI_MaI55OFkTI5OzNkCDeyUH-1zy45GA; ll="108288"; _vwo_uuid_v2=D3251E8A7AE16574645A511B7AEFFED12|aa508dc6a83b9857208dc21b35585366; __gpi=UID=000009611986ae99:T=1662087122:RT=1662343032:S=ALNI_MZVkkj-vdzxwX6USZE71UDU76THeA; __yadk_uid=DNXarKIhgDs7OOPwHlDaxNA2wcOjE4aX; gr_user_id=fd68f82d-ef5b-4795-af4d-659a761a5b01; ap_v=0,6.0; __utmc=30149280; __utmc=223695111; dbcl2="217661198:AoacdqjqELA"; ck=DvZ3; push_noty_num=0; push_doumail_num=0; frodotk_db="f3dfd9567fbe2376db9f8c037f3a6a62"; _pk_ses.100001.4cf6=*; __utma=30149280.1908426674.1662087122.1675258117.1675260664.9; __utmb=30149280.0.10.1675260664; __utma=223695111.1605720037.1662087122.1675258117.1675260664.9; __utmt=1; _pk_id.100001.4cf6=6a8c066053743026.1662087122.9.1675260807.1675258543.; __utmb=223695111.10.10.1675260664',
}
# 同步抓取
url = "https://movie.douban.com/top250?start=0&filter="
"""
https://movie.douban.com/top250?start=0&filter=
https://movie.douban.com/top250?start=25&filter=
https://movie.douban.com/top250?start=50&filter=
"""
for i in range(0, 51, 25):
    url = f"https://movie.douban.com/top250?start={i}&filter="
    print(url)
    """
    res = requests.get(url, headers=headers)
    html = res.content.decode()
    # print(html)
    tree = etree.HTML(html)
    # 抓取每条数据
    div_list = tree.xpath('//div[@class="item"]')
    for div in div_list:
        # print(div)
        title = div.xpath('.//span[@class="title"]//text()')
        print(title)
    time.sleep(random.randint(1, 5))
    """
```

## 8 抓取豆瓣 top250 抓取多页

```python
import random
import time

import requests
from lxml import etree

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
    "Cookie": 'bid=Xnvpbf2UbNg; __utmz=30149280.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmz=223695111.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=5028ab4b8008b53a-220b4cdd1ed600d1:T=1662087122:RT=1662087122:S=ALNI_MaI55OFkTI5OzNkCDeyUH-1zy45GA; ll="108288"; _vwo_uuid_v2=D3251E8A7AE16574645A511B7AEFFED12|aa508dc6a83b9857208dc21b35585366; __gpi=UID=000009611986ae99:T=1662087122:RT=1662343032:S=ALNI_MZVkkj-vdzxwX6USZE71UDU76THeA; __yadk_uid=DNXarKIhgDs7OOPwHlDaxNA2wcOjE4aX; gr_user_id=fd68f82d-ef5b-4795-af4d-659a761a5b01; ap_v=0,6.0; __utmc=30149280; __utmc=223695111; dbcl2="217661198:AoacdqjqELA"; ck=DvZ3; push_noty_num=0; push_doumail_num=0; frodotk_db="f3dfd9567fbe2376db9f8c037f3a6a62"; _pk_ses.100001.4cf6=*; __utma=30149280.1908426674.1662087122.1675258117.1675260664.9; __utmb=30149280.0.10.1675260664; __utma=223695111.1605720037.1662087122.1675258117.1675260664.9; __utmt=1; _pk_id.100001.4cf6=6a8c066053743026.1662087122.9.1675260807.1675258543.; __utmb=223695111.10.10.1675260664',
}
# 同步抓取
url = "https://movie.douban.com/top250?start=0&filter="
"""
https://movie.douban.com/top250?start=0&filter=
https://movie.douban.com/top250?start=25&filter=
https://movie.douban.com/top250?start=50&filter=
"""
page = eval(input("输入项抓取几页数据"))

# for i in range(1, page+1):
#     print((i-1)*25)

for i in range(page):
    print(i * 25)
    # url = f'https://movie.douban.com/top250?start={i}&filter='
    # print(url)
    """
    res = requests.get(url, headers=headers)
    html = res.content.decode()
    # print(html)
    tree = etree.HTML(html)
    # 抓取每条数据
    div_list = tree.xpath('//div[@class="item"]')
    for div in div_list:
        # print(div)
        title = div.xpath('.//span[@class="title"]//text()')
        print(title)
    time.sleep(random.randint(1, 5))
    """
```

## 9 抓取电影影评

```python
import requests
from lxml import etree


headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
    "Cookie": 'bid=Xnvpbf2UbNg; __utmz=30149280.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmz=223695111.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=5028ab4b8008b53a-220b4cdd1ed600d1:T=1662087122:RT=1662087122:S=ALNI_MaI55OFkTI5OzNkCDeyUH-1zy45GA; ll="108288"; _vwo_uuid_v2=D3251E8A7AE16574645A511B7AEFFED12|aa508dc6a83b9857208dc21b35585366; __gpi=UID=000009611986ae99:T=1662087122:RT=1662343032:S=ALNI_MZVkkj-vdzxwX6USZE71UDU76THeA; __yadk_uid=DNXarKIhgDs7OOPwHlDaxNA2wcOjE4aX; gr_user_id=fd68f82d-ef5b-4795-af4d-659a761a5b01; ap_v=0,6.0; __utmc=30149280; __utmc=223695111; dbcl2="217661198:AoacdqjqELA"; ck=DvZ3; push_noty_num=0; push_doumail_num=0; frodotk_db="f3dfd9567fbe2376db9f8c037f3a6a62"; _pk_ses.100001.4cf6=*; __utma=30149280.1908426674.1662087122.1675258117.1675260664.9; __utmb=30149280.0.10.1675260664; __utma=223695111.1605720037.1662087122.1675258117.1675260664.9; __utmt=1; _pk_id.100001.4cf6=6a8c066053743026.1662087122.9.1675261909.1675258543.; __utmb=223695111.16.10.1675260664',
}
url = "https://movie.douban.com/review/best/"
res = requests.get(url, headers=headers)
html = res.content.decode()
tree = etree.HTML(html)
# 获取到每条影评的div
div_list = tree.xpath('//div[@class="review-list chart "]/div')
# print(div_list)
for div in div_list:
    # 获取简短影评
    print(div.xpath('.//div[@class="short-content"]//text()'))
```

## 10 抓取电影完整影评

```python
import random
import time

import requests
from lxml import etree


headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
    "Cookie": 'bid=Xnvpbf2UbNg; __utmz=30149280.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmz=223695111.1662087122.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=5028ab4b8008b53a-220b4cdd1ed600d1:T=1662087122:RT=1662087122:S=ALNI_MaI55OFkTI5OzNkCDeyUH-1zy45GA; ll="108288"; _vwo_uuid_v2=D3251E8A7AE16574645A511B7AEFFED12|aa508dc6a83b9857208dc21b35585366; __gpi=UID=000009611986ae99:T=1662087122:RT=1662343032:S=ALNI_MZVkkj-vdzxwX6USZE71UDU76THeA; __yadk_uid=DNXarKIhgDs7OOPwHlDaxNA2wcOjE4aX; gr_user_id=fd68f82d-ef5b-4795-af4d-659a761a5b01; ap_v=0,6.0; __utmc=30149280; __utmc=223695111; dbcl2="217661198:AoacdqjqELA"; ck=DvZ3; push_noty_num=0; push_doumail_num=0; frodotk_db="f3dfd9567fbe2376db9f8c037f3a6a62"; _pk_ses.100001.4cf6=*; __utma=30149280.1908426674.1662087122.1675258117.1675260664.9; __utmb=30149280.0.10.1675260664; __utma=223695111.1605720037.1662087122.1675258117.1675260664.9; __utmt=1; _pk_id.100001.4cf6=6a8c066053743026.1662087122.9.1675261909.1675258543.; __utmb=223695111.16.10.1675260664',
}
url = "https://movie.douban.com/review/best/"
res = requests.get(url, headers=headers)
html = res.content.decode()
tree = etree.HTML(html)
# 获取到每条影评的div
div_list = tree.xpath('//div[@class="review-list chart "]/div')
# print(div_list)
for div in div_list:
    # 获取当前影评的uid
    id = div.xpath("./@data-cid")[0]
    # 拼接完整影评的url
    common_url = f"https://movie.douban.com/j/review/{id}/full"
    # 发起完整影评url的请求
    resc = requests.get(common_url, headers=headers)
    print(resc.json())
    time.sleep(random.randint(1, 5))

"""
https://movie.douban.com/j/review/14955796/full
https://movie.douban.com/j/review/14955233/full
data-cid="14955796"
"""
```