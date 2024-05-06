import urllib

# 构造请求
request = urllib.request.Request("http://www.baidu.com")
# 发送请求获取响应
response = urllib.request.urlopen(request)
