---
title: Single Number
date: 2024-04-15 08:14:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, top-100-liked, Bit Manipulation, Array]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/single-number/>

```java
class Solution {
    public int singleNumber(int[] nums) {

        int single = 0;

        for (int num : nums) {
            single ^= num;
        }

        return single;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

---