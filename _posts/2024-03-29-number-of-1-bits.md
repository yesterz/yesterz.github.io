---
title: Number of 1 Bits
date: 2024-03-29 08:14:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, top-100-liked, Bit Manipulation, Divide and Conquer]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/number-of-1-bits/>

```java
class Solution {
    public int hammingWeight(int n) {
        
        int res = 0;
        while (n != 0) {
            res++;
            n &= n - 1;
        }

        return res;
    }
}
```

**Complexity**

* Time = O(k)，k 为 n 的二进制长度
* Space = O(1) 

---