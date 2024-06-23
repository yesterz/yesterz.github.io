---
title: 时空复杂度分析方法
date: 2023-09-20 22:50:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [算法]
pin: false
math: true
mermaid: false
---

## 大O表示法

Big O notation: algorithm complexity (time complexity, space complexity)

e.g., time complexity O(n).

e.g., space complexity: how much memory does it need to run this algorithm. O(n)

e.g., auxiliary space complexity: is the extra space or temporary space used by an algorithm.

| 大O表示法 | 英文 | 中文 |
| --- | --- | --- |
| O(1) | Constant Complexity | 常数复杂度 |
| O(log(n)) | Logarithmix Complexity | 对数复杂度 |
| O(n) | Linear Complexity | 线性时间复杂度 |
| O(n^2) | N square Complexity | 平方 |
| O(n^3) | N cubic Complexity | 立方 |
| O(2^n) | Exponential Growth | 指数 |
| O(n!) | Factorial | 阶乘 |

> 注意：忽略常数、只看最高复杂度的运算
{: .prompt-tip }

## O(1)

```java
int n = 1000;
System.out.println("Hey - your input is: " + n);
```

```java
int n = 1000;
System.out.println("Hey - your input is: " + n);
System.out.println("Hmm... I'm doing more stuff with: " + n);
System.out.println("And more: " + n);
```

## O(log(n))

```java
for (int i = 1; i < n; i = i * 2) {
    System.out.println("Hey - I'm looking at: " + i);
}
```

## O(n)

```java
for (int i = 1; i <= n; i++) {
    System.out.println("Hey - I'm looking at: " + i);
}
```

## O(n^2)

```java
for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= n; j++) {
        System.out.println("Hey - I'm looking at: " + i + " and " + j);
    }
}
```

## O(nlog(n))

```java
void calc(int l, int r) {
    if (l >= r) return;
    for (int i =l; i <= r; i++) { /* print xxx */ }
    int mid = (1 + r) / 2;
    calc(l, mid);
    calc(mid + 1, r);
}
calc(1, n);
```

## O(k^n)

```java
int fib(int n) {
	if (n < 2) return n;
	return fib(n - 1) + fib(n - 2);
}
```

> 注意：斐波那契数列有通项公式！！！！！ F(n) = F(n-1) + F(n-2) 
{: .prompt-tip }

斐波那契数列通项公式：
$$ F_n = \frac{\left(\frac{1 + \sqrt{5}}{2}\right)^n - \left(\frac{1 - \sqrt{5}}{2}\right)^n}{\sqrt{5}} $$

## O(n!)

```java
void dfs(int depth) {
    if (depth == n) {
        // print per
        return;
    }
	for (int i = 0; i < n; i++) {
        if (used[i]) continue;
        used[i] = true;
        per.add(i);
        dfs(depth + 1);
        per.remove(per.size() - 1);
        used[i] = false;
    }
}
dfs(0);
```

## 时间复杂度曲线

- Wikipedia [https://en.wikipedia.org/wiki/Time_complexity](https://en.wikipedia.org/wiki/Time_complexity)
- 维基百科 [https://zh.wikipedia.org/zh-hans/%E6%97%B6%E9%97%B4%E5%A4%8D%E6%9D%82%E5%BA%A6](https://zh.wikipedia.org/zh-hans/%E6%97%B6%E9%97%B4%E5%A4%8D%E6%9D%82%E5%BA%A6)

## 一些常见的式子

1+2+3+...+n = n*(n+1)/2 = **O(n^2)**

n+n/2+n/4+...+1 < 2n = **O(n)**

1+1/2+1/3+...+1/n(调和级数） = **O(log(n))**

## 最坏 vs 均摊

```java
for (int i = 1, j = 1, sum = 0; i <= n; i++) {
    while (j <= n && sum + a[j] <= T) sum += a[j++];
    sum -= a[i];
}
```

对于整段代码，最坏O(n)
对于每个i，内层最坏O(n)，均摊O(1)

```java
for (int i = 1; i <= n; i++) {
    int j = i, sum = 0;
    while (j <= n && sum + a[j] <= T) sum += a[j++];
}
```

对于整段代码，最坏O(n^2)

## 空间复杂度

- 静态数组的长度
- 递归的深度（栈上消耗的空间）
- 动态 new 的空间（堆上消耗的空间）

Linux 栈默认 8M 溢出就是 StackOverFlow

```console
➜  ~ ulimit -a
-t: cpu time (seconds)              unlimited
-f: file size (blocks)              unlimited
-d: data seg size (kbytes)          unlimited
-s: stack size (kbytes)             8192
-c: core file size (blocks)         0
-m: resident set size (kbytes)      unlimited
-u: processes                       55327
-n: file descriptors                1024
-l: locked-in-memory size (kbytes)  65536
-v: address space (kbytes)          unlimited
-x: file locks                      unlimited
-i: pending signals                 55327
-q: bytes in POSIX msg queues       819200
-e: max nice                        0
-r: max rt priority                 0
-N 15:                              unlimited
➜  ~ ulimit -s
8192
➜  ~
```

> B 是 byte，1 KB = 1024 Bytes，1 MB = 1024 KB
{: .prompt-danger }