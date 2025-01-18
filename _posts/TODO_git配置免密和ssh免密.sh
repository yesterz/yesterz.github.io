
```java
return new Response<String>(1001, url);
```

Explicit type argument String can be replaced with <> 

explicit adj. clear and exact 清楚明白的；明確的；不含糊的

```java
Map<BigInteger, String> allCategoryIdAndName = null;
```

Variable 'allCategoryIdAndName' initializer 'null' is redundant 

redundant adjective (especially of a word, phrase, etc.) unnecessary because it is more than is needed （尤指词、短语等）多余的，不需要的，累赘的，啰唆的

解决 GitHub 推送不上去的问题

```sh
sudo sh -c 'sed -i "/# GitHub520 Host Start/Q" /etc/hosts && curl https://raw.hellogithub.com/hosts >> /etc/hosts'
```