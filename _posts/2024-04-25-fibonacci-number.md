---
title: Fibonacci Number
date: 2024-04-25 08:12:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, Sword To Offer, Recursion, Memoization, Math, Dynamic Programming]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/fibonacci-number/>

* Recursive

```java
class Solution {
    public int fib(int n) {
        // base case
        if (n == 0 || n == 1) {
            return n;
        }

        return fib(n - 1) + fib(n - 2);
    }
}
```

**Complexity**

* Time = O(2^n) 
* Space = O(n) 

---

* DP

```java
class Solution {

    public int fib(int n) {

        if (n == 0 || n == 1) {
            return n;
        }
        
        int[] dp = new int[n+1];      // sub-solutions
        dp[0] = 0;                    // base case
        dp[1] = 1;
        for (int i = 2; i <= n; i++) {
            dp[i] = dp[i - 1] + dp[i - 2];             
        }

        return dp[n];
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 
---