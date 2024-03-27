---
title: Climbing Stairs
date: 2024-03-27 07:51:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, top-100-liked, Memoization, Math, Dynamic Programming]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/climbing-stairs/>

```java
class Solution {
    public int climbStairs(int n) {
        
        if (n < 3) return n;

        int[] memo = new int[n];
        memo[0] = 1;
        memo[1] = 2;
        for (int i = 2; i < n; ++i) {
            memo[i] = memo[i - 1] + memo[i - 2];
        }

        return memo[n - 1];
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

---