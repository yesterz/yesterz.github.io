import urllib
import json

url = "http://www.baidu.com"
# 构造headers
headers = {
    "User-Agent": "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
}
# 构造请求
request = urllib.request.Request(url, headers=headers)
# 发送请求
response = urllib.request.urlopen(request)
# 获取html字符串
html_str = response.read().decode("utf-8")
print(html_str)
